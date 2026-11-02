import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_signup/screens/form_lab/form_lab_screen.dart';

void main() {
  Widget buildTestableScreen() {
    return const MaterialApp(
      home: FormLabScreen(),
    );
  }

  testWidgets('1. Đủ 2 tab và chuyển đổi qua lại giữa các tab thành công',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    // Kiểm tra tiêu đề AppBar
    expect(find.text('Form Lab'), findsOneWidget);

    // Kiểm tra 2 tab xuất hiện
    final tab1 = find.text('TextField vs TextFormField');
    final tab2 = find.text('AutovalidateMode');
    expect(tab1, findsOneWidget);
    expect(tab2, findsOneWidget);

    // Mặc định ở Tab 1
    expect(find.text('TextField: tự quản lý'), findsOneWidget);
    expect(find.text('TextFormField: Form quản lý'), findsOneWidget);

    // Chuyển sang Tab 2
    await tester.ensureVisible(tab2);
    await tester.tap(tab2);
    await tester.pumpAndSettle();
    expect(find.text('Chọn chế độ AutovalidateMode'), findsOneWidget);
    expect(find.text('Kinh nghiệm thực tế trong thiết kế Form'), findsOneWidget);

    // Chuyển lại Tab 1
    await tester.ensureVisible(tab1);
    await tester.tap(tab1);
    await tester.pumpAndSettle();
    expect(find.text('TextField: tự quản lý'), findsOneWidget);
  });

  testWidgets(
      '2. Tab 1 - TextField tự quản lý: dữ liệu sai báo lỗi và Còn lỗi, dữ liệu đúng báo Hợp lệ, Xóa làm sạch ô',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    final emailInput = find.byKey(const ValueKey('tf_email'));
    final phoneInput = find.byKey(const ValueKey('tf_phone'));
    final checkBtn = find.byKey(const ValueKey('tf_check_button'));
    final clearBtn = find.byKey(const ValueKey('tf_clear_button'));

    // Nhập dữ liệu sai
    await tester.ensureVisible(emailInput);
    await tester.enterText(emailInput, 'sai_dinh_dang');
    await tester.ensureVisible(phoneInput);
    await tester.enterText(phoneInput, '12345');
    await tester.ensureVisible(checkBtn);
    await tester.tap(checkBtn);
    await tester.pumpAndSettle();

    // Xuất hiện lỗi ở cả 2 ô và trạng thái "Còn lỗi"
    expect(find.textContaining('Email không đúng định dạng'), findsOneWidget);
    expect(find.textContaining('Số điện thoại phải gồm đúng 10 chữ số'),
        findsOneWidget);
    expect(find.byKey(const ValueKey('tf_status_text')), findsOneWidget);
    expect(find.text('Còn lỗi'), findsOneWidget);

    // Nhập dữ liệu đúng
    await tester.ensureVisible(emailInput);
    await tester.enterText(emailInput, 'student@dut.udn.vn');
    await tester.ensureVisible(phoneInput);
    await tester.enterText(phoneInput, '0905123456');
    await tester.ensureVisible(checkBtn);
    await tester.tap(checkBtn);
    await tester.pumpAndSettle();

    // Không còn lỗi và trạng thái chuyển thành "Hợp lệ"
    expect(find.textContaining('Email không đúng định dạng'), findsNothing);
    expect(find.textContaining('Số điện thoại phải gồm đúng 10 chữ số'),
        findsNothing);
    expect(find.text('Hợp lệ'), findsOneWidget);

    // Nhấn nút Xóa
    await tester.ensureVisible(clearBtn);
    await tester.tap(clearBtn);
    await tester.pumpAndSettle();

    // Cả 2 ô trống và không còn thông báo trạng thái
    final emailWidget = tester.widget<TextField>(emailInput);
    final phoneWidget = tester.widget<TextField>(phoneInput);
    expect(emailWidget.controller?.text, isEmpty);
    expect(phoneWidget.controller?.text, isEmpty);
    expect(find.text('Hợp lệ'), findsNothing);
    expect(find.text('Còn lỗi'), findsNothing);
  });

  testWidgets(
      '3. Tab 1 - TextFormField Form quản lý: dữ liệu sai báo lỗi và Còn lỗi, dữ liệu đúng báo Hợp lệ, Xóa làm sạch ô',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    final emailInput = find.byKey(const ValueKey('tff_email'));
    final phoneInput = find.byKey(const ValueKey('tff_phone'));
    final checkBtn = find.byKey(const ValueKey('tff_check_button'));
    final clearBtn = find.byKey(const ValueKey('tff_clear_button'));

    // Nhập dữ liệu sai
    await tester.ensureVisible(emailInput);
    await tester.enterText(emailInput, 'sai_email');
    await tester.ensureVisible(phoneInput);
    await tester.enterText(phoneInput, '0999');
    await tester.ensureVisible(checkBtn);
    await tester.tap(checkBtn);
    await tester.pumpAndSettle();

    // Xuất hiện lỗi và trạng thái "Còn lỗi"
    expect(find.textContaining('Email không đúng định dạng'), findsOneWidget);
    expect(find.textContaining('Số điện thoại phải gồm đúng 10 chữ số'),
        findsOneWidget);
    expect(find.byKey(const ValueKey('tff_status_text')), findsOneWidget);
    expect(find.text('Còn lỗi'), findsOneWidget);

    // Nhập dữ liệu đúng
    await tester.ensureVisible(emailInput);
    await tester.enterText(emailInput, 'sv@dut.udn.vn');
    await tester.ensureVisible(phoneInput);
    await tester.enterText(phoneInput, '0912345678');
    await tester.ensureVisible(checkBtn);
    await tester.tap(checkBtn);
    await tester.pumpAndSettle();

    // Hợp lệ
    expect(find.textContaining('Email không đúng định dạng'), findsNothing);
    expect(find.textContaining('Số điện thoại phải gồm đúng 10 chữ số'),
        findsNothing);
    expect(find.text('Hợp lệ'), findsOneWidget);

    // Nhấn nút Xóa
    await tester.ensureVisible(clearBtn);
    await tester.tap(clearBtn);
    await tester.pumpAndSettle();

    // Ô trống và mất lỗi
    expect(find.descendant(of: emailInput, matching: find.text('sv@dut.udn.vn')),
        findsNothing);
    expect(find.text('Hợp lệ'), findsNothing);
    expect(find.text('Còn lỗi'), findsNothing);
  });

  testWidgets(
      '4. Tab 2 - disabled chưa báo lỗi khi đang gõ, chỉ báo khi bấm Kiểm tra',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    // Chuyển sang Tab 2
    final tab2 = find.text('AutovalidateMode');
    await tester.ensureVisible(tab2);
    await tester.tap(tab2);
    await tester.pumpAndSettle();

    final autoEmail = find.byKey(const ValueKey('auto_email'));
    final checkBtn = find.byKey(const ValueKey('auto_check_button'));

    // Gõ email sai khi đang ở chế độ disabled
    await tester.ensureVisible(autoEmail);
    await tester.enterText(autoEmail, 'invalid_mail');
    await tester.pumpAndSettle();

    // Chưa bấm Kiểm tra -> không báo lỗi
    expect(find.textContaining('Email không đúng định dạng'), findsNothing);

    // Bấm Kiểm tra -> mới báo lỗi
    await tester.ensureVisible(checkBtn);
    await tester.tap(checkBtn);
    await tester.pumpAndSettle();
    expect(find.textContaining('Email không đúng định dạng'), findsOneWidget);
  });

  testWidgets('5. Tab 2 - always báo lỗi ngay lập tức mà không cần tương tác',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    // Chuyển sang Tab 2
    final tab2 = find.text('AutovalidateMode');
    await tester.ensureVisible(tab2);
    await tester.tap(tab2);
    await tester.pumpAndSettle();

    // Chọn always
    final chipAlways = find.byKey(const ValueKey('chip_always'));
    await tester.ensureVisible(chipAlways);
    await tester.tap(chipAlways);
    await tester.pumpAndSettle();

    // Cả 2 ô trống nhưng lỗi lập tức xuất hiện ngay do chế độ always
    expect(find.text('Vui lòng nhập địa chỉ email.'), findsOneWidget);
    expect(find.text('Vui lòng nhập số điện thoại.'), findsOneWidget);
  });

  testWidgets('6. Tab 2 - onUserInteraction báo lỗi ngay sau khi người dùng gõ',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    // Chuyển sang Tab 2
    final tab2 = find.text('AutovalidateMode');
    await tester.ensureVisible(tab2);
    await tester.tap(tab2);
    await tester.pumpAndSettle();

    // Chọn onUserInteraction
    final chipOnUser = find.byKey(const ValueKey('chip_onUserInteraction'));
    await tester.ensureVisible(chipOnUser);
    await tester.tap(chipOnUser);
    await tester.pumpAndSettle();

    final autoEmail = find.byKey(const ValueKey('auto_email'));

    // Chưa gõ -> chưa báo lỗi
    expect(find.textContaining('Email không đúng định dạng'), findsNothing);

    // Gõ ký tự không hợp lệ -> tự động báo lỗi ngay sau khi gõ mà không cần bấm Kiểm tra
    await tester.ensureVisible(autoEmail);
    await tester.enterText(autoEmail, 'invalid');
    await tester.pumpAndSettle();

    expect(find.textContaining('Email không đúng định dạng'), findsOneWidget);
  });

  testWidgets(
      '7. Tab 2 - Đổi chế độ thì form sạch lại (xóa dữ liệu và xóa lỗi cũ)',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    // Chuyển sang Tab 2
    final tab2 = find.text('AutovalidateMode');
    await tester.ensureVisible(tab2);
    await tester.tap(tab2);
    await tester.pumpAndSettle();

    // Chọn onUserInteraction và gõ sai để kích hoạt lỗi
    final chipOnUser = find.byKey(const ValueKey('chip_onUserInteraction'));
    await tester.ensureVisible(chipOnUser);
    await tester.tap(chipOnUser);
    await tester.pumpAndSettle();

    final autoEmail = find.byKey(const ValueKey('auto_email'));
    await tester.ensureVisible(autoEmail);
    await tester.enterText(autoEmail, 'not_an_email');
    await tester.pumpAndSettle();
    expect(find.textContaining('Email không đúng định dạng'), findsOneWidget);

    // Đổi sang chế độ disabled
    final chipDisabled = find.byKey(const ValueKey('chip_disabled'));
    await tester.ensureVisible(chipDisabled);
    await tester.tap(chipDisabled);
    await tester.pumpAndSettle();

    // Form đã được làm sạch: không còn chữ đã gõ và không còn lỗi
    expect(find.textContaining('Email không đúng định dạng'), findsNothing);
    expect(find.descendant(of: autoEmail, matching: find.text('not_an_email')),
        findsNothing);
  });

  testWidgets('8. Kiểm tra giao diện trên màn hình hẹp 320 px không bị overflow',
      (WidgetTester tester) async {
    // Thiết lập kích thước màn hình hẹp 320 px
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableScreen());
    await tester.pumpAndSettle();

    // Cuộn Tab 1
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Chuyển sang Tab 2 bằng ensureVisible và cuộn
    final tab2 = find.text('AutovalidateMode');
    await tester.ensureVisible(tab2);
    await tester.tap(tab2);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(SingleChildScrollView).last, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Không xảy ra bất kỳ ngoại lệ overflow nào
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      '9. Tab 2 - onUserInteractionIfError: gõ sai khi chưa có lỗi thì chưa báo, bấm Kiểm tra thì báo, sửa đúng cả hai ô thì tự hết lỗi',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableScreen());

    // Chuyển sang Tab 2
    final tab2 = find.text('AutovalidateMode');
    await tester.ensureVisible(tab2);
    await tester.tap(tab2);
    await tester.pumpAndSettle();

    // Chọn onUserInteractionIfError
    final chipOnError =
        find.byKey(const ValueKey('chip_onUserInteractionIfError'));
    await tester.ensureVisible(chipOnError);
    await tester.tap(chipOnError);
    await tester.pumpAndSettle();

    final autoEmail = find.byKey(const ValueKey('auto_email'));
    final autoPhone = find.byKey(const ValueKey('auto_phone'));
    final checkBtn = find.byKey(const ValueKey('auto_check_button'));

    // Gõ sai khi chưa có lỗi -> chưa báo lỗi
    await tester.ensureVisible(autoEmail);
    await tester.enterText(autoEmail, 'invalid_mail');
    await tester.pumpAndSettle();
    expect(find.textContaining('Email không đúng định dạng'), findsNothing);

    // Bấm Kiểm tra -> mới báo lỗi
    await tester.ensureVisible(checkBtn);
    await tester.tap(checkBtn);
    await tester.pumpAndSettle();
    expect(find.textContaining('Email không đúng định dạng'), findsOneWidget);
    expect(find.text('Vui lòng nhập số điện thoại.'), findsOneWidget);

    // Sửa đúng cả hai ô -> tự hết lỗi mà không cần bấm lại nút Kiểm tra
    await tester.ensureVisible(autoEmail);
    await tester.enterText(autoEmail, 'sinhvien@dut.udn.vn');
    await tester.pumpAndSettle();
    expect(find.textContaining('Email không đúng định dạng'), findsNothing);

    await tester.ensureVisible(autoPhone);
    await tester.enterText(autoPhone, '0905123456');
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập số điện thoại.'), findsNothing);
  });
}

