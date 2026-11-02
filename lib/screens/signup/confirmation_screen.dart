import 'package:flutter/material.dart';
import 'package:student_signup/models/student_registration.dart';

// [Form] Màn hình xác nhận thông tin đăng ký thành công của sinh viên
class ConfirmationScreen extends StatelessWidget {
  final StudentRegistration registration;

  const ConfirmationScreen({
    super.key,
    required this.registration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đăng ký'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon thông báo thành công
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Đăng ký tài khoản thành công!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Thông tin chi tiết của sinh viên đã được ghi nhận:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // [Form] Thẻ hiển thị 4 trường thông tin đã đăng ký, tuyệt đối không có mật khẩu
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        context,
                        icon: Icons.person_outline,
                        label: 'Họ và tên',
                        value: registration.fullName,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        icon: Icons.badge_outlined,
                        label: 'Mã số sinh viên',
                        value: registration.studentId,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: registration.email,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        icon: Icons.phone_outlined,
                        label: 'Số điện thoại',
                        value: registration.phone,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // [Form] Nút quay lại để đăng ký tài khoản khác, trả về true để xóa form
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text(
                  'Đăng ký tài khoản khác',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Nút quay lại chỉnh sửa (hoặc dùng nút back trên AppBar)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: const Icon(Icons.edit_note),
                label: const Text('Quay lại chỉnh sửa thông tin'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
