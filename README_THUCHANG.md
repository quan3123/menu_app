# 🍽️ Menu App - Ứng dụng Gọi API và Hiển thị Menu Món Ăn

## 📋 Tổng quan Dự án

Ứng dụng Flutter này thực hiện gọi dữ liệu thực tế từ API công khai **(TheMealDB)** để hiển thị menu các món ăn từ khắp thế giới. Ứng dụng xử lý hoàn toàn 3 trạng thái: **Loading, Success, Error** với UI phù hợp cho mỗi trạng thái.

---

## 🎯 Yêu cầu được hoàn thành

### 1. ✅ AppBar hiển thị định danh sinh viên
```
TH3 - [Họ tên Sinh viên] - [Mã SV]
```

### 2. ✅ Xử lý 3 trạng thái hoàn toàn

#### **Trạng thái Loading (Đang tải)**
- Hiển thị `CircularProgressIndicator` (vòng xoay)
- Không để màn hình trắng tinh
- Thông báo đang tải từ danh mục nào

#### **Trạng thái Success (Thành công)**
- Hiển thị dữ liệu trong `GridView` với 2 cột
- Mỗi item là một `Card` gọn gàng với:
  - Hình ảnh món ăn (cắt góc tròn)
  - Tên món ăn (tối đa 2 dòng, cắt gọn nếu quá dài)
  - Danh mục và khu vực (quốc gia)
  - Số lượng nguyên liệu
- Khoảng cách hợp lý

#### **Trạng thái Error (Lỗi)**
- Hiển thị biểu tượng lỗi (❌)
- Thông báo lỗi rõ ràng
- **Nút "Thử lại" (Retry)** - Bắt buộc có để người dùng gọi lại API

### 3. ✅ Tổ chức code sạch sẽ

```
lib/
├── main.dart                 # Entry point
├── models/
│   └── food_model.dart      # Model định nghĩa Food Item
├── services/
│   └── api_service.dart     # Hàm gọi API với try-catch
├── screens/
│   └── menu_screen.dart     # Screen chính, xử lý states
└── widgets/
    ├── loading_widget.dart  # UI Loading state
    ├── error_widget.dart    # UI Error state + Retry button
    └── food_item_card.dart  # Card hiển thị từng item
```

### 4. ✅ Xử lý Exception

Tất cả hàm gọi API đều có `try-catch` để bắt lỗi an toàn:
```dart
try {
  final foods = await ApiService.fetchFoodByCategory(_selectedCategory);
  // xử lý dữ liệu
} catch (e) {
  // hiển thị lỗi
}
```

---

## 📱 Tính năng chính

### 🔄 Chuyển đổi Danh mục
- Hiển thị danh sách các danh mục (Seafood, Dessert, Pasta, v.v.)
- Click vào danh mục để tải dữ liệu từ danh mục đó
- Giao diện `FilterChip` thay đổi màu khi được chọn

### 🖼️ Hiển thị Dữ liệu
- `GridView` với 2 cột cho thiết kế responsive
- Mỗi card hiển thị:
  - Hình ảnh với error handler
  - Tên món (truncate nếu quá dài)
  - Category + Area (quốc gia)
  - Số nguyên liệu

### ⏱️ Xử lý bất đồng bộ
- Loading timeout 10 giây
- Retry khi bấn nút "Thử lại"
- Mount check để tránh memory leak

---

## 🔧 Cách Tùy Chỉnh Thông Tin Sinh Viên

### Mở file `lib/main.dart` và thay đổi:

```dart
home: const MenuScreen(
  studentName: 'Nguyễn Văn A',  // 👈 Thay tên sinh viên
  studentId: 'SV001',            // 👈 Thay mã sinh viên
),
```

Sau đó lưu file, ứng dụng sẽ hot reload và cập nhật AppBar.

---

## 📊 API Được Sử Dụng

### **TheMealDB API** (Free, No Auth)
- **Base URL**: `https://www.themealdb.com/api/json/v1/1`
- **Endpoints**:
  - `GET /categories.php` - Lấy danh sách danh mục
  - `GET /filter.php?c={category}` - Lấy danh sách món ăn theo danh mục
  - `GET /lookup.php?i={mealId}` - Lấy chi tiết món ăn

**Ưu điểm**:
- ✅ Free, không cần API key
- ✅ Dữ liệu thực tế, update thường xuyên
- ✅ Có hình ảnh đẹp
- ✅ Dữ liệu đầy đủ (tagline, area, ingredients, instructions)

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.1.0  # Gọi API
```

**Run**: `flutter pub get`

---

## ▶️ Chạy Ứng Dụng

```bash
cd c:\Users\Acer\menuapp

