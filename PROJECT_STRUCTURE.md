# 📦 Project Structure - Menu App

## Complete File Organization

```
menuapp/
│
├── lib/
│   ├── main.dart                          ✅ Entry point - App & Main Screen setup
│   │
│   ├── models/
│   │   └── food_model.dart               ✅ FoodItem model with JSON parsing
│   │
│   ├── services/
│   │   └── api_service.dart              ✅ API calls with try-catch (static methods)
│   │       - fetchFoodByCategory()
│   │       - fetchCategories()
│   │       - fetchMealDetail()
│   │
│   ├── screens/
│   │   └── menu_screen.dart              ✅ Main stateful screen
│   │       - LoadingState enum
│   │       - State management (_state, _foods, _error)
│   │       - _loadCategories() - Load on init
│   │       - _loadFoods() - Load when category selected
│   │       - _retryLoadFoods() - Retry on error
│   │       - _buildContent() - Build UI based on state
│   │
│   └── widgets/
│       ├── loading_widget.dart           ✅ Loading state UI
│       │   - CircularProgressIndicator
│       │   - Loading message
│       │
│       ├── error_widget.dart             ✅ Error state UI
│       │   - Error icon
│       │   - Error message
│       │   - Retry button (REQUIRED)
│       │
│       └── food_item_card.dart           ✅ Individual food card
│           - Network image with error handler
│           - Food name (2 lines max, truncated)
│           - Category + Area
│           - Ingredient count badge
│
├── pubspec.yaml                           ✅ Dependencies (flutter, http)
├── analysis_options.yaml                  ✅ Dart linting rules
└── README.md                              ✅ Project documentation
```

## Data Flow

```
main.dart (Entry)
    │
    ├─→ MenuScreen (Stateful)
    │    │
    │    ├─→ initState()
    │    │    └─→ _loadCategories()
    │    │         └─→ ApiService.fetchCategories()
    │    │              └─→ HTTP GET /categories.php
    │    │
    │    ├─→ onCategorySelected()
    │    │    └─→ _loadFoods()
    │    │         └─→ ApiService.fetchFoodByCategory(category)
    │    │              └─→ HTTP GET /filter.php?c={category}
    │    │
    │    ├─→ onRetryTap()
    │    │    └─→ _retryLoadFoods()
    │    │         └─→ _loadFoods()
    │    │
    │    └─→ _buildContent() - Build UI based on _state
    │         ├─→ LoadingState.loading
    │         │    └─→ LoadingWidget()
    │         ├─→ LoadingState.error
    │         │    └─→ ErrorStateWidget()
    │         ├─→ LoadingState.success
    │         │    └─→ GridView (2 columns)
    │         │         └─→ FoodItemCard() × n
    │         └─→ LoadingState.initial
    │              └─→ SizedBox.expand()
    │
    ├─→ ApiService (Static methods)
    │    ├─→ fetchFoodByCategory()
    │    │    ├─→ URI.parse()
    │    │    ├─→ http.get() with timeout (10s)
    │    │    ├─→ jsonDecode()
    │    │    ├─→ map to FoodItem
    │    │    └─→ catch → throws Exception
    │    │
    │    ├─→ fetchCategories()
    │    │    └─→ Similar to above
    │    │
    │    └─→ fetchMealDetail()
    │         └─→ Similar to above
    │
    ├─→ FoodItem Model
    │    ├─→ Properties: id, name, category, image, area, instructions, ingredients
    │    ├─→ fromJson() - Parse API response
    │    └─→ toJson() - Serialize to JSON
    │
    └─→ UI Widgets
         ├─→ LoadingWidget
         │    └─→ CircularProgressIndicator + message
         ├─→ ErrorStateWidget  
         │    └─→ Error icon + message + Retry button
         └─→ FoodItemCard
              └─→ Image + Title + Category + Area + Ingredients
```

## State Machine

```
┌────────────────┐
│    INITIAL     │◄──────────────────────────┐
└────────────────┘                           │
        │ (initState)                        │
        │ _loadCategories()                  │
        │                                    │
        ├─────────(Success)─────────────────┤
        │                                    │
        ▼                                    │
┌───────────────────────────────────────────────────────┐
│ Categories loaded - Display category filter chips    │
│ Click category → _loadFoods()                         │
└───────────────────────────────────────────────────────┘
        │
        ├─────────────┬──────────────┐
        │             │              │
        ▼             ▼              ▼
    LOADING       SUCCESS         ERROR
    ◄────────────────────────────────►
        │             │              │
        │             │              │
    Retry─────────────┼──────────Retry
        │             │              │
        └──────┬──────┴────┬─────────┘
               │           │
               └───────────┘
                  (Retry button)
```

