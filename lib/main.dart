import 'package:flutter/material.dart';
import 'package:student_signup/screens/main_screen.dart';

void main() {
  runApp(const StudentSignupApp());
}

// [Form] Widget gốc của ứng dụng cấu hình Material 3 và chủ đề Indigo
class StudentSignupApp extends StatelessWidget {
  const StudentSignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đăng ký sinh viên',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
