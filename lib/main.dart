import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuScreen(
        studentName: 'Trần Quang Quân', // Thay bằng tên sinh viên
        studentId: '2351060480', // Thay bằng mã sinh viên
      ),
    );
  }
}
