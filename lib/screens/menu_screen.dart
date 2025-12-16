import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importar Supabase
import '../models/food_item.dart';
import '../widgets/side_menu.dart';
import 'detail_screen.dart';
import 'add_product_screen.dart'; // Importar la pantalla de agregar

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Flujo de datos desde Supabase
  final _foodStream = Supabase.instance.client.from('foods').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menú Supabase"), backgroundColor: Colors.deepOrange),
      drawer: const SideMenu(),
      
      // Botón flotante para Agregar Productos (Solo visible si quieres probar el CRUD)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
        },
      ),

      // StreamBuilder escucha cambios en la base de datos en tiempo real
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _foodStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final foods = snapshot.data!;
          
          if (foods.isEmpty) {
            return const Center(child: Text("No hay productos aún. ¡Agrega uno!"));
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8, // Ajustamos la proporción para que quepan las fotos
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                // Convertimos el mapa a nuestro objeto FoodItem
                final item = FoodItem.fromMap(foods[index]);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
                      border: Border.all(color: Colors.deepOrange.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // IMAGEN DESDE INTERNET (Supabase)
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: item.imageUrl != null
                                ? Image.network(
                                    item.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.fastfood, size: 50, color: Colors.orange),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text("\$${item.price}", style: const TextStyle(color: Colors.deepOrange)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}