# Lấy dependencies
flutter pub get

# Chạy trên thiết bị debug
flutter run

# Chạy trên device cụ thể
flutter run -d <device_id>
```

---

## 🎨 Giao Diện & Thiết Kế

- **Chủ đề màu sắc**: Deep Purple (Material 3)
- **Typography**: Material Design 3
- **Responsive**: Hoạt động tốt trên mobile & tablet
- **Animations**: Loading indicator, Chip selection, Card hover effects

---

## 🔍 Cấu trúc Code Chi Tiết

### **1. Model (`models/food_model.dart`)**
```dart
class FoodItem {
  final String id;
  final String name;
  final String category;
  final String image;
  final String area;
  final String instructions;
  final List<String> ingredients;
  
  // Khởi tạo từ JSON API
  factory FoodItem.fromJson(Map<String, dynamic> json) { ... }
}
```

### **2. API Service (`services/api_service.dart`)**
```dart
class ApiService {
  static Future<List<FoodItem>> fetchFoodByCategory(String category) async {
    try {
      // gọi API
      // parse JSON
      // return list
    } catch (e) {
      rethrow; // ném lỗi để xử lý ở UI
    }
  }
}
```

### **3. Main Screen (`screens/menu_screen.dart`)**
```dart
class MenuScreen extends StatefulWidget {
  // Quản lý 3 states: loading, success, error
  // Lấy danh mục khi khởi tạo
  // Lấy dữ liệu khi chọn danh mục
  // Retry khi bấn nút
}
```

### **4. Widgets Riêng Lẻ**
- `LoadingWidget`: Hiển thị CircularProgressIndicator
- `ErrorWidget`: Hiển thị lỗi + nút Retry
- `FoodItemCard`: Card đẹp cho mỗi item

---

## 🐛 Xử lý Lỗi

### Các lỗi được xử lý:
1. **Mất kết nối mạng** → Hiển thị lỗi, cho retry
2. **API timeout** (10 giây) → Thông báo timeout
3. **Invalid JSON** → Catch và hiển thị
4. **Empty response** → Thông báo không có dữ liệu
5. **Network error** → Catch toàn bộ exception

### Exception Handling:
```dart
// Trong model
factory FoodItem.fromJson(Map<String, dynamic> json) {
  // Null-safe khi parse dữ liệu
}

// Trong service
catch (e) {
  rethrow; // ném lỗi cụ thể
}

// Trong screen
catch (e) {
  setState(() {
    _state = LoadingState.error;
    _error = e.toString().replaceAll('Exception: ', '');
  });
}
```

---

## 📝 Ghi chú Quan Trọng

### ✅ Hoàn thành đủ yêu cầu:
- [x] AppBar hiển thị: TH3 - [Tên] - [Mã SV]
- [x] Xử lý 3 states: Loading, Success, Error
- [x] Loading state có CircularProgressIndicator
- [x] Error state có nút Retry
- [x] Tách code thành files riêng
- [x] Try-catch cho API calls
- [x] Sử dụng public API (TheMealDB)
- [x] GridView hiển thị dữ liệu
- [x] Card item gọn gàng, text cắt gọn
- [x] Xử lý async hoàn toàn

### ⚠️ Lưu ý:
- Thay tên & mã SV thực tế trong `main.dart`
- Đảm bảo điện thoại/emulator có kết nối Internet
- TheMealDB API đôi khi chậm, tăng timeout nếu cần
- Hot reload không reset state, dùng hot restart nếu cần

---

## 📚 Tài liệu Tham Khảo

- **Flutter Documentation**: https://flutter.dev/docs
- **Material 3**: https://m3.material.io/
- **TheMealDB API**: https://www.themealdb.com/api.php
- **Dart http package**: https://pub.dev/packages/http

---

## 🎓 Kết Luận

Ứng dụng này là ví dụ hoàn chỉnh về:
- ✅ Gọi API từ Flutter
- ✅ Xử lý Loading, Success, Error states
- ✅ Async/await & try-catch
- ✅ Code organization & separation of concerns
- ✅ UI responsive & user-friendly
- ✅ Exception handling & error recovery

Chúc bạn học tốt! 🚀

---

**Tác giả**: GitHub Copilot  
**Ngày**: 2026-03-03  
**Flutter SDK Version**: 3.10.7+
