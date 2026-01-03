import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importar Supabase
import 'screens/welcome_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Función main asíncrona para esperar la inicialización
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // INICIALIZACIÓN DE SUPABASE
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '', // Leemos la URL
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '', // Leemos la Key
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