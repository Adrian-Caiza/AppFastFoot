import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Importar Supabase
import '../screens/settings_screen.dart';
import '../screens/my_orders_screen.dart';
import '../screens/auth/login_screen.dart'; // 2. Importar Login para redirigir

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column( // CAMBIO: Usamos Column en vez de ListView directo para usar Spacer
        children: [
          // Cabecera del Menú
          UserAccountsDrawerHeader( // Usamos este widget bonito que ya trae Flutter
            decoration: const BoxDecoration(color: Colors.deepOrange),
            accountName: const Text("Usuario FastFoot"), // Podrías poner el nombre real si lo tuvieras
            accountEmail: Text(Supabase.instance.client.auth.currentUser?.email ?? "Invitado"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.deepOrange),
            ),
          ),

          // Opciones del Menú
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context); // Cerrar menú
              // Si ya estamos en inicio, no hacemos nada más
            },
          ),

          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Mis Pedidos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
              );
            },
          ),

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

          const Spacer(), // Esto empuja todo lo que sigue hacia el final de la pantalla
          
          const Divider(), // Una línea divisoria elegante

          // BOTÓN DE CERRAR SESIÓN
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red), // Icono rojo
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              // 1. Cerrar el menú visualmente
              Navigator.pop(context);

              // 2. Cerrar sesión en Supabase
              await Supabase.instance.client.auth.signOut();

              // 3. Redirigir al Login y BORRAR todo el historial de navegación anterior
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // false significa: "borra todas las rutas anteriores"
                );
              }
            },
          ),
          
          const SizedBox(height: 20), // Un pequeño espacio al final
        ],
      ),
    );
  }
}