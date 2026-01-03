import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderScreen extends StatefulWidget {
  // Variables para recibir los datos del Detalle
  final String productName;
  final double totalPrice;
  final String orderDetails; // Ej: "Tamaño: Mediano, Con Queso"

  const OrderScreen({
    super.key,
    required this.productName,
    required this.totalPrice,
    required this.orderDetails,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  // Función para Guardar el Pedido en Supabase
  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user == null) {
        throw "Usuario no identificado";
      }

      // INSERTAR EN LA TABLA 'ORDERS'
      await Supabase.instance.client.from('orders').insert({
        'user_id': user.id, // ID del usuario logueado
        'total_price': widget.totalPrice,
        'address': _addressController.text,
        'status': 'Pendiente',
        'items': { // Guardamos los detalles como un objeto JSON
          'product': widget.productName,
          'details': widget.orderDetails,
          'notes': _notesController.text
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Pedido realizado con éxito! 🚀"), backgroundColor: Colors.green)
        );
        // Volver al menú principal eliminando el historial de navegación
        Navigator.popUntil(context, (route) => route.isFirst);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red)
        );
      }
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmar Pedido")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Resumen", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              // Tarjeta de Resumen Dinámica
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.deepOrange),
                  title: Text(widget.productName),
                  subtitle: Text(widget.orderDetails),
                  trailing: Text("\$${widget.totalPrice.toStringAsFixed(2)}", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 20),
              
              // Campo Dirección
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Dirección de entrega *",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.map),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'La dirección es obligatoria';
                  return null;
                },
              ),
              
              const SizedBox(height: 10),
              
              // Campo Notas
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: "Notas para el repartidor (Opcional)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),

              const Spacer(),

              // Botones de Acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange, 
                        foregroundColor: Colors.white
                      ),
                      onPressed: _isLoading ? null : _submitOrder,
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("CONFIRMAR PEDIDO"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}