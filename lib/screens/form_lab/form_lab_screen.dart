import 'package:flutter/material.dart';

// [Form] Màn hình chính Form Lab phục vụ nghiên cứu và so sánh các cơ chế biểu mẫu
class FormLabScreen extends StatelessWidget {
  const FormLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // [Form] DefaultTabController quản lý 2 tab thí nghiệm
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form Lab'),
          centerTitle: true,
          // [Form] TabBar cho phép cuộn ngang để tránh tràn chữ trên màn hình hẹp
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'TextField vs TextFormField'),
              Tab(text: 'AutovalidateMode'),
            ],
          ),
        ),
        // [Form] TabBarView dùng NeverScrollableScrollPhysics tránh xung đột vuốt ngang với cử chỉ khác
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _TabContainer(
              child: Center(child: Text('TextField vs TextFormField Lab')),
            ),
            _TabContainer(
              child: Center(child: Text('AutovalidateMode Lab')),
            ),
          ],
        ),
      ),
    );
  }
}

// [Form] Khung chứa từng tab có bề rộng tối đa 720 và cuộn dọc an toàn
class _TabContainer extends StatelessWidget {
  final Widget child;

  const _TabContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
