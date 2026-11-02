import 'package:flutter/foundation.dart';

// [Form] Model dữ liệu đăng ký sinh viên bất biến (immutable), không lưu trữ mật khẩu
@immutable
class StudentRegistration {
  final String fullName;
  final String studentId;
  final String email;
  final String phone;

  const StudentRegistration({
    required this.fullName,
    required this.studentId,
    required this.email,
    required this.phone,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentRegistration &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          studentId == other.studentId &&
          email == other.email &&
          phone == other.phone;

  @override
  int get hashCode => Object.hash(fullName, studentId, email, phone);

  @override
  String toString() {
    return 'StudentRegistration(fullName: $fullName, studentId: $studentId, email: $email, phone: $phone)';
  }
}
