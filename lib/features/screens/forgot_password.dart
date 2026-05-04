import 'package:flutter/material.dart';
import 'package:myfschools/features/screens/verify.dart';
import '../../utils/constants/colors.dart';
import '../auth/auth_repo.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  final AuthRepository _authRepo = AuthRepository();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại')),
      );
      return;
    } else{
      setState(() {
        _isLoading = true;
      });
      try{
        String successfulMessage = await _authRepo.requestPasswordReset(phoneNumber);
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(successfulMessage),
              backgroundColor: Colors.green,
          )
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MailVerify(phoneNumber : phoneNumber)),
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFD35433),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Image.asset('assets/logos/fpt.png', height: 100),
                      const SizedBox(height: 20),
                      Image.asset('assets/logos/logo.png', height: 150), // Changed from logo2.png as it might not exist
                      const SizedBox(height: 20),
                      const Text(
                        'Yêu cầu xác thực đổi mật khẩu sẽ được gửi qua email đã đăng ký với số điện thoại này',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: 'Thông tin tài khoản',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Số điện thoại',
                          prefixIcon: const Icon(Icons.phone_android_outlined, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _handleVerify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD35433),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Xác Nhận',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(), // Replaced Expanded(child: SizedBox()) with Spacer()
                      Text(
                        'Copyright ©2026 FPT Student Managements Inc. \nAll rights reserved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ProjectColors.cpyrightColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
