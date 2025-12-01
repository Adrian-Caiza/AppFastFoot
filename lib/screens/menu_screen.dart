import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../widgets/side_menu.dart';
import 'detail_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados
    final List<FoodItem> items = [
      FoodItem("Hamburguesa", Colors.orange, 5.99, Icons.lunch_dining), 
      FoodItem("Papas Fritas", Colors.yellow, 2.50, Icons.restaurant),    
      FoodItem("Refresco", Colors.brown, 1.50, Icons.local_drink),      
      FoodItem("Pizza", Colors.redAccent, 8.00, Icons.local_pizza),     
      FoodItem("Helado", Colors.pinkAccent, 3.00, Icons.icecream),      
      FoodItem("Nuggets", Colors.amber, 4.50, Icons.bento),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Fast Food Menu" ), backgroundColor: Colors.deepOrange,),
      drawer: const SideMenu(), // Usamos el widget separado
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(item: items[index])),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: items[index].color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: items[index].color),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[index].icon, size: 50, color: items[index].color),
                    const SizedBox(height: 10),
                    Text(items[index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("\$${items[index].price}"),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}