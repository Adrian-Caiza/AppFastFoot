import 'package:flutter/material.dart';
import '../screens/order_screen.dart'; 
import '../screens/welcome_screen.dart'; 
import '../screens/settings_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange),
            child: Text(
              'Menú Principal', 
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          
          // OPCIÓN 1: INICIO
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              // Simplemente cerramos el menú
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),

          // OPCIÓN 2: MIS PEDIDOS
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Mis Pedidos'),
            onTap: () {
              
              Navigator.pop(context);
              
              
              // Navegamos a la pantalla
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderScreen()),
              );
            },
          ),

          // OPCIÓN 3: CONFIGURACIÓN
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              
              Navigator.pop(context);

              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}