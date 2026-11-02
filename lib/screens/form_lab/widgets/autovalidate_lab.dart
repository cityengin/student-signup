import 'package:flutter/material.dart';
import 'package:student_signup/screens/form_lab/widgets/lab_card.dart';
import 'package:student_signup/validators/signup_validators.dart';

// [Form] Tab thử nghiệm và so sánh hành vi của các chế độ AutovalidateMode
class AutovalidateLab extends StatefulWidget {
  const AutovalidateLab({super.key});

  @override
  State<AutovalidateLab> createState() => _AutovalidateLabState();
}

class _AutovalidateLabState extends State<AutovalidateLab> {
  // [Form] Chế độ tự động kiểm tra hiện tại, mặc định là disabled
  AutovalidateMode _currentMode = AutovalidateMode.disabled;

  // [Form] Key của Form, được tái tạo mới mỗi khi đổi chế độ để tránh giữ lỗi cũ
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    // [Form] Giải phóng controller khi widget bị hủy để tránh rò rỉ bộ nhớ
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // [Form] Đổi chế độ kiểm tra: xóa chữ và cấp GlobalKey mới để làm sạch Form
  void _onModeSelected(AutovalidateMode mode) {
    if (_currentMode != mode) {
      setState(() {
        _currentMode = mode;
        _emailController.clear();
        _phoneController.clear();
        _formKey = GlobalKey<FormState>();
      });
    }
  }

  // [Form] Gọi validate() thủ công ở cấp FormState
  void _validate() {
    _formKey.currentState?.validate();
  }

  // [Form] Cung cấp thông tin chi tiết giải thích cho từng AutovalidateMode
  ({String whenAppears, String whenSuitable}) _getModeDescription(
      AutovalidateMode mode) {
    switch (mode) {
      case AutovalidateMode.disabled:
        return (
          whenAppears:
              'Chỉ hiển thị khi gọi hàm validate() (ví dụ khi nhấn nút "Kiểm tra"). Không tự động kiểm tra khi đang gõ hay khi rời ô.',
          whenSuitable:
              'Phù hợp khi mới mở form, giúp người dùng không bị làm phiền bởi thông báo lỗi khi chưa nhập xong.',
        );
      case AutovalidateMode.always:
        return (
          whenAppears:
              'Hiển thị lỗi ngay lập tức khi widget được dựng, kể cả khi người dùng chưa chạm hay nhập bất kỳ ký tự nào.',
          whenSuitable:
              'Phù hợp cho các form đã có sẵn dữ liệu cần kiểm tra lại ngay, hoặc môi trường kiểm thử; ít dùng cho form nhập mới.',
        );
      case AutovalidateMode.onUserInteraction:
        return (
          whenAppears:
              'Bắt đầu tự động kiểm tra ngay sau tương tác đầu tiên của người dùng và cập nhật liên tục theo từng ký tự gõ.',
          whenSuitable:
              'Phù hợp sau khi submit lần đầu thất bại, giúp người dùng thấy ngay kết quả sửa lỗi mà không cần bấm submit lại.',
        );
      case AutovalidateMode.onUnfocus:
        return (
          whenAppears:
              'Chỉ kiểm tra và hiện lỗi khi ô nhập mất tiêu điểm (unfocus / người dùng chuyển sang ô khác). Không báo lỗi khi đang gõ.',
          whenSuitable:
              'Phù hợp khi muốn người dùng tập trung hoàn thành trọn vẹn từng ô mà không bị phân tâm bởi lỗi trong lúc đang gõ.',
        );
      case AutovalidateMode.onUserInteractionIfError:
        return (
          whenAppears:
              'Chỉ tự động kiểm tra khi người dùng gõ nếu ô đó ĐÃ CÓ LỖI từ trước. Nếu ô chưa có lỗi thì không tự động kiểm tra khi đang gõ.',
          whenSuitable:
              'Tối ưu trải nghiệm chỉnh sửa: không làm phiền khi đang nhập mới, nhưng hỗ trợ phản hồi tức thì khi người dùng sửa lỗi.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final modeDesc = _getModeDescription(_currentMode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // [Form] Thẻ chọn chế độ AutovalidateMode và xem mô tả hành vi
        LabCard(
          title: 'Chọn chế độ AutovalidateMode',
          description:
              'Khảo sát sự khác biệt về thời điểm kích hoạt kiểm tra giữa các giá trị AutovalidateMode.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // [Form] Wrap chứa các ChoiceChip để chuyển đổi giữa các chế độ
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AutovalidateMode.values.map((mode) {
                  final isSelected = _currentMode == mode;
                  return ChoiceChip(
                    key: ValueKey('chip_${mode.name}'),
                    label: Text(mode.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        _onModeSelected(mode);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // [Form] Khung thông tin chi tiết giải thích chế độ đang chọn
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(128),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chế độ đang chọn: ${_currentMode.name}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Lỗi hiện khi nào? ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: modeDesc.whenAppears),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Phù hợp khi nào? ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: modeDesc.whenSuitable),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // [Form] Thẻ biểu mẫu áp dụng autovalidateMode đang chọn
        LabCard(
          title: 'Thử nghiệm Form với ${_currentMode.name}',
          description:
              'Nhập liệu hoặc chuyển focus để quan sát thời điểm thông báo lỗi xuất hiện.',
          child: Form(
            key: _formKey,
            autovalidateMode: _currentMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const ValueKey('auto_email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: SignupValidators.validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('auto_phone'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: SignupValidators.validatePhone,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      key: const ValueKey('auto_check_button'),
                      onPressed: _validate,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Kiểm tra'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // [Form] Thẻ ghi chú thực tế về kinh nghiệm sử dụng AutovalidateMode
        Card(
          elevation: 0,
          color: colorScheme.secondaryContainer.withAlpha(70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kinh nghiệm thực tế trong thiết kế Form',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Form đăng ký nên bắt đầu bằng disabled để không báo lỗi khi người dùng chưa nhập xong, và chuyển sang onUserInteraction sau lần submit thất bại đầu tiên để lỗi cập nhật ngay khi sửa.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
