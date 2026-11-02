import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_signup/main.dart';

void main() {
  testWidgets('1. Form trống không chuyển màn hình và hiển thị SnackBar cảnh báo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    // Nhấn nút Đăng ký khi chưa nhập gì
    final submitButton = find.widgetWithText(FilledButton, 'Đăng ký tài khoản');
    expect(submitButton, findsOneWidget);
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Không chuyển sang màn hình xác nhận
    expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
    expect(find.text('Vui lòng kiểm tra các ô báo đỏ'), findsOneWidget);

    // Xuất hiện các thông báo lỗi trường bắt buộc
    expect(find.text('Vui lòng nhập họ và tên của bạn.'), findsOneWidget);
    expect(find.text('Vui lòng nhập mã số sinh viên.'), findsOneWidget);
  });

  testWidgets('2. Ô lỗi đầu tiên được focus khi submit không hợp lệ',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    // Nhập hợp lệ họ tên nhưng để trống các ô còn lại
    final fullNameInput =
        find.widgetWithText(TextFormField, 'Họ và tên *');
    await tester.enterText(fullNameInput, 'Nguyễn Văn An');

    final submitButton = find.widgetWithText(FilledButton, 'Đăng ký tài khoản');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Ô lỗi đầu tiên lúc này phải là MSSV
    final studentIdEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextFormField, 'Mã số sinh viên *'),
        matching: find.byType(EditableText),
      ),
    );
    expect(studentIdEditable.focusNode.hasFocus, isTrue);
  });

  testWidgets('3. Mật khẩu không khớp báo lỗi và cập nhật khi sửa mật khẩu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    // Nhập thông tin đầy đủ nhưng mật khẩu không khớp
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Họ và tên *'),
      'Nguyễn Văn An',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mã số sinh viên *'),
      '102210123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email *'),
      'an.nv@student.dut.udn.vn',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Số điện thoại *'),
      '0912345678',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu *'),
      'Password123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu *'),
      'Password456',
    );

    final submitButton = find.widgetWithText(FilledButton, 'Đăng ký tài khoản');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Kiểm tra thông báo lỗi không khớp
    expect(
      find.text(
        'Mật khẩu xác nhận không khớp. Vui lòng nhập lại chính xác mật khẩu đã tạo.',
      ),
      findsOneWidget,
    );

    // Khi người dùng sửa ô mật khẩu khớp với ô nhập lại, lỗi tự động biến mất
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu *'),
      'Password456',
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Mật khẩu xác nhận không khớp. Vui lòng nhập lại chính xác mật khẩu đã tạo.',
      ),
      findsNothing,
    );
  });

  testWidgets(
      '4. Dữ liệu đúng sang màn xác nhận và không hiện mật khẩu',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    // Điền toàn bộ thông tin hợp lệ
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Họ và tên *'),
      '  Trần Thị Ánh Tuyết  ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mã số sinh viên *'),
      '102210999',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email *'),
      'tuyet.tta@student.dut.udn.vn',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Số điện thoại *'),
      '0987654321',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu *'),
      'SecurePass123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu *'),
      'SecurePass123',
    );

    final submitButton = find.widgetWithText(FilledButton, 'Đăng ký tài khoản');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Đã chuyển sang màn hình xác nhận
    expect(find.text('Đăng ký tài khoản thành công!'), findsOneWidget);

    // Hiển thị 4 thông tin đã được trim
    expect(find.text('Trần Thị Ánh Tuyết'), findsOneWidget);
    expect(find.text('102210999'), findsOneWidget);
    expect(find.text('tuyet.tta@student.dut.udn.vn'), findsOneWidget);
    expect(find.text('0987654321'), findsOneWidget);

    // Tuyệt đối không hiển thị mật khẩu
    expect(find.text('SecurePass123'), findsNothing);
  });

  testWidgets(
      '5. Nút đăng ký tài khoản khác làm các ô trống và không còn lỗi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    // Đăng ký thành công một tài khoản
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Họ và tên *'),
      'Lê Đình Vũ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mã số sinh viên *'),
      '102210888',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email *'),
      'vu.ld@student.dut.udn.vn',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Số điện thoại *'),
      '0905123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu *'),
      'MyPassword1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu *'),
      'MyPassword1',
    );

    final submitButton = find.widgetWithText(FilledButton, 'Đăng ký tài khoản');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Đăng ký tài khoản thành công!'), findsOneWidget);

    // Nhấn "Đăng ký tài khoản khác"
    final registerAnotherBtn =
        find.widgetWithText(FilledButton, 'Đăng ký tài khoản khác');
    expect(registerAnotherBtn, findsOneWidget);
    await tester.ensureVisible(registerAnotherBtn);
    await tester.tap(registerAnotherBtn);
    await tester.pumpAndSettle();

    // Quay lại màn hình đăng ký
    expect(find.text('Thông tin sinh viên'), findsOneWidget);

    // Kiểm tra toàn bộ 6 ô input đều rỗng
    final editableWidgets =
        tester.widgetList<EditableText>(find.byType(EditableText));
    for (final editable in editableWidgets) {
      expect(editable.controller.text, isEmpty);
    }

    // Không có bất kỳ thông báo lỗi nào hiển thị
    expect(find.text('Vui lòng kiểm tra các ô báo đỏ'), findsNothing);
    expect(find.text('Vui lòng nhập họ và tên của bạn.'), findsNothing);
  });

  testWidgets(
      '6. Submit lỗi rồi sửa đúng, đăng ký khác không còn lỗi ở ô xác nhận',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Họ và tên *'),
      'Lê Đình Vũ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mã số sinh viên *'),
      '102210888',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email *'),
      'vu.ld@student.dut.udn.vn',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Số điện thoại *'),
      '0905123456',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mật khẩu *'),
      'MyPassword1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu *'),
      'MyPassword2',
    );

    // Lần 1: submit thất bại để bật onUserInteraction
    final submitButton = find.widgetWithText(FilledButton, 'Đăng ký tài khoản');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Chờ SnackBar biến mất để không che nút
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Lần 2: sửa đúng rồi submit thành công
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Xác nhận mật khẩu *'),
      'MyPassword1',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
    expect(find.text('Đăng ký tài khoản thành công!'), findsOneWidget);

    final registerAnotherBtn =
        find.widgetWithText(FilledButton, 'Đăng ký tài khoản khác');
    await tester.ensureVisible(registerAnotherBtn);
    await tester.tap(registerAnotherBtn);
    await tester.pumpAndSettle();

    // Form đã reset thì ô xác nhận không được báo lỗi
    expect(find.text('Vui lòng nhập lại mật khẩu để xác nhận.'), findsNothing);
  });
}

