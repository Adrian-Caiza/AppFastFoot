import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_item.dart'; // Importante para recibir el objeto

class AddProductScreen extends StatefulWidget {
  final FoodItem? productToEdit; // Si es null = Crear, Si tiene datos = Editar

  const AddProductScreen({super.key, this.productToEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile; 
  String? _currentImageUrl; // Para mostrar la imagen que ya existía
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Si estamos editando, rellenamos los campos
    if (widget.productToEdit != null) {
      _nameController.text = widget.productToEdit!.name;
      _priceController.text = widget.productToEdit!.price.toString();
      _currentImageUrl = widget.productToEdit!.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = File(image.path));
    }
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faltan datos')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrlToSave = _currentImageUrl;

      // 1. Si el usuario eligió una NUEVA foto, la subimos
      if (_imageFile != null) {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
            .from('food-images')
            .upload(fileName, _imageFile!);
        
        imageUrlToSave = Supabase.instance.client.storage
            .from('food-images')
            .getPublicUrl(fileName);
      }

      final data = {
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'image_url': imageUrlToSave,
        'category': 'General',
      };

      if (widget.productToEdit == null) {
        // --- CREAR NUEVO ---
        if (_imageFile == null) throw "La imagen es obligatoria para nuevos productos";
        await Supabase.instance.client.from('foods').insert(data);
      } else {
        // --- ACTUALIZAR EXISTENTE ---
        await Supabase.instance.client
            .from('foods')
            .update(data)
            .eq('id', widget.productToEdit!.id!); // Buscamos por ID
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.productToEdit == null ? '¡Creado!' : '¡Actualizado!'), backgroundColor: Colors.green)
        );
        Navigator.pop(context); // Volver
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Producto" : "Nuevo Producto")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Lógica visual: Mostrar archivo nuevo O imagen existente O icono vacío
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : (_currentImageUrl != null 
                          ? Image.network(_currentImageUrl!, fit: BoxFit.cover)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.camera_alt, size: 50, color: Colors.grey), Text("Toca para subir")],
                            )),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Precio", border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  child: _isLoading 
                    ? const CircularProgressIndicator() 
                    : Text(isEditing ? "ACTUALIZAR PRODUCTO" : "GUARDAR PRODUCTO"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}