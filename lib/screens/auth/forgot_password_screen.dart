import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importamos http
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe tu correo'))
      );
      return;
    }

    setState(() => _isLoading = true);

    // 1. OBTENER CREDENCIALES
    // Usamos las mismas variables de entorno que ya configuraste
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseKey == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error de configuración (.env)')));
       setState(() => _isLoading = false);
       return;
    }

    try {
      // 2. HACER PETICIÓN HTTP MANUAL (Bypass PKCE)
      // Al hacer esto "a mano" sin enviar 'code_challenge', Supabase usará flujo Implícito.
      final url = Uri.parse('$supabaseUrl/auth/v1/recover');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'apikey': supabaseKey,
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
          // IMPORTANTE: Tu URL de Vercel exacta
          'redirect_to': 'https://fastfoot-web.vercel.app/', 
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Correo enviado! Revisa tu bandeja (y spam).'),
              backgroundColor: Colors.green
            ),
          );
          Navigator.pop(context); // Volver al login
        }
      } else {
        // Manejo de errores que vienen del servidor
        final errorJson = jsonDecode(response.body);
        throw errorJson['msg'] ?? 'Error al enviar correo';
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar Contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Ingresa tu correo y te enviaremos un enlace mágico.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Correo Electrónico", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                child: _isLoading ? const CircularProgressIndicator() : const Text("ENVIAR CORREO"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}