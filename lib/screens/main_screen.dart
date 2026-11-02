import 'package:flutter/material.dart';
import 'package:student_signup/screens/form_lab/form_lab_screen.dart';
import 'package:student_signup/screens/signup/signup_screen.dart';

// [Form] Màn hình chính điều hướng 2 tab bằng NavigationBar và IndexedStack
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SignupScreen(),
    FormLabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [Form] IndexedStack duy trì trạng thái của các tab khi chuyển đổi
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // [Form] Thanh điều hướng phía dưới chuẩn Material 3
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_add_outlined),
            selectedIcon: Icon(Icons.person_add),
            label: 'Đăng ký',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'Form Lab',
          ),
        ],
      ),
    );
  }
}
