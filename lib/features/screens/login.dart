import 'package:flutter/material.dart';
import 'package:myfschools/features/screens/forgot_password.dart';
import 'package:myfschools/models/user_model.dart';
import 'package:myfschools/utils/constants/colors.dart';
import '../auth/auth_repo.dart';
import '../hpage/homepage.dart';
import '';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginStu extends StatefulWidget {
  const LoginStu({super.key});

  @override
  State<LoginStu> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginStu> {
  final _formKey = GlobalKey<FormState>();

  //visbility
  bool _isObscured = true;
  bool _isLoading = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  @override
  void dispose() {
    // clean up
    // TODO: implement dispose
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();

  }
  Future<void> _handleLogin() async{
    FocusScope.of(context).unfocus();

    if(!_formKey.currentState!.validate()){
      return;
    }


    setState(() {
      _isLoading = true;
    });

    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    print(phone);
    print(password);


    //after check empty -> auth
    final loggedInUser = await _authRepository.login(phone, password);

    if(!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if(loggedInUser != null){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeStu(user: loggedInUser)),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thất bại'),
          backgroundColor: Colors.red,
        )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 32.0,
                right: 32.0,
              ),
              child: Form(
                key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/logos/fpt.png', height: 100,),
                  const SizedBox(height: 15),

                  //logo
                  Image.asset('assets/logos/logo2.png', height: 200),
                  const SizedBox(height: 20),
                  //sdt
                  TextFormField(
                    controller: _phoneController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Vui lòng nhập số điện thoại';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      hintText: 'Số điện thoại',
                      prefixIcon: const Icon(
                        Icons.phone_android_outlined,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Vui lòng nhập mật khẩu';
                      }
                      return null;
                    },
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      hintText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_person, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                          icon: Icon(
                            _isObscured ? Icons.visibility_off : Icons.visibility_rounded
                          ),

                    ),
                  ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(

                      //chekc kiiiiiiiiiiiiiiiiii

                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD35433),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                      ),

                      //chekc kiiiiiiiiiiiiiiiiii

                      child: _isLoading ? const CircularProgressIndicator(color: Colors.green,) : const Text
                        (
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                      child: const Text(
                        'Quên/Lấy mật khẩu?',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                  ),
                  
                  const Expanded(child: SizedBox()),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Copyright ©2026 FPT Student Managements Inc. \n'
                          'All rights reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ProjectColors.cpyrightColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),),
      ),
    );
  }
}
