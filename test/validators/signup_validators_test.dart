import 'package:flutter_test/flutter_test.dart';
import 'package:student_signup/validators/signup_validators.dart';

void main() {
  group('SignupValidators - validateFullName', () {
    test('Họ tên hợp lệ với tiếng Việt có dấu và nhiều từ', () {
      expect(SignupValidators.validateFullName('Nguyễn Văn An'), isNull);
      expect(SignupValidators.validateFullName('Trần Thị Ánh Tuyết'), isNull);
      expect(SignupValidators.validateFullName('Lê Đình Vũ'), isNull);
      expect(SignupValidators.validateFullName('Đỗ Bảo'), isNull);
      expect(SignupValidators.validateFullName('John Doe'), isNull);
    });

    test('Họ tên có khoảng trắng ở đầu hoặc cuối được trim và hợp lệ', () {
      expect(SignupValidators.validateFullName('   Phạm Nhật Vượng   '), isNull);
    });

    test('Họ tên rỗng hoặc null báo lỗi nêu rõ cách sửa', () {
      expect(
        SignupValidators.validateFullName(null),
        'Vui lòng nhập họ và tên của bạn.',
      );
      expect(
        SignupValidators.validateFullName(''),
        'Vui lòng nhập họ và tên của bạn.',
      );
      expect(
        SignupValidators.validateFullName('   '),
        'Vui lòng nhập họ và tên của bạn.',
      );
    });

    test('Họ tên chỉ có 1 từ báo lỗi yêu cầu nhập tối thiểu 2 từ', () {
      expect(
        SignupValidators.validateFullName('Nguyễn'),
        'Họ và tên phải có ít nhất 2 từ. Vui lòng nhập đầy đủ cả họ và tên.',
      );
      expect(
        SignupValidators.validateFullName('An   '),
        'Họ và tên phải có ít nhất 2 từ. Vui lòng nhập đầy đủ cả họ và tên.',
      );
    });

    test('Họ tên chứa chữ số hoặc ký tự đặc biệt báo lỗi', () {
      expect(
        SignupValidators.validateFullName('Nguyễn Văn 123'),
        'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.',
      );
      expect(
        SignupValidators.validateFullName('Trần @ An'),
        'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.',
      );
      expect(
        SignupValidators.validateFullName('Lê_Văn_Bình'),
        'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.',
      );
    });
  });

  group('SignupValidators - validateStudentId', () {
    test('Hằng số studentIdLength bằng 9', () {
      expect(SignupValidators.studentIdLength, 9);
    });

    test('Mã số sinh viên đúng 9 chữ số', () {
      expect(SignupValidators.validateStudentId('102210123'), isNull);
      expect(SignupValidators.validateStudentId('123456789'), isNull);
    });

    test('Mã số sinh viên có khoảng trắng được trim và hợp lệ', () {
      expect(SignupValidators.validateStudentId('  102210123  '), isNull);
    });

    test('Mã số sinh viên null hoặc rỗng báo lỗi', () {
      expect(
        SignupValidators.validateStudentId(null),
        'Vui lòng nhập mã số sinh viên.',
      );
      expect(
        SignupValidators.validateStudentId(''),
        'Vui lòng nhập mã số sinh viên.',
      );
      expect(
        SignupValidators.validateStudentId('   '),
        'Vui lòng nhập mã số sinh viên.',
      );
    });

    test('Mã số sinh viên không đủ hoặc vượt quá 9 chữ số', () {
      expect(
        SignupValidators.validateStudentId('12345678'),
        'Mã số sinh viên phải gồm đúng 9 chữ số. Vui lòng kiểm tra lại.',
      );
      expect(
        SignupValidators.validateStudentId('1234567890'),
        'Mã số sinh viên phải gồm đúng 9 chữ số. Vui lòng kiểm tra lại.',
      );
    });

    test('Mã số sinh viên chứa chữ cái hoặc ký tự đặc biệt', () {
      expect(
        SignupValidators.validateStudentId('10221ABCD'),
        'Mã số sinh viên phải gồm đúng 9 chữ số. Vui lòng kiểm tra lại.',
      );
      expect(
        SignupValidators.validateStudentId('10221-123'),
        'Mã số sinh viên phải gồm đúng 9 chữ số. Vui lòng kiểm tra lại.',
      );
    });
  });

  group('SignupValidators - validateEmail', () {
    test('Email hợp lệ', () {
      expect(SignupValidators.validateEmail('student@school.edu.vn'), isNull);
      expect(SignupValidators.validateEmail('example@gmail.com'), isNull);
      expect(SignupValidators.validateEmail('user.name+tag@domain.co'), isNull);
    });

    test('Email có khoảng trắng thừa được trim và hợp lệ', () {
      expect(SignupValidators.validateEmail('  student@dut.udn.vn  '), isNull);
    });

    test('Email null hoặc rỗng báo lỗi', () {
      expect(
        SignupValidators.validateEmail(null),
        'Vui lòng nhập địa chỉ email.',
      );
      expect(
        SignupValidators.validateEmail(''),
        'Vui lòng nhập địa chỉ email.',
      );
      expect(
        SignupValidators.validateEmail('   '),
        'Vui lòng nhập địa chỉ email.',
      );
    });

    test('Email sai định dạng báo lỗi nêu rõ cách sửa', () {
      expect(
        SignupValidators.validateEmail('studentschool.edu.vn'),
        'Email không đúng định dạng. Vui lòng nhập email hợp lệ (ví dụ: sinhvien@truong.edu.vn).',
      );
      expect(
        SignupValidators.validateEmail('student@'),
        'Email không đúng định dạng. Vui lòng nhập email hợp lệ (ví dụ: sinhvien@truong.edu.vn).',
      );
      expect(
        SignupValidators.validateEmail('student@school'),
        'Email không đúng định dạng. Vui lòng nhập email hợp lệ (ví dụ: sinhvien@truong.edu.vn).',
      );
    });
  });

  group('SignupValidators - validatePhone', () {
    test('Hằng số phoneLength bằng 10', () {
      expect(SignupValidators.phoneLength, 10);
    });

    test('Số điện thoại hợp lệ 10 số bắt đầu bằng 0', () {
      expect(SignupValidators.validatePhone('0912345678'), isNull);
      expect(SignupValidators.validatePhone('0389123456'), isNull);
    });

    test('Số điện thoại có khoảng trắng thừa được trim và hợp lệ', () {
      expect(SignupValidators.validatePhone('  0987654321  '), isNull);
    });

    test('Số điện thoại null hoặc rỗng báo lỗi', () {
      expect(
        SignupValidators.validatePhone(null),
        'Vui lòng nhập số điện thoại.',
      );
      expect(
        SignupValidators.validatePhone(''),
        'Vui lòng nhập số điện thoại.',
      );
      expect(
        SignupValidators.validatePhone('   '),
        'Vui lòng nhập số điện thoại.',
      );
    });

    test('Số điện thoại không bắt đầu bằng số 0', () {
      expect(
        SignupValidators.validatePhone('1912345678'),
        'Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0. Vui lòng kiểm tra lại.',
      );
    });

    test('Số điện thoại không đủ 10 chữ số hoặc chứa chữ cái', () {
      expect(
        SignupValidators.validatePhone('091234567'),
        'Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0. Vui lòng kiểm tra lại.',
      );
      expect(
        SignupValidators.validatePhone('09123456789'),
        'Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0. Vui lòng kiểm tra lại.',
      );
      expect(
        SignupValidators.validatePhone('091234567a'),
        'Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0. Vui lòng kiểm tra lại.',
      );
    });
  });

  group('SignupValidators - validatePassword', () {
    test('Hằng số minPasswordLength bằng 8', () {
      expect(SignupValidators.minPasswordLength, 8);
    });

    test('Mật khẩu hợp lệ tối thiểu 8 ký tự, có cả chữ và số', () {
      expect(SignupValidators.validatePassword('Password123'), isNull);
      expect(SignupValidators.validatePassword('abc12345'), isNull);
      expect(SignupValidators.validatePassword('Matkhau@1'), isNull);
    });

    test('Mật khẩu không được trim (khoảng trắng tính vào độ dài)', () {
      expect(SignupValidators.validatePassword('a1      '), isNull);
    });

    test('Mật khẩu null hoặc rỗng báo lỗi', () {
      expect(
        SignupValidators.validatePassword(null),
        'Vui lòng nhập mật khẩu.',
      );
      expect(
        SignupValidators.validatePassword(''),
        'Vui lòng nhập mật khẩu.',
      );
    });

    test('Mật khẩu dưới 8 ký tự báo lỗi', () {
      expect(
        SignupValidators.validatePassword('Pass1'),
        'Mật khẩu phải có tối thiểu 8 ký tự. Vui lòng nhập thêm ký tự.',
      );
    });

    test('Mật khẩu chỉ có chữ hoặc chỉ có số báo lỗi', () {
      expect(
        SignupValidators.validatePassword('PasswordOnly'),
        'Mật khẩu phải chứa ít nhất 1 chữ cái và 1 chữ số. Vui lòng bổ sung.',
      );
      expect(
        SignupValidators.validatePassword('123456789'),
        'Mật khẩu phải chứa ít nhất 1 chữ cái và 1 chữ số. Vui lòng bổ sung.',
      );
    });
  });

  group('SignupValidators - validateConfirmPassword', () {
    test('Mật khẩu xác nhận khớp với mật khẩu', () {
      expect(
        SignupValidators.validateConfirmPassword(
          'Password123',
          'Password123',
        ),
        isNull,
      );
    });

    test('Mật khẩu xác nhận null hoặc rỗng báo lỗi', () {
      expect(
        SignupValidators.validateConfirmPassword(null, 'Password123'),
        'Vui lòng nhập lại mật khẩu để xác nhận.',
      );
      expect(
        SignupValidators.validateConfirmPassword('', 'Password123'),
        'Vui lòng nhập lại mật khẩu để xác nhận.',
      );
    });

    test('Mật khẩu xác nhận không khớp báo lỗi', () {
      expect(
        SignupValidators.validateConfirmPassword(
          'Password456',
          'Password123',
        ),
        'Mật khẩu xác nhận không khớp. Vui lòng nhập lại chính xác mật khẩu đã tạo.',
      );
      expect(
        SignupValidators.validateConfirmPassword(
          'password123',
          'Password123',
        ),
        'Mật khẩu xác nhận không khớp. Vui lòng nhập lại chính xác mật khẩu đã tạo.',
      );
    });
  });
}
