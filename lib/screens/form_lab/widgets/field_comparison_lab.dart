import 'package:flutter/material.dart';
import 'package:student_signup/screens/form_lab/widgets/lab_card.dart';
import 'package:student_signup/validators/signup_validators.dart';

// [Form] Tab so sánh cơ chế quản lý lỗi giữa TextField (thủ công) và TextFormField (Form)
class FieldComparisonLab extends StatefulWidget {
  const FieldComparisonLab({super.key});

  @override
  State<FieldComparisonLab> createState() => _FieldComparisonLabState();
}

class _FieldComparisonLabState extends State<FieldComparisonLab> {
  // --- Card 1: TextField tự quản lý ---
  final TextEditingController _tfEmailController = TextEditingController();
  final TextEditingController _tfPhoneController = TextEditingController();
  String? _tfEmailError;
  String? _tfPhoneError;
  String? _tfStatus;

  // --- Card 2: TextFormField có Form quản lý ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tffEmailController = TextEditingController();
  final TextEditingController _tffPhoneController = TextEditingController();
  String? _tffStatus;

  @override
  void dispose() {
    // [Form] Giải phóng toàn bộ các TextEditingController để tránh rò rỉ bộ nhớ
    _tfEmailController.dispose();
    _tfPhoneController.dispose();
    _tffEmailController.dispose();
    _tffPhoneController.dispose();
    super.dispose();
  }

  // [Form] Kiểm tra thủ công từng ô TextField và cập nhật biến lỗi riêng lẻ
  void _validateTextFields() {
    final emailErr = SignupValidators.validateEmail(_tfEmailController.text);
    final phoneErr = SignupValidators.validatePhone(_tfPhoneController.text);

    setState(() {
      _tfEmailError = emailErr;
      _tfPhoneError = phoneErr;
      _tfStatus = (emailErr == null && phoneErr == null) ? 'Hợp lệ' : 'Còn lỗi';
    });
  }

  // [Form] Tự xóa chữ và xóa từng biến lỗi của TextField
  void _clearTextFields() {
    setState(() {
      _tfEmailController.clear();
      _tfPhoneController.clear();
      _tfEmailError = null;
      _tfPhoneError = null;
      _tfStatus = null;
    });
  }

  // [Form] TextFormField chỉ cần gọi một lần FormState.validate()
  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _tffStatus = isValid ? 'Hợp lệ' : 'Còn lỗi';
    });
  }

  // [Form] Xóa form bằng cách gọi reset() trước, sau đó clear các controller
  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _tffEmailController.clear();
      _tffPhoneController.clear();
      _tffStatus = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // [Form] Thẻ 1: TextField - Nhà phát triển phải tự quản lý controller, state và errorText
        LabCard(
          title: 'TextField: tự quản lý',
          description:
              'Mỗi ô phải tự tạo controller, biến String? lưu lỗi, gọi hàm kiểm tra từng ô và tự truyền vào errorText.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const ValueKey('tf_email'),
                controller: _tfEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  errorText: _tfEmailError,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('tf_phone'),
                controller: _tfPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: const OutlineInputBorder(),
                  errorText: _tfPhoneError,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    key: const ValueKey('tf_check_button'),
                    onPressed: _validateTextFields,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Kiểm tra'),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('tf_clear_button'),
                    onPressed: _clearTextFields,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Xóa'),
                  ),
                ],
              ),
              if (_tfStatus != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        _tfStatus == 'Hợp lệ'
                            ? Icons.check_circle
                            : Icons.error_outline,
                        color: _tfStatus == 'Hợp lệ'
                            ? colorScheme.primary
                            : colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _tfStatus!,
                        key: const ValueKey('tf_status_text'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _tfStatus == 'Hợp lệ'
                              ? colorScheme.primary
                              : colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // [Form] Thẻ 2: TextFormField - FormState tự động quản lý và kiểm tra toàn bộ các trường
        LabCard(
          title: 'TextFormField: Form quản lý',
          description:
              'Dùng Form và GlobalKey<FormState>. Chỉ cần gọi một lần validate() để kiểm tra hoặc reset() để xóa lỗi.',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const ValueKey('tff_email'),
                  controller: _tffEmailController,
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
                  key: const ValueKey('tff_phone'),
                  controller: _tffPhoneController,
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
                      key: const ValueKey('tff_check_button'),
                      onPressed: _validateForm,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Kiểm tra'),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('tff_clear_button'),
                      onPressed: _clearForm,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Xóa'),
                    ),
                  ],
                ),
                if (_tffStatus != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          _tffStatus == 'Hợp lệ'
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: _tffStatus == 'Hợp lệ'
                              ? colorScheme.primary
                              : colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _tffStatus!,
                          key: const ValueKey('tff_status_text'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _tffStatus == 'Hợp lệ'
                                ? colorScheme.primary
                                : colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // [Form] Thẻ 3: Bảng so sánh 3 khía cạnh chính giữa hai cơ chế
        LabCard(
          title: 'So sánh cơ chế hoạt động',
          description:
              'Bảng tổng hợp sự khác biệt cốt lõi trong việc quản lý trạng thái, kiểm tra và xóa lỗi.',
          child: Table(
            border: TableBorder.all(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1.4),
              2: FlexColumnWidth(1.4),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                ),
                children: [
                  _buildTableCell('Tiêu chí', isHeader: true, theme: theme),
                  _buildTableCell('TextField (Tự quản lý)',
                      isHeader: true, theme: theme),
                  _buildTableCell('TextFormField (Form)',
                      isHeader: true, theme: theme),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('Nơi lưu lỗi', isBold: true, theme: theme),
                  _buildTableCell(
                      'Biến riêng của widget cha (String? tự quản lý)',
                      theme: theme),
                  _buildTableCell('FormFieldState nội bộ của Flutter',
                      theme: theme),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('Cách kiểm tra nhiều ô',
                      isBold: true, theme: theme),
                  _buildTableCell(
                      'Gọi từng hàm validator, gán setState từng biến lỗi',
                      theme: theme),
                  _buildTableCell(
                      'Gọi một lần FormState.validate() cho toàn bộ Form',
                      theme: theme),
                ],
              ),
              TableRow(
                children: [
                  _buildTableCell('Cách xóa lỗi', isBold: true, theme: theme),
                  _buildTableCell(
                      'Tự gán từng biến lỗi về null và setState thủ công',
                      theme: theme),
                  _buildTableCell(
                      'Gọi FormState.reset(), tự động xóa lỗi toàn bộ các ô',
                      theme: theme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    bool isBold = false,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: (isHeader || isBold) ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? theme.colorScheme.primary : null,
        ),
      ),
    );
  }
}
