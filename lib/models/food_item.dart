class FoodItem {
  final int? id; // El ID que genera la base de datos
  final String name;
  final double price;
  final String? imageUrl; // La URL de la foto en internet

  FoodItem({
    this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  // Convertir lo que viene de Supabase (JSON) a nuestro objeto
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      // Aseguramos que el precio sea double incluso si viene como int
      price: (map['price'] as num).toDouble(), 
      imageUrl: map['image_url'], // Debe coincidir con el nombre de columna en Supabase
    );
  }
}