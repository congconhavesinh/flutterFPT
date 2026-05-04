import 'package:flutter/material.dart';
import 'package:myfschools/features/screens/change_password.dart';
import 'package:myfschools/models/user_model.dart';
import 'package:myfschools/features/screens/login.dart';

class SettingsScreen extends StatelessWidget {
  final User user;
  const SettingsScreen({super.key, required this.user});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // 1. TODO: Clear your saved tokens/Shared Preferences here later!
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginStu()),
                      (route) => false, // This destroys all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 40), // Push down below safe area

        // 1. Profile Summary snippet at the top
        Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/icons/42725836-adf9-4fc7-8764-9f671109ee3a-1624678195-502-width600height400.webp'),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.id,
                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 30),

        const Text(
          'Tài khoản',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
        const SizedBox(height: 10),

        _buildSettingsItem(Icons.lock_outline, 'Đổi mật khẩu', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePassword(user: user)
            ),
          );
        }),
        _buildSettingsItem(Icons.security, 'Bảo mật & Quyền riêng tư', () {}),
        const Divider(),


        const SizedBox(height: 10),
        const Text(
          'Cài đặt ứng dụng',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
        const SizedBox(height: 10),

        _buildSettingsItem(Icons.notifications_none, 'Cài đặt thông báo', () {}),
        _buildSettingsItem(Icons.language, 'Ngôn ngữ (Language)', () {}),
        _buildSettingsItem(Icons.dark_mode_outlined, 'Giao diện (Sáng/Tối)', () {}),
        const Divider(),

        const SizedBox(height: 10),
        const Text(
          'Khác',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
        const SizedBox(height: 10),
        _buildSettingsItem(Icons.help_outline, 'Hỗ trợ & Phản hồi', () {}),
        _buildSettingsItem(Icons.info_outline, 'Về ứng dụng My Fschool', () {}),

        const SizedBox(height: 40),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => _handleLogout(context),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper widget to keep code clean
  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}