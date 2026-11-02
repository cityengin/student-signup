import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_signup/main.dart';

void main() {
  // Helper mở bảng điều khiển demo
  Future<void> openDemoPanel(WidgetTester tester) async {
    final title = find.text('Bảng điều khiển demo');
    await tester.ensureVisible(title);
    await tester.tap(title);
    await tester.pumpAndSettle();
  }

  // Helper chọn một preset theo id
  Future<void> selectPreset(WidgetTester tester, String presetId) async {
    final chip = find.byKey(ValueKey('preset_$presetId'));
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    await tester.pumpAndSettle();
  }

  // Helper bấm nút Đăng ký tài khoản
  Future<void> submitForm(WidgetTester tester) async {
    final submitButton = find.widgetWithText(FilledButton, 'Đăng ký tài khoản');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
  }

  // Helper kiểm tra xem ô nhập có đang giữ focus không
  bool isFieldFocused(WidgetTester tester, String fieldLabel) {
    final editable = tester.widget<EditableText>(
      find.descendant(
        of: find.widgetWithText(TextFormField, fieldLabel),
        matching: find.byType(EditableText),
      ),
    );
    return editable.focusNode.hasFocus;
  }

  testWidgets('1. Preset "Dữ liệu đúng" rồi submit thì sang màn xác nhận',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    await openDemoPanel(tester);
    await selectPreset(tester, 'valid');

    await submitForm(tester);

    // Sang màn hình xác nhận thành công
    expect(find.text('Đăng ký tài khoản thành công!'), findsOneWidget);
    expect(find.text('Nguyễn Văn An'), findsOneWidget);
    expect(find.text('102210123'), findsOneWidget);
    expect(find.text('an.nguyen@example.com'), findsOneWidget);
    expect(find.text('0905123456'), findsOneWidget);
    expect(find.text('MatKhau123'), findsNothing);
  });

  group('2. Từng preset sai rồi submit không sang màn xác nhận, hiện đúng lỗi và focus ô đầu', () {
    testWidgets('Preset all_invalid: focus ô Họ và tên', (WidgetTester tester) async {
      await tester.pumpWidget(const StudentSignupApp());
      await openDemoPanel(tester);
      await selectPreset(tester, 'all_invalid');
      await submitForm(tester);

      expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
      expect(
        find.text(
          'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.',
        ),
        findsOneWidget,
      );
      expect(isFieldFocused(tester, 'Họ và tên *'), isTrue);
    });

    testWidgets('Preset invalid_name: focus ô Họ và tên', (WidgetTester tester) async {
      await tester.pumpWidget(const StudentSignupApp());
      await openDemoPanel(tester);
      await selectPreset(tester, 'invalid_name');
      await submitForm(tester);

      expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
      expect(
        find.text(
          'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.',
        ),
        findsOneWidget,
      );
      expect(isFieldFocused(tester, 'Họ và tên *'), isTrue);
    });

    testWidgets('Preset invalid_student_id: focus ô Mã số sinh viên', (WidgetTester tester) async {
      await tester.pumpWidget(const StudentSignupApp());
      await openDemoPanel(tester);
      await selectPreset(tester, 'invalid_student_id');
      await submitForm(tester);

      expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
      expect(
        find.text(
          'Mã số sinh viên phải gồm đúng 9 chữ số. Vui lòng kiểm tra lại.',
        ),
        findsOneWidget,
      );
      expect(isFieldFocused(tester, 'Mã số sinh viên *'), isTrue);
    });

    testWidgets('Preset invalid_email: focus ô Email', (WidgetTester tester) async {
      await tester.pumpWidget(const StudentSignupApp());
      await openDemoPanel(tester);
      await selectPreset(tester, 'invalid_email');
      await submitForm(tester);

      expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
      expect(
        find.text(
          'Email không đúng định dạng. Vui lòng nhập email hợp lệ (ví dụ: sinhvien@truong.edu.vn).',
        ),
        findsOneWidget,
      );
      expect(isFieldFocused(tester, 'Email *'), isTrue);
    });

    testWidgets('Preset invalid_phone: focus ô Số điện thoại', (WidgetTester tester) async {
      await tester.pumpWidget(const StudentSignupApp());
      await openDemoPanel(tester);
      await selectPreset(tester, 'invalid_phone');
      await submitForm(tester);

      expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
      expect(
        find.text(
          'Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0. Vui lòng kiểm tra lại.',
        ),
        findsOneWidget,
      );
      expect(isFieldFocused(tester, 'Số điện thoại *'), isTrue);
    });

    testWidgets('Preset weak_password: focus ô Mật khẩu', (WidgetTester tester) async {
      await tester.pumpWidget(const StudentSignupApp());
      await openDemoPanel(tester);
      await selectPreset(tester, 'weak_password');
      await submitForm(tester);

      expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
      expect(
        find.text(
          'Mật khẩu phải có tối thiểu 8 ký tự. Vui lòng nhập thêm ký tự.',
        ),
        findsOneWidget,
      );
      expect(isFieldFocused(tester, 'Mật khẩu *'), isTrue);
    });

    testWidgets('Preset password_mismatch: focus ô Xác nhận mật khẩu', (WidgetTester tester) async {
      await tester.pumpWidget(const StudentSignupApp());
      await openDemoPanel(tester);
      await selectPreset(tester, 'password_mismatch');
      await submitForm(tester);

      expect(find.text('Đăng ký tài khoản thành công!'), findsNothing);
      expect(
        find.text(
          'Mật khẩu xác nhận không khớp. Vui lòng nhập lại chính xác mật khẩu đã tạo.',
        ),
        findsOneWidget,
      );
      expect(isFieldFocused(tester, 'Xác nhận mật khẩu *'), isTrue);
    });
  });

  testWidgets(
      '3. Đổi preset sau khi đã có lỗi thì không còn lỗi cũ và mode về disabled',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    await openDemoPanel(tester);
    await selectPreset(tester, 'invalid_name');
    await submitForm(tester);

    // Xác nhận đã có lỗi và mode là onUserInteraction
    expect(
      find.text(
        'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.',
      ),
      findsOneWidget,
    );
    expect(find.text('Chế độ kiểm tra: onUserInteraction'), findsOneWidget);

    // Chờ SnackBar ẩn để không cản trở thao tác
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Chọn preset khác (valid)
    await selectPreset(tester, 'valid');

    // Lỗi cũ biến mất và chế độ autovalidate quay về disabled
    expect(
      find.text(
        'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.',
      ),
      findsNothing,
    );
    expect(find.text('Chế độ kiểm tra: disabled'), findsOneWidget);
  });

  testWidgets('4. "Xóa form" làm 6 ô trống và không còn lỗi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    await openDemoPanel(tester);
    await selectPreset(tester, 'all_invalid');
    await submitForm(tester);

    // Chờ SnackBar ẩn
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Nhấn nút Xóa form
    final clearChip = find.byKey(const ValueKey('preset_clear'));
    await tester.ensureVisible(clearChip);
    await tester.tap(clearChip);
    await tester.pumpAndSettle();

    // Kiểm tra toàn bộ 6 ô input đều rỗng
    final editableWidgets =
        tester.widgetList<EditableText>(find.byType(EditableText));
    for (final editable in editableWidgets) {
      expect(editable.controller.text, isEmpty);
    }

    // Không còn thông báo lỗi và mode quay về disabled
    expect(find.text('Vui lòng kiểm tra các ô báo đỏ'), findsNothing);
    expect(find.text('Chế độ kiểm tra: disabled'), findsOneWidget);
  });

  testWidgets(
      '5. Subtitle đổi từ disabled sang onUserInteraction sau lần submit thất bại',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudentSignupApp());

    // Ban đầu là disabled
    expect(find.text('Chế độ kiểm tra: disabled'), findsOneWidget);

    // Submit form rỗng
    await submitForm(tester);

    // Subtitle chuyển sang onUserInteraction
    expect(find.text('Chế độ kiểm tra: onUserInteraction'), findsOneWidget);
  });

  testWidgets('6. Bảng điều khiển mở ra ở chiều rộng 320 px không overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const StudentSignupApp());
    await tester.pumpAndSettle();

    await openDemoPanel(tester);

    // Cuộn dọc kiểm tra khả năng hiển thị
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
