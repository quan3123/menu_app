import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/food_model.dart';

class ApiService {
    static List<String>? cachedCategories;
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Fetch a list of meals by category
  /// Throws [Exception] if the request fails
  static Future<List<FoodItem>> fetchFoodByCategory(String category) async {
    try {
      final url = Uri.parse('$_baseUrl/filter.php?c=$category');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null) {
          throw Exception('No meals found');
        }

        return meals
            .map((meal) => FoodItem.fromJson(meal))
            .toList();
      } else {
        throw Exception(
            'Failed to load meals. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch a list of all categories
  /// Throws [Exception] if the request fails
  static Future<List<String>> fetchCategories() async {
    if (cachedCategories != null && cachedCategories!.isNotEmpty) {
      return cachedCategories!;
    }
    try {
      final url = Uri.parse('$_baseUrl/categories.php');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final categories = json['categories'] as List?;

        if (categories == null) {
          throw Exception('No categories found');
        }

        cachedCategories = categories
            .map((cat) => cat['strCategory'] as String)
            .toList();
        return cachedCategories!;
      } else {
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (cachedCategories != null && cachedCategories!.isNotEmpty) {
        return cachedCategories!;
      }
      rethrow;
    }
  }

  /// Fetch meal details by meal ID
  /// Throws [Exception] if the request fails
  static Future<FoodItem> fetchMealDetail(String mealId) async {
    try {
      final url = Uri.parse('$_baseUrl/lookup.php?i=$mealId');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null || meals.isEmpty) {
          throw Exception('Meal not found');
        }

        return FoodItem.fromJson(meals.first);
      } else {
        throw Exception(
            'Failed to load meal. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
