import 'package:flutter/material.dart';
import 'package:myfschools/utils/constants/colors.dart';
import '../auth/auth_repo.dart';
import 'package:myfschools/features/screens/login.dart';

class MailVerify extends StatefulWidget {
  final String phoneNumber;
  const MailVerify({super.key, required this.phoneNumber});

  @override
  State<MailVerify> createState() => _VerifyState();
}

class _VerifyState extends State<MailVerify> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  bool _isLoading = false;
  final AuthRepository _authRepo = AuthRepository();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _newPass.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    String otp = _otpController.text.trim();
    String newPassword = _newPass.text.trim();
    String phoneToVerify = widget.phoneNumber;
    if (otp.length == 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã OTP đã được xác nhận thành công!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mã OTP gồm 6 chữ số')),
      );
    }
    setState(() {
      _isLoading = true;
    });
    try{
      String successfulMessage = await _authRepo.verifyandChangePass(phoneToVerify, otp, newPassword);
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successfulMessage),
            backgroundColor: Colors.green,
          )
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginStu()),
            (route) => false,
      );



    }catch(e){
      String errorMessage = e.toString().replaceAll('Exception', '');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          )
      );
    }finally{
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
        centerTitle: true,
        backgroundColor: const Color(0xFFD35433),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/logos/logo.png', height: 150),
              const SizedBox(height: 40),
              const Text(
                'Chúng tôi đã gửi mã OTP đến email liên kết với số điện thoại. Vui lòng kiểm tra và nhập mã vào bên dưới.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '000000',
                  hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 10),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _newPass,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu mới',
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD35433),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                      : const Text(
                    'Xác Nhận & Đổi Mật Khẩu',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  // TODO: Resend OTP logic
                },
                child: const Text(
                  'Gửi lại mã OTP?',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Copyright ©2026 FPT Student Managements Inc. \nAll rights reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ProjectColors.cpyrightColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
