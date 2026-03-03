import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/api_service.dart';
import '../widgets/loading_widget.dart';
// import '../widgets/error_widget.dart';
import '../widgets/food_item_card.dart';
import 'food_detail_screen.dart';

enum LoadingState { initial, loading, success, error }

class MenuScreen extends StatefulWidget {
  final String studentName;
  final String studentId;

  const MenuScreen({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
    String _searchQuery = '';
  LoadingState _state = LoadingState.initial;
  List<FoodItem> _foods = [];
  String _error = '';
  String _selectedCategory = 'Seafood';
  List<String> _categories = [];
  static const List<String> _defaultCategories = [
    'Beef', 'Chicken', 'Seafood', 'Vegetarian', 'Dessert', 'Pasta', 'Pork', 'Lamb', 'Breakfast'
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          if (categories.contains(_selectedCategory)) {
            // Không đổi loại món
          } else if (categories.isNotEmpty) {
            _selectedCategory = categories.first;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Loại món đã chọn không còn, chuyển sang: ${categories.first}')),
            );
          }
        });
        _loadFoods();
      }
    } catch (e) {
      // Luôn hiển thị bộ lọc với loại mặc định nếu không có dữ liệu
      final cached = ApiService.cachedCategories;
      if (mounted) {
        setState(() {
          _categories = (cached != null && cached.isNotEmpty) ? cached : _defaultCategories;
          _error = 'Lỗi tải danh mục: ${e.toString()}';
          if (_categories.isEmpty) {
            _state = LoadingState.error;
          }
        });
        if (_categories.isNotEmpty) {
          _loadFoods();
        }
      }
    }
  }

  Future<void> _loadFoods() async {
    try {
      if (mounted) {
        setState(() {
          _state = LoadingState.loading;
          _error = '';
        });
      }

      final foods = await ApiService.fetchFoodByCategory(_selectedCategory);

      if (mounted) {
        setState(() {
          _foods = foods;
          _state = LoadingState.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = LoadingState.error;
          _error = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  void _retryLoadFoods() {
    _loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TH3 - ${widget.studentName} - ${widget.studentId}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm món ăn...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_categories.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.filter_list),
                label: Text('Lọc loại món: $_selectedCategory'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final selected = await showDialog<String>(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Chọn loại món'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _categories.length,
                            itemBuilder: (context, idx) {
                              final cat = _categories[idx];
                              return ListTile(
                                title: Text(cat),
                                selected: cat == _selectedCategory,
                                onTap: () => Navigator.of(ctx).pop(cat),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                  if (selected != null && selected != _selectedCategory) {
                    setState(() {
                      _selectedCategory = selected;
                    });
                    _loadFoods();
                  }
                },
              ),
            ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case LoadingState.loading:
        return LoadingWidget(
          message: 'Đang tải menu từ $_selectedCategory...',
        );

      case LoadingState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Mất kết nối mạng!',
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _retryLoadFoods,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );

      case LoadingState.success:
        final filteredFoods = _searchQuery.isEmpty
            ? _foods
            : _foods.where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
        if (filteredFoods.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.no_food,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Không có dữ liệu',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredFoods.length,
          itemBuilder: (context, index) {
            return FoodItemCard(
              food: filteredFoods[index],
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
                try {
                  final detail = await ApiService.fetchMealDetail(filteredFoods[index].id);
                  if (context.mounted) {
                    Navigator.of(context).pop(); // remove loading
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FoodDetailScreen(food: detail),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi tải chi tiết món ăn: $e')),
                    );
                  }
                }
              },
            );
          },
        );

      case LoadingState.initial:
        return const SizedBox.expand();
    }
  }
}
