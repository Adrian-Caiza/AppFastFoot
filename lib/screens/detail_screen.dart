import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_item.dart';
import 'order_screen.dart';
import 'add_product_screen.dart';

class DetailScreen extends StatefulWidget {
  final FoodItem item; // Usamos esto solo para obtener el ID inicial
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isCombo = false;
  bool extraCheese = false;
  int selectedSize = 1;

  // Stream para escuchar cambios EN ESTE producto específico en tiempo real
  late final Stream<List<Map<String, dynamic>>> _productStream;

  @override
  void initState() {
    super.initState();
    // Escuchamos la tabla 'foods' donde el ID coincida con este producto
    _productStream = Supabase.instance.client
        .from('foods')
        .stream(primaryKey: ['id'])
        .eq('id', widget.item.id!);
  }

  Future<void> _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Estás seguro?"),
        content: const Text("Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Borrar", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Supabase.instance.client.from('foods').delete().eq('id', widget.item.id!);
      if (mounted) {
        Navigator.pop(context); // Salir tras borrar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Envolvemos todo en un StreamBuilder
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _productStream,
      builder: (context, snapshot) {
        // 1. Si no hay datos aún, mostramos carga
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 2. Si la lista está vacía (significa que el producto fue borrado), salimos
        if (snapshot.data!.isEmpty) {
          return const Scaffold(body: Center(child: Text("Producto no disponible")));
        }

        // 3. Obtenemos el "Producto Vivo" (Live Data)
        final liveItemData = snapshot.data!.first;
        final liveItem = FoodItem.fromMap(liveItemData);

        // A partir de aquí construimos la interfaz con 'liveItem' en vez de 'widget.item'
        return Scaffold(
          appBar: AppBar(
            title: Text(liveItem.name), // Usamos el nombre vivo
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Pasamos el liveItem para editar la versión más reciente
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AddProductScreen(productToEdit: liveItem))
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _deleteProduct,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: liveItem.imageUrl != null
                        ? Image.network(liveItem.imageUrl!, fit: BoxFit.cover)
                        : Container(color: Colors.orange, child: const Icon(Icons.fastfood, size: 100)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite_border, color: Colors.red),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Mostrar Precio Vivo
                    Text("\$${liveItem.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                    
                    const SizedBox(height: 10),
                    const Text("Personaliza tu orden", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("¿Hacerlo Combo? (+\$2.00)"),
                        Switch(
                          value: isCombo,
                          onChanged: (val) => setState(() => isCombo = val),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: extraCheese,
                          onChanged: (val) => setState(() => extraCheese = val!),
                        ),
                        const Text("Añadir Queso Extra"),
                      ],
                    ),
                    const Divider(),
                    const Text("Tamaño:"),
                    Row(
                      children: [
                        Flexible(
                          child: RadioListTile(
                            title: const Text("Chico"),
                            value: 0,
                            groupValue: selectedSize,
                            onChanged: (val) => setState(() => selectedSize = val!),
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            title: const Text("Med"),
                            value: 1,
                            groupValue: selectedSize,
                            onChanged: (val) => setState(() => selectedSize = val!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      double finalPrice = liveItem.price; // Usamos precio vivo
                      if (isCombo) finalPrice += 2.00;
                      
                      String sizeStr = selectedSize == 0 ? "Chico" : (selectedSize == 1 ? "Mediano" : "Grande");
                      String details = "Tamaño: $sizeStr";
                      if (isCombo) details += " | Combo";
                      if (extraCheese) details += " | Queso Extra";

                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => OrderScreen(
                          productName: liveItem.name, // Nombre vivo
                          totalPrice: finalPrice,
                          orderDetails: details,
                        ))
                      );
                    },
                    child: Text("Comprar por \$${(liveItem.price + (isCombo ? 2.0 : 0.0)).toStringAsFixed(2)}"),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}