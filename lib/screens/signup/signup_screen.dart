import 'package:flutter/material.dart';

// [Form] Màn hình đăng ký thông tin sinh viên
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký sinh viên'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Biểu mẫu đăng ký'),
      ),
    );
  }
}
