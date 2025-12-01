import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // 1. Clave global para identificar el formulario y validarlo
  final _formKey = GlobalKey<FormState>();
  
  // Controlador para obtener el texto si lo necesitamos luego
  final _addressController = TextEditingController();

  @override
  void dispose() {
    // Limpiamos el controlador cuando se cierra la pantalla
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmar Pedido")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 2. Envolvemos todo en un widget Form
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Resumen del Pedido", style: TextStyle(fontSize: 20)),
              
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("1x Hamburguesa (Mediana)"),
                      subtitle: Text("Combo: Sí, Extras: Queso"),
                      trailing: Text("\$8.50"),
                    ),
                    ListTile(
                      leading: Icon(Icons.local_shipping, color: Colors.grey),
                      title: Text("Costo de envío"),
                      trailing: Text("\$2.00"),
                    ),
                  ],
                ),
              ),

              const Divider(),
              
              // 3. Usamos TextFormField en lugar de TextField para validar
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Dirección de entrega *", // El * indica obligatorio
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.map),
                ),
                // Lógica de validación
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una dirección';
                  }
                  if (value.length < 5) {
                    return 'La dirección es muy corta';
                  }
                  return null; // Null significa que es válido
                },
              ),
              
              const SizedBox(height: 10),
              
              // Este lo dejamos como TextField normal (opcional)
              const TextField(
                decoration: InputDecoration(
                  labelText: "Notas para el repartidor (Opcional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // 4. Ejecutamos la validación al presionar
                      if (_formKey.currentState!.validate()) {
                        // Si es válido, mostramos el mensaje y salimos
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Enviando a: ${_addressController.text}"),
                              backgroundColor: Colors.green,
                            )
                        );
                        // Simulamos una espera y volvemos al inicio
                        Future.delayed(const Duration(seconds: 2), () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                        });
                      } else {
                        // Si falla, Flutter muestra el error en rojo automáticamente
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Revisa los errores en rojo"),
                              backgroundColor: Colors.red,
                            )
                        );
                      }
                    },
                    child: const Text("Confirmar y Pagar"),
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