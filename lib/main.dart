import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importar Supabase
import 'screens/welcome_screen.dart';

// Función main asíncrona para esperar la inicialización
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INICIALIZACIÓN DE SUPABASE
  await Supabase.initialize(
    url: 'https://mmvbwiozwwvvmyhpepdk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1tdmJ3aW96d3d2dm15aHBlcGRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU4OTk5MTUsImV4cCI6MjA4MTQ3NTkxNX0.dvuJVNE_8SgfkD3pt-I--yDk2yyxo5UIyuxBQIINi6I',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Food Flutter',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}