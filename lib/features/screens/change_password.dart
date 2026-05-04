import 'package:flutter/material.dart';
import 'package:myfschools/models/user_model.dart';
import 'package:myfschools/features/auth/auth_repo.dart';
class ChangePassword extends StatefulWidget {
  final User user;
  const ChangePassword({super.key,required this.user});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscured1 = true;
  bool _isObscured2 = true;
  bool _isObscured3 = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitChange() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();

    // Call Spring Boot!
    final isSuccess = await _authRepository.requestPasswordReset(
        widget.user.phone,

    );

    if (!mounted) return;
    setState(() => _isLoading = false);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi Mật Khẩu', style: TextStyle(color: Colors
            .white)),
        backgroundColor: const Color(0xFFD35433),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Old Password
              TextFormField(
                controller: _oldPasswordController,
                obscureText: _isObscured1,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscured1 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _isObscured1 = !_isObscured1),
                  ),
                ),
                validator: (val) =>
                val!.isEmpty
                    ? 'Vui lòng nhập mật khẩu hiện tại'
                    : null,
              ),
              const SizedBox(height: 20),

              // new
              TextFormField(
                controller: _newPasswordController,
                obscureText: _isObscured2,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscured2 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _isObscured2 = !_isObscured2),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Vui lòng nhập mật khẩu mới';
                  if (val.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
                  if (val == _oldPasswordController.text)
                    return 'Mật khẩu mới phải khác mật khẩu cũ';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. Confirm New Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscured3,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscured3 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _isObscured3 = !_isObscured3),
                  ),
                ),
                validator: (val) {
                  if (val != _newPasswordController.text)
                    return 'Mật khẩu xác nhận không khớp';
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD35433),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Cập nhật mật khẩu',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
