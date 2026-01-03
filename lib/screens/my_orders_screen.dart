import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID del usuario actual
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Pedidos")),
      body: userId == null
          ? const Center(child: Text("Debes iniciar sesión"))
          : StreamBuilder<List<Map<String, dynamic>>>(
              // Escuchamos la tabla 'orders' filtrando por user_id y ordenando por fecha
              stream: Supabase.instance.client
                  .from('orders')
                  .stream(primaryKey: ['id'])
                  .eq('user_id', userId)
                  .order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final orders = snapshot.data!;

                if (orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 80, color: Colors.grey),
                        Text("Aún no tienes pedidos"),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final items = order['items']; // El JSON que guardamos
                    
                    // Definir color según estado
                    Color statusColor = Colors.orange;
                    if (order['status'] == 'Entregado') statusColor = Colors.green;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: statusColor.withOpacity(0.2),
                          child: Icon(Icons.receipt, color: statusColor),
                        ),
                        title: Text(items['product'] ?? 'Producto Desconocido'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items['details'] ?? ''),
                            Text("Estado: ${order['status']}", style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        trailing: Text(
                          "\$${order['total_price']}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}