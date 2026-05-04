import 'package:flutter/material.dart';

class NotificationCarousel extends StatefulWidget {
  const NotificationCarousel({Key? key}) : super(key: key);

  @override
  State<NotificationCarousel> createState() => _NotificationCarouselState();
}

class _NotificationCarouselState extends State<NotificationCarousel> {
   // Keep track of page
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // announcements
  final List<Map<String, String>> notifications = [
    {
      'title': 'Thông báo từ Nhà trường',
      'message': 'Lớp 10A4 chú ý: Nộp báo cáo dự án đúng hạn vào sáng nay.',
    },
    {
      'title': 'Cập nhật học phí',
      'message': 'Hạn chót đóng học phí học kỳ 2 là ngày 15/03. Phụ huynh vui lòng lưu ý.',
    },
    {
      'title': 'Lịch nghỉ lễ',
      'message': 'Học sinh toàn trường nghỉ lễ Giỗ Tổ Hùng Vương vào thứ Năm tuần sau.',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110, // taller to fit the dots and the text
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF0E6),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // swipe
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              // Update the state when the user swipes
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Padding(
                // Push the content down slightly so it doesn't overlap the dots
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 10.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.campaign,
                        color: Color(0xFFE26A2C),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            notifications[index]['title']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notifications[index]['message']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // dots
          Positioned(
            top: 12,
            left: 20,
            child: Row(
              // Generate a dot for every notification in the list
              children: List.generate(
                notifications.length,
                    (index) => _buildDot(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to draw the dots
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Smooth animation when swiping
      margin: const EdgeInsets.only(right: 6),
      height: 8,
      // The active dot is wider (like a pill), inactive dots are small circles
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        // Active dot is solid orange, inactive is faded orange
        color: _currentPage == index
            ? Colors.deepOrange
            : Colors.deepOrange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}