import 'package:flutter/material.dart';
import 'menu_screen.dart'; // Importamos el menú para poder ir allá

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange, // Fondo naranja para llamar la atención
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo grande
              const CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: Icon(Icons.fastfood, size: 80, color: Colors.deepOrange),
              ),
              
              const SizedBox(height: 30),
              
              // Nombre de la App
              const Text(
                "FastFoot",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Frase / Descripción
              const Text(
                "¡El sabor que te mueve!\nLa mejor comida rápida en la puerta de tu casa.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70, // Blanco con un poco de transparencia
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Botón de Acción
              SizedBox(
                width: double.infinity, // Que ocupe todo el ancho posible
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Usamos pushReplacement para que al dar "Atrás" en el menú,
                    // no vuelva a esta pantalla de bienvenida, sino que salga de la app.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MenuScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Botón blanco
                    foregroundColor: Colors.deepOrange, // Texto naranja
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bordes redondeados
                    ),
                  ),
                  child: const Text(
                    "VER MENÚ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}