import 'package:flutter/material.dart';
import '../models/food_item.dart';
import 'order_screen.dart';

class DetailScreen extends StatefulWidget {
  final FoodItem item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isCombo = false;
  bool extraCheese = false;
  int selectedSize = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: widget.item.color,
                child: Center(child: Icon(widget.item.icon, size: 100, color: Colors.white)),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
                },
                child: const Text("Agregar al Carrito"),
              ),
            ),
          )
        ],
      ),
    );
  }
}