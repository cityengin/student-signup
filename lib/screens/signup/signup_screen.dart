import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_signup/models/student_registration.dart';
import 'package:student_signup/screens/signup/confirmation_screen.dart';
import 'package:student_signup/validators/signup_validators.dart';

// [Form] Màn hình đăng ký thông tin sinh viên với 6 trường nhập liệu và quản lý focus
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // [Form] Khóa quản lý trạng thái form chính
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // [Form] Các GlobalKey riêng biệt cho từng trường để xác định trường nào bị lỗi đầu tiên
  final GlobalKey<FormFieldState<String>> _fullNameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _studentIdKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _phoneKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _confirmPasswordKey =
      GlobalKey<FormFieldState<String>>();

  // [Form] TextEditingController riêng cho từng trường nhập liệu
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // [Form] FocusNode riêng cho từng trường để điều hướng focus linh hoạt
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _studentIdFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // Trạng thái hiển thị mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // [Form] Chế độ autovalidate bắt đầu là disabled, chỉ chuyển sang onUserInteraction sau lần submit thất bại đầu tiên
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    // [Form] Lắng nghe thay đổi mật khẩu để cập nhật lỗi ô xác nhận mật khẩu sau lần submit thất bại
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    if (_autovalidateMode == AutovalidateMode.onUserInteraction) {
      _confirmPasswordKey.currentState?.validate();
    }
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);

    // Dispose toàn bộ TextEditingController
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Dispose toàn bộ FocusNode
    _fullNameFocusNode.dispose();
    _studentIdFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  // [Form] Xóa trắng biểu mẫu, xóa lỗi và đưa autovalidate về disabled khi người dùng chọn đăng ký tài khoản khác
  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _studentIdController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    setState(() {
      _autovalidateMode = AutovalidateMode.disabled;
      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });

    FocusScope.of(context).unfocus();
  }

  // [Form] Xử lý khi nhấn nút Đăng ký hoặc Enter ở ô cuối cùng
  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });

      // Focus vào ô lỗi đầu tiên theo thứ tự trên form
      if (_fullNameKey.currentState?.hasError == true) {
        _fullNameFocusNode.requestFocus();
      } else if (_studentIdKey.currentState?.hasError == true) {
        _studentIdFocusNode.requestFocus();
      } else if (_emailKey.currentState?.hasError == true) {
        _emailFocusNode.requestFocus();
      } else if (_phoneKey.currentState?.hasError == true) {
        _phoneFocusNode.requestFocus();
      } else if (_passwordKey.currentState?.hasError == true) {
        _passwordFocusNode.requestFocus();
      } else if (_confirmPasswordKey.currentState?.hasError == true) {
        _confirmPasswordFocusNode.requestFocus();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng kiểm tra các ô báo đỏ'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Ẩn bàn phím khi thông tin hợp lệ
    FocusScope.of(context).unfocus();

    // Họ tên, MSSV, email và số điện thoại được trim trước khi đưa vào model
    final registration = StudentRegistration(
      fullName: _fullNameController.text.trim(),
      studentId: _studentIdController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    // Chuyển sang màn hình xác nhận thông tin
    final shouldReset = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(registration: registration),
      ),
    );

    // Nếu người dùng chọn "Đăng ký tài khoản khác" thì xóa toàn bộ dữ liệu và reset form
    if (shouldReset == true && mounted) {
      _resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký tài khoản'),
        centerTitle: true,
      ),
      // [Form] Cuộn nội dung tránh tràn màn hình khi bàn phím ảo hiển thị
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header giới thiệu
                Text(
                  'Thông tin sinh viên',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng điền đầy đủ các thông tin bên dưới để hoàn tất đăng ký.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // 1. Trường Họ và tên
                TextFormField(
                  key: _fullNameKey,
                  controller: _fullNameController,
                  focusNode: _fullNameFocusNode,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _studentIdFocusNode.requestFocus(),
                  validator: SignupValidators.validateFullName,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên *',
                    hintText: 'Ví dụ: Nguyễn Văn An',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Trường Mã số sinh viên
                TextFormField(
                  key: _studentIdKey,
                  controller: _studentIdController,
                  focusNode: _studentIdFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      SignupValidators.studentIdLength,
                    ),
                  ],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                  validator: SignupValidators.validateStudentId,
                  decoration: const InputDecoration(
                    labelText: 'Mã số sinh viên *',
                    hintText: '9 chữ số (ví dụ: 102210123)',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Trường Email
                TextFormField(
                  key: _emailKey,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocusNode.requestFocus(),
                  validator: SignupValidators.validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    hintText: 'Ví dụ: sinhvien@truong.edu.vn',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Trường Số điện thoại
                TextFormField(
                  key: _phoneKey,
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      SignupValidators.phoneLength,
                    ),
                  ],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  validator: SignupValidators.validatePhone,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại *',
                    hintText: '10 chữ số bắt đầu bằng 0 (ví dụ: 0912345678)',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Trường Mật khẩu
                TextFormField(
                  key: _passwordKey,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      _confirmPasswordFocusNode.requestFocus(),
                  validator: SignupValidators.validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu *',
                    hintText: 'Tối thiểu 8 ký tự, có cả chữ và số',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      tooltip: _obscurePassword
                          ? 'Hiện mật khẩu'
                          : 'Ẩn mật khẩu',
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 6. Trường Xác nhận mật khẩu
                TextFormField(
                  key: _confirmPasswordKey,
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                  validator: (value) =>
                      SignupValidators.validateConfirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu *',
                    hintText: 'Nhập lại chính xác mật khẩu trên',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      tooltip: _obscureConfirmPassword
                          ? 'Hiện mật khẩu xác nhận'
                          : 'Ẩn mật khẩu xác nhận',
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Nút Đăng ký submit
                FilledButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.how_to_reg),
                  label: const Text(
                    'Đăng ký tài khoản',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