## 3 States Implementation

### 1. **LoadingState.loading**
```dart
if (_state == LoadingState.loading) {
  return LoadingWidget(message: 'Đang tải menu từ $_selectedCategory...');
}
```
**UI Shows**: Spinning CircularProgressIndicator + message

### 2. **LoadingState.success**
```dart
if (_state == LoadingState.success) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (_, index) => FoodItemCard(food: _foods[index]),
  );
}
```
**UI Shows**: GridView with 2 columns of food cards

### 3. **LoadingState.error**
```dart
if (_state == LoadingState.error) {
  return ErrorStateWidget(error: _error, onRetry: _retryLoadFoods);
}
```
**UI Shows**: Error icon + message + Retry button (✅ REQUIRED)

## API Integration

### TheMealDB API Endpoints Used

```
Base URL: https://www.themealdb.com/api/json/v1/1

1. Get Categories
   GET /categories.php
   Response: {categories: [{strCategory: "Seafood", ...}, ...]}

2. Get Foods by Category  
   GET /filter.php?c=Seafood
   Response: {meals: [{idMeal: "52973", strMeal: "Baked salmon...", ...}, ...]}

3. Get Single Meal Detail
   GET /lookup.php?i=52973
   Response: {meals: [{strInstructions, strIngredient1, strMeasure1, ...}]}

Error Handling:
- Timeout: 10 seconds
- No cache (fresh data each time)
- Null-safe parsing (check null values)
- Exception caught and displayed
```

## Code Quality Checklist

- [x] **Separation of Concerns**
  - Models in `/models`
  - API calls in `/services`
  - UI in `/screens` and `/widgets`
  - No business logic in main.dart

- [x] **Error Handling**
  - All API calls wrapped in try-catch
  - Timeout handling (10s)
  - User-friendly error messages
  - Retry mechanism

- [x] **State Management**
  - Enum for LoadingState
  - setState() for UI updates
  - Mount checks to prevent memory leaks

- [x] **UI/UX**
  - Responsive GridView (2 columns)
  - Loading indicator (not blank screen)
  - Error UI with Retry button
  - Card-based design
  - Text overflow handling (ellipsis)

- [x] **Best Practices**
  - Const constructors where possible
  - Null-safe operator (?.)
  - Type safety (generic types for List<T>)
  - Proper asset loading (images with error handler)

## How to Customize

### 1. Change Student Info
Edit `lib/main.dart`:
```dart
home: const MenuScreen(
  studentName: 'YOUR_NAME',      // ← Change this
  studentId: 'YOUR_ID',          // ← Change this
),
```

### 2. Change Category on Startup
Edit `lib/screens/menu_screen.dart`:
```dart
String _selectedCategory = 'Seafood';  // ← Change default category
```

### 3. Change GridView Columns
Edit `lib/screens/menu_screen.dart`:
```dart
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,  // ← Change from 2 to 3 columns
),
```

### 4. Change Colors
Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),  // ← Change color
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8    # iOS-style icons
  http: ^1.1.0               # HTTP requests

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0      # Code linting
```

Run: `flutter pub get`

## Running the App

```bash
# Terminal
cd c:\Users\Acer\menuapp

# Get dependencies
flutter pub get

# Run app
flutter run

# Run with release mode
flutter run --release

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices
```

## File Sizes (Approximate)

- main.dart: 20 lines (entry point only)
- food_model.dart: 45 lines (model + parsing)
- api_service.dart: 75 lines (3 API methods + exception handling)
- menu_screen.dart: 180 lines (state management + UI logic)
- loading_widget.dart: 30 lines (minimal loading UI)
- error_widget.dart: 50 lines (error UI + retry button)
- food_item_card.dart: 80 lines (card design)

**Total**: ~480 lines of clean, organized code

## Testing Scenarios

### ✅ Test 1: Normal Flow
1. App starts → Shows categories
2. Click category → Shows loading spinner
3. Data loads → GridView with 2 columns appears

### ✅ Test 2: Error Handling
1. Disconnect WiFi/Mobile
2. App shows error message + Retry button
3. Click Retry with connection back → Data loads

### ✅ Test 3: Category Switching
1. Select different categories
2. Each shows loading spinner → new data loads
3. Smooth transitions between categories

### ✅ Test 4: AppBar Display
1. Check AppBar shows: "TH3 - [Name] - [ID]"
2. Verify text is readable and properly formatted

---

**Summary**: Complete, production-ready Flutter app meeting all assignment requirements! 🚀
