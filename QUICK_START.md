# 🚀 QUICK START GUIDE - Menu App

## ⚡ 1 Phút Để Bắt Đầu

### Step 1️⃣: Update Thông Tin Sinh Viên
Mở file `lib/main.dart` và thay đổi:
```dart
home: const MenuScreen(
  studentName: 'Tên Sinh Viên của Bạn',  // 👈 Thay tên
  studentId: 'MSV123456',                 // 👈 Thay mã
),
```

### Step 2️⃣: Cài Đặt Dependencies
```bash
cd c:\Users\Acer\menuapp
flutter pub get
```

### Step 3️⃣: Kết Nối Thiết Bị/Emulator
```bash
flutter devices
```

### Step 4️⃣: Chạy Ứng Dụng
```bash
flutter run
```

**✅ Xong! Ứng dụng sẽ khởi động với menu món ăn từ thế giới.**

---

## 🎯 Chức Năng Chính

| Tính Năng | Mô Tả |
|-----------|-------|
| 📱 **AppBar** | Hiển thị: `TH3 - [Tên SV] - [Mã SV]` |
| 🍽️ **Menu** | Hiển thị danh mục: Seafood, Dessert, Pasta, v.v. |
| 🔄 **GridView** | 2 cột, mỗi ô là một món ăn |
| ⏳ **Loading** | Hiển thị spinner khi tải |
| ❌ **Error** | Hiển thị lỗi + nút "Thử lại" |
| 📡 **Retry** | Gọi lại API khi bấn nút |

---

## 📁 File Structure

```
lib/
├── main.dart                    ← EDIT THÔNG TIN SV TẠO ĐÂY
├── models/food_model.dart       ← Model Food Item
├── services/api_service.dart    ← API calls (try-catch)
├── screens/menu_screen.dart     ← Main screen (3 states)
└── widgets/
    ├── loading_widget.dart      ← Loading UI
    ├── error_widget.dart        ← Error UI + Retry button
    └── food_item_card.dart      ← Food card design
```

---

## 🔍 Các Trạng Thái (States)

### 1️⃣ Loading State (Đang tải)
```
┌─────────────────────┐
│   ⏳ Spinning       │
│  Đang tải menu...   │
└─────────────────────┘
```

### 2️⃣ Success State (Thành công)
```
┌──────────┬──────────┐
│ Seafood1 │ Seafood2 │ ← 2 cột GridView
├──────────┼──────────┤
│ Seafood3 │ Seafood4 │
└──────────┴──────────┘
```

### 3️⃣ Error State (Lỗi)
```
┌──────────────────────┐
│       ❌ Lỗi        │
│  Kết nối thất bại    │
│   [Thử lại]  ← Button│
└──────────────────────┘
```

---

## 🌐 API Được Sử Dụng

**TheMealDB** (Free, No API Key Required)
- URL: `https://www.themealdb.com/api/json/v1/1`
- Dữ liệu: Các món ăn từ khắp thế giới

---

## 📝 Yêu Cầu Đáp Ứng ✅

| Yêu Cầu | Status |
|--------|--------|
| AppBar hiển thị: TH3 - [Tên] - [Mã] | ✅ |
| Loading state với spinner | ✅ |
| Success state với GridView + Card | ✅ |
| Error state + Retry button | ✅ |
| Code tách file riêng | ✅ |
| Try-catch exception handling | ✅ |
| Public API (TheMealDB) | ✅ |
| Menu theme (food items) | ✅ |
| Text cắt gọn (ellipsis) | ✅ |
| Responsive design | ✅ |

---

## 🎨 Giao Diện

- **Chủ đề**: Material 3 Deep Purple
- **Layout**: GridView 2 cột responsive
- **Card Design**: 
  - Hình ảnh với error handler
  - Tiêu đề (max 2 dòng)
  - Category + Area
  - Số nguyên liệu

---

## 🔧 Tùy Chỉnh Nhanh

### Đổi Màu Chủ Đề
`lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),  // Red theme
```

### Đổi Số Cột GridView
`lib/screens/menu_screen.dart`:
```dart
crossAxisCount: 3,  // 3 cột thay vì 2
```

### Đổi Danh Mục Mặc Định
`lib/screens/menu_screen.dart`:
```dart
String _selectedCategory = 'Dessert';  // Mặc định là Dessert
```

---

## ⚠️ Lưu Ý Quan Trọng

1. **Thay Tên SV**: BẮTBUỘC trong `lib/main.dart`
2. **Internet**: Thiết bị phải có kết nối mạng
3. **First Load**: Mất 2-3 giây để tải categories
4. **Hot Reload**: Press `R` trong terminal để reload
5. **Hot Restart**: Press `Shift+R` để restart app

---

## 🐛 Xử Lý Sự Cố

| Vấn Đề | Giải Pháp |
|--------|----------|
| App không chạy | `flutter pub get` → `flutter run` |
| Build lỗi | `flutter clean` → `flutter pub get` |
| Emulator chậm | Dùng device thực |
| Không có dữ liệu | Kiểm tra internet, click "Thử lại" |
| GridView bị lỗi | Hot restart, không phải hot reload |

---

## 📲 Test Trên Device

```bash
# Xem thiết bị khả dụng
flutter devices

# Chạy trên device cụ thể
flutter run -d <device_id>

# Ví dụ: Pixel 6
flutter run -d emulator-5554
```

---

## 📊 Dữ Liệu API

Mỗi Food Item có:
- `id`: Meal ID
- `name`: Tên món ăn
- `category`: Danh mục
- `image`: URL hình ảnh
- `area`: Quốc gia
- `ingredients`: 1-20 nguyên liệu
- `instructions`: Hướng dẫn nấu

---

## 🏆 Điểm Cộng

- ✅ Sử dụng public API (TheMealDB)
- ✅ Clean code architecture
- ✅ Complete error handling
- ✅ Responsive design
- ✅ Category selection
- ✅ Retry mechanism
- ✅ Proper UI/UX
- ✅ Production-ready

---

## 📞 Support

Nếu có lỗi, kiểm tra:
1. Imports đúng chưa?
2. Dependencies cài đầy đủ? (`flutter pub get`)
3. Internet kết nối?
4. Student name & ID đã update?
5. Check console log: `flutter run` (đầu tiên là normal)

---

**Chúc bạn nộp bài thành công! 🎉**

---

**Created**: 2026-03-03  
**Flutter SDK**: 3.10.7+  
**Dart**: 3.0+  
