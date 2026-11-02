// [Form] Lớp chứa các hàm kiểm tra tính hợp lệ dữ liệu biểu mẫu đăng ký
class SignupValidators {
  // Không cho phép khởi tạo đối tượng vì toàn bộ là static methods
  const SignupValidators._();

  // Khai báo độ dài mã số sinh viên bằng hằng số
  static const int studentIdLength = 9;

  // Khai báo độ dài số điện thoại bằng hằng số
  static const int phoneLength = 10;

  // Khai báo độ dài mật khẩu tối thiểu
  static const int minPasswordLength = 8;

  // Regex kiểm tra họ tên chỉ gồm chữ cái Unicode (có dấu tiếng Việt) và khoảng trắng
  static final RegExp _nameRegex = RegExp(r'^[\p{L}\s]+$', unicode: true);

  // Regex kiểm tra định dạng email tiêu chuẩn
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Regex kiểm tra số điện thoại: 10 chữ số, bắt đầu bằng số 0
  static final RegExp _phoneRegex = RegExp(r'^0\d{9}$');

  // Regex kiểm tra chữ số
  static final RegExp _digitRegex = RegExp(r'\d');

  // Regex kiểm tra chữ cái
  static final RegExp _letterRegex = RegExp(r'[a-zA-Z\p{L}]', unicode: true);

  /// Kiểm tra họ và tên:
  /// - Bắt buộc
  /// - Trim trước khi kiểm tra
  /// - Chỉ gồm chữ cái Unicode và khoảng trắng
  /// - Tối thiểu 2 từ
  static String? validateFullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập họ và tên của bạn.';
    }

    if (!_nameRegex.hasMatch(trimmed)) {
      return 'Họ và tên chỉ được chứa chữ cái và khoảng trắng. Vui lòng xóa ký tự đặc biệt hoặc chữ số.';
    }

    final words = trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.length < 2) {
      return 'Họ và tên phải có ít nhất 2 từ. Vui lòng nhập đầy đủ cả họ và tên.';
    }

    return null;
  }

  /// Kiểm tra mã số sinh viên:
  /// - Bắt buộc
  /// - Trim trước khi kiểm tra
  /// - Đúng 9 chữ số
  static String? validateStudentId(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập mã số sinh viên.';
    }

    final isAllDigits = RegExp(r'^\d+$').hasMatch(trimmed);
    if (trimmed.length != studentIdLength || !isAllDigits) {
      return 'Mã số sinh viên phải gồm đúng $studentIdLength chữ số. Vui lòng kiểm tra lại.';
    }

    return null;
  }

  /// Kiểm tra địa chỉ email:
  /// - Bắt buộc
  /// - Trim trước khi kiểm tra
  /// - Đúng định dạng email bằng regex
  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập địa chỉ email.';
    }

    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Email không đúng định dạng. Vui lòng nhập email hợp lệ (ví dụ: sinhvien@truong.edu.vn).';
    }

    return null;
  }

  /// Kiểm tra số điện thoại:
  /// - Bắt buộc
  /// - Trim trước khi kiểm tra
  /// - Đúng 10 chữ số, bắt đầu bằng 0
  static String? validatePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Vui lòng nhập số điện thoại.';
    }

    if (!_phoneRegex.hasMatch(trimmed)) {
      return 'Số điện thoại phải gồm đúng $phoneLength chữ số và bắt đầu bằng số 0. Vui lòng kiểm tra lại.';
    }

    return null;
  }

  /// Kiểm tra mật khẩu:
  /// - Bắt buộc
  /// - Không trim
  /// - Tối thiểu 8 ký tự
  /// - Có ít nhất 1 chữ cái và 1 chữ số
  static String? validatePassword(String? value) {
    final val = value ?? '';
    if (val.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }

    if (val.length < minPasswordLength) {
      return 'Mật khẩu phải có tối thiểu $minPasswordLength ký tự. Vui lòng nhập thêm ký tự.';
    }

    final hasLetter = _letterRegex.hasMatch(val);
    final hasDigit = _digitRegex.hasMatch(val);

    if (!hasLetter || !hasDigit) {
      return 'Mật khẩu phải chứa ít nhất 1 chữ cái và 1 chữ số. Vui lòng bổ sung.';
    }

    return null;
  }

  /// Kiểm tra xác nhận mật khẩu:
  /// - Bắt buộc
  /// - Phải khớp mật khẩu
  static String? validateConfirmPassword(String? value, String? password) {
    final val = value ?? '';
    if (val.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu để xác nhận.';
    }

    if (val != (password ?? '')) {
      return 'Mật khẩu xác nhận không khớp. Vui lòng nhập lại chính xác mật khẩu đã tạo.';
    }

    return null;
  }
}
