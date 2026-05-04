import 'package:flutter/material.dart';
import '../../models/user_model.dart'; // Đảm bảo đường dẫn đúng

class StudentInfoScreen extends StatelessWidget {
  final User user;

  const StudentInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoCard(context),
                const SizedBox(height: 20),
                _buildSchoolInfoCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header chứa Avatar và tên
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF1A33B), Color(0xFFAF4034)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 46,
              backgroundImage: AssetImage('assets/icons/42725836-adf9-4fc7-8764-9f671109ee3a-1624678195-502-width600height400.webp'),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            user.fullName,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            'Học sinh',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Card chứa thông tin cá nhân
  Widget _buildInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.badge_outlined, 'Mã học sinh', user.id  ),
          const Divider(),
          _buildInfoRow(Icons.phone_android, 'Số điện thoại', user.phone),
          const Divider(),
          _buildInfoRow(Icons.email_outlined, 'Email', user.email ?? 'Chưa cập nhật'),
          const Divider(),
          _buildInfoRow(Icons.calendar_month_outlined, 'Ngày sinh', user.dob ?? 'Chưa cập nhật'),
          const Divider(),
          _buildInfoRow(Icons.person_outline, 'Giới tính', user.gender ?? 'Chưa cập nhật'),
          const Divider(),
          _buildInfoRow(Icons.location_on_outlined, 'Địa chỉ', user.address ?? 'Chưa cập nhật'),
        ],
      ),
    );
  }

  // Card chứa thông tin trường lớp
  Widget _buildSchoolInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.door_back_door_outlined, 'Lớp học', user.className),
          const Divider(),
          _buildInfoRow(Icons.school_outlined, 'Cơ sở', 'FSCHOOL HÀ NỘI'),
        ],
      ),
    );
  }

  // Widget con để vẽ từng dòng thông tin
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD35433), size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}