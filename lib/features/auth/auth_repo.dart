import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/user_model.dart';


class AuthRepository {
  final String _baseUrl = "http://10.0.2.2:8080";

  Future<User?> login(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "phone": phone,
          "password": password,
        }),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // 1. Decode the JSON string from Spring Boot into a Map

        // 2. Use your User class to create a real Dart object
        final loggedInUser = User.fromJson(responseData);

        print("Welcome, ${loggedInUser.fullName}!");
        return loggedInUser;

      } else if (response.statusCode == 401) {
        throw Exception(responseData['error'] ?? 'Sai thông tin đăng nhập');
      } else {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }
    } catch (e) {
      print("Network Error: $e");
      return null;
    }
  }

  Future<String> requestPasswordReset(String phone) async {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "phone": phone
        }),
      ).timeout(const Duration(seconds: 5));
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseData['message'] ?? 'OTP đã được gửi';
      } else {
        throw Exception(responseData['message'] ?? 'Số điện thoại không hợp lệ');
      }
  }
  Future<String> verifyandChangePass(String phone, String otp, String newPassword) async {

      final response = await http.post(
        Uri.parse('$_baseUrl/phoneToEmailOTP-verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "phone": phone,
          "otp":otp,
          "newPassword":newPassword,
        }),
      ).timeout(const Duration(seconds: 5));
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData['message'] ?? 'Đổi mật khẩu thành công';
      } else {
        throw Exception(responseData['message'] ?? 'Mã OTP không hợp lệ hoặc đã hết hạn');
      }
    }


}