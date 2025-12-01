import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Un ícono grande alusivo
              Icon(Icons.construction, size: 100, color: Colors.grey[400]),
              
              const SizedBox(height: 20),
              
              // El mensaje solicitado
              const Text(
                "¡¡Proximamente en FastFoot!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              
              const SizedBox(height: 10),
              
              const Text(
                "Estamos cocinando nuevas opciones para ti.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // Botón para volver
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Regresa a la pantalla anterior
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Volver al Menú"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}