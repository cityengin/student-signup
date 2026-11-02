// [Form] Lớp dữ liệu mẫu bất biến đại diện cho các trường hợp thử nghiệm biểu mẫu
class SignupDemoPreset {
  final String id;
  final String label;
  final String fullName;
  final String studentId;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  const SignupDemoPreset({
    required this.id,
    required this.label,
    required this.fullName,
    required this.studentId,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}

// Bộ dữ liệu gốc hợp lệ
const String _baseFullName = 'Nguyễn Văn An';
const String _baseStudentId = '102210123';
const String _baseEmail = 'an.nguyen@example.com';
const String _basePhone = '0905123456';
const String _basePassword = 'MatKhau123';
const String _baseConfirmPassword = 'MatKhau123';

// [Form] Danh sách các preset phục vụ kiểm thử nhanh và demo
const List<SignupDemoPreset> signupDemoPresets = [
  SignupDemoPreset(
    id: 'valid',
    label: 'Dữ liệu đúng',
    fullName: _baseFullName,
    studentId: _baseStudentId,
    email: _baseEmail,
    phone: _basePhone,
    password: _basePassword,
    confirmPassword: _baseConfirmPassword,
  ),
  SignupDemoPreset(
    id: 'all_invalid',
    label: 'Sai tất cả',
    fullName: 'An 123',
    studentId: 'ABC123',
    email: 'an.nguyen@example',
    phone: '1905123456',
    password: 'abc12',
    confirmPassword: 'xyz',
  ),
  SignupDemoPreset(
    id: 'invalid_name',
    label: 'Sai họ tên',
    fullName: 'An 123',
    studentId: _baseStudentId,
    email: _baseEmail,
    phone: _basePhone,
    password: _basePassword,
    confirmPassword: _baseConfirmPassword,
  ),
  SignupDemoPreset(
    id: 'invalid_student_id',
    label: 'Sai MSSV',
    fullName: _baseFullName,
    studentId: 'ABC123',
    email: _baseEmail,
    phone: _basePhone,
    password: _basePassword,
    confirmPassword: _baseConfirmPassword,
  ),
  SignupDemoPreset(
    id: 'invalid_email',
    label: 'Sai email',
    fullName: _baseFullName,
    studentId: _baseStudentId,
    email: 'an.nguyen@example',
    phone: _basePhone,
    password: _basePassword,
    confirmPassword: _baseConfirmPassword,
  ),
  SignupDemoPreset(
    id: 'invalid_phone',
    label: 'Sai số điện thoại',
    fullName: _baseFullName,
    studentId: _baseStudentId,
    email: _baseEmail,
    phone: '1905123456',
    password: _basePassword,
    confirmPassword: _baseConfirmPassword,
  ),
  SignupDemoPreset(
    id: 'weak_password',
    label: 'Mật khẩu yếu',
    fullName: _baseFullName,
    studentId: _baseStudentId,
    email: _baseEmail,
    phone: _basePhone,
    password: 'abc12',
    confirmPassword: 'abc12',
  ),
  SignupDemoPreset(
    id: 'password_mismatch',
    label: 'Mật khẩu không khớp',
    fullName: _baseFullName,
    studentId: _baseStudentId,
    email: _baseEmail,
    phone: _basePhone,
    password: _basePassword,
    confirmPassword: 'MatKhau456',
  ),
];
