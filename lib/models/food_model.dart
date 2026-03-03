class FoodItem {
  final String id;
  final String name;
  final String category;
  final String image;
  final String area;
  final String instructions;
  final List<String> ingredients;
  final double rating;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.area,
    required this.instructions,
    required this.ingredients,
    required this.rating,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients.add(ingredient.toString());
      }
    }
    // Sinh số sao ngẫu nhiên kiểu x.x từ 3.0 đến 5.0
    final hash = (json['idMeal']?.hashCode ?? 0) % 200;
    final rating = 3.0 + (hash / 100);
    return FoodItem(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      image: json['strMealThumb'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
      rating: double.parse(rating.toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strMealThumb': image,
      'strArea': area,
      'strInstructions': instructions,
      'rating': rating,
    };
  }
}
