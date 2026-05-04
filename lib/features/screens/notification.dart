import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dữ liệu mẫu (Mock Data) - Sau này bạn sẽ thay bằng dữ liệu từ API
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Nhắc nhở đóng học phí',
      'body': 'Hạn chót đóng học phí học kỳ 2 là ngày 30/03/2026. Phụ huynh vui lòng chú ý hoàn thành đúng hạn.',
      'time': '10 phút trước',
      'isRead': false,
      'type': 'fee',
    },
    {
      'title': 'Cập nhật điểm thi Giữa kì',
      'body': 'Điểm thi giữa kì môn Toán và Ngữ Văn của học sinh đã được cập nhật trên hệ thống.',
      'time': '2 giờ trước',
      'isRead': false,
      'type': 'score',
    },
    {
      'title': 'Thông báo thay đổi lịch học',
      'body': 'Tiết Thể dục chiều thứ 6 (27/03) sẽ được dời sang sáng thứ 7. Học sinh chú ý mang trang phục phù hợp.',
      'time': '1 ngày trước',
      'isRead': true,
      'type': 'schedule',
    },
    {
      'title': 'Thư mời họp phụ huynh',
      'body': 'Kính mời quý phụ huynh tham gia buổi họp tổng kết tháng vào lúc 8h00 sáng Chủ nhật tuần này tại phòng 302.',
      'time': '3 ngày trước',
      'isRead': true,
      'type': 'event',
    },
    {
      'title': 'Hoàn thành bài tập về nhà',
      'body': 'Học sinh có 2 bài tập môn Tiếng Anh cần hoàn thành trước 22h00 tối nay.',
      'time': '5 ngày trước',
      'isRead': true,
      'type': 'homework',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám nhạt đồng bộ
      appBar: _buildAppBar(),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final noti = _notifications[index];
          return _buildNotificationCard(noti);
        },
      ),
    );
  }

  // 1. AppBar Gradient
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false, // Ẩn nút back nếu nó nằm trong BottomNavBar
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1A33B), Color(0xFFAF4034)],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.done_all, color: Colors.white),
          tooltip: 'Đánh dấu đã đọc tất cả',
          onPressed: () {
            setState(() {
              for (var noti in _notifications) {
                noti['isRead'] = true;
              }
            });
          },
        )
      ],
    );
  }

  // 2. Thẻ Thông báo (Notification Card)
  Widget _buildNotificationCard(Map<String, dynamic> noti) {
    bool isRead = noti['isRead'];

    return InkWell(
      onTap: () {
        // Đánh dấu đã đọc khi click vào
        if (!isRead) {
          setState(() {
            noti['isRead'] = true;
          });
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Nền cam cực nhạt nếu chưa đọc, nền trắng nếu đã đọc
          color: isRead ? Colors.white : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(16),
          border: isRead ? null : Border.all(color: const Color(0xFFF1A33B).withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon bên trái
            _buildIconForType(noti['type'], isRead),
            const SizedBox(width: 16),

            // Nội dung ở giữa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noti['title'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                      color: isRead ? Colors.black87 : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    noti['body'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isRead ? Colors.black54 : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    noti['time'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Chấm đỏ đánh dấu chưa đọc ở góc phải
            if (!isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFD35433),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 3. Hàm chọn Icon và màu sắc dựa theo loại thông báo
  Widget _buildIconForType(String type, bool isRead) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case 'fee':
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      case 'score':
        iconData = Icons.bar_chart;
        iconColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
        break;
      case 'schedule':
        iconData = Icons.calendar_month;
        iconColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'event':
        iconData = Icons.campaign;
        iconColor = const Color(0xFFAF4034); // Đỏ đô
        bgColor = const Color(0xFFAF4034).withOpacity(0.1);
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
        bgColor = Colors.grey.withOpacity(0.1);
    }

    // Nếu đã đọc thì làm mờ icon đi một chút
    if (isRead) {
      iconColor = iconColor.withOpacity(0.5);
      bgColor = Colors.grey.withOpacity(0.05);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  // 4. Màn hình trống (Khi không có thông báo nào)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Bạn không có thông báo nào',
            style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}