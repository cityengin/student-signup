import 'package:flutter_test/flutter_test.dart';
import 'package:student_signup/main.dart';

void main() {
  testWidgets('Khởi động ứng dụng hiển thị 2 tab điều hướng', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    expect(find.text('Đăng ký'), findsWidgets);
    expect(find.text('Form Lab'), findsOneWidget);
  });
}
