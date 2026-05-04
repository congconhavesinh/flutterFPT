import 'package:flutter/material.dart';
import 'package:myfschools/features/screens/score.dart';
import 'package:myfschools/features/screens/student_info.dart';
import 'package:myfschools/features/screens/timetable.dart';
import '../../models/user_model.dart';
import 'noti.dart';
import '../screens/notification.dart';
import 'setting.dart';

class HomeStu extends StatefulWidget {
  final User user;
  const HomeStu({super.key,required this.user});

  @override
  State<HomeStu> createState() => _HomeStuState();
}

class _HomeStuState extends State<HomeStu> {
  int _selectedIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  Widget _buildCurrentBody(){
    final List<Widget> screens = [
      SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildFeatureGrid(context),
          ],
        ),
      ),
      const NotificationScreen(),
      StudentInfoScreen(user: widget.user),
      SettingsScreen(user: widget.user),
    ];
    return screens[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: _buildCurrentBody(),

      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onTapped,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.black87,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Trang chủ'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active_sharp),
                label: 'Thông báo'),
            BottomNavigationBarItem(
                icon: Icon(Icons.school), label: 'Thông tin'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Cài đặt'),
          ]
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF1A33B),
            Color(0xFFAF4034),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //avatar
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFFAF0E6),
                  backgroundImage: AssetImage('assets/icons/42725836-adf9-4fc7-8764-9f671109ee3a-1624678195-502-width600height400.webp'),

                ),
              ),

              const SizedBox(width: 15),

            // thông tin cá nhân
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào, ${widget.user.fullName} ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mã HS: ${widget.user.id}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              _buildInfoChip(Icons.door_back_door_outlined, widget.user.className),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.location_city, 'FSCHOOL HÀ NỘI'),
            ],
          ),
          SizedBox(height: 20),

          const NotificationCarousel(),
        ],
      ),
    );
  }
  Widget _buildFeatureGrid(BuildContext context) {
    List<Map<String, dynamic>> features = [
      {
        'icon': Image.asset('assets/icons/calendar-dots-fill.png', height: 100,width: 100, ),
        'title': 'Thời Khóa Biểu',
        'screen' : const TimetableScreen(),
      },
      { 'icon': Image.asset('assets/icons/list-checks-fill.png'),
        'title': 'Điếm Danh',
        'screen' : const TimetableScreen(),
      },
      { 'icon': Image.asset('assets/icons/money-wavy-fill.png'),
        'title': 'Học Phí',
        'screen' : const TimetableScreen(),
      },
      { 'icon': Image.asset('assets/icons/stat.png'),
        'title': 'Bảng Điểm',
        'screen' : ScoreScreen(user: widget.user),
      },
      { 'icon': Image.asset('assets/icons/users-four-fill.png'),
        'title': 'Câu lạc bộ',
        'screen' : const TimetableScreen(),
      },
      { 'icon': Image.asset('assets/icons/envelope-fill.png'),
        'title': 'Thư từ',
        'screen' : const TimetableScreen(),
      },
      { 'icon': Image.asset('assets/icons/book-open-fill.png'),
        'title': 'BTVN',
        'screen' : const TimetableScreen(),
      },
    ];
    //grid
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return _buildFeatureCard(
                features[index]['icon'] as Widget,
                features[index]['title'] as String,
                    (){
                  Widget? targetScreen = features[index]['screen'];
                  if(targetScreen != null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => targetScreen),
                    );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tính năng ${features[index]['title']} chưa được cài đặt'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
            );
          }
      ),
    );
  }
}
Widget _buildInfoChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.2), // Màu mờ
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}





Widget _buildFeatureCard(Widget customIcon, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black38,
          spreadRadius: 2,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          //icon
          height: 65,
          width: 65,
          child: Center(
            child: customIcon,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    ),
    ),
  );
}



