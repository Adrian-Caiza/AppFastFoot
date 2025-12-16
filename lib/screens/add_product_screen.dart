import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile; // Para guardar la foto seleccionada temporalmente
  bool _isLoading = false;

  // 1. Función para seleccionar imagen de la galería
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // 2. Función para subir todo a Supabase
  Future<void> _uploadProduct() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faltan datos o imagen')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // A. Subir la imagen al Bucket 'food-images'
      await Supabase.instance.client.storage
          .from('food-images')
          .upload(fileName, _imageFile!);

      // B. Obtener la URL pública de esa imagen
      final String imageUrl = Supabase.instance.client.storage
          .from('food-images')
          .getPublicUrl(fileName);

      // C. Guardar los datos en la tabla 'foods'
      await Supabase.instance.client.from('foods').insert({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'image_url': imageUrl, // Guardamos el link
        'category': 'General',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Producto Agregado!'), backgroundColor: Colors.green));
        Navigator.pop(context); // Volver al menú
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
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Área para tocar y subir foto
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
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            Text("Toca para subir imagen"),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre del producto", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Precio (ej. 5.99)", border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _uploadProduct,
                  child: _isLoading ? const CircularProgressIndicator() : const Text("GUARDAR PRODUCTO"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}