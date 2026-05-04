import 'package:flutter/material.dart';
import 'package:myfschools/models/timetable_model.dart';
import '../../models/timetable_model.dart';
import '../auth/timetable_repo.dart';
import '../../core/time_colors.dart';
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  // 1. Thay thế index cố định bằng biến DateTime thực tế
  late DateTime _selectedDate;
  late List<DateTime> _currentWeek;

  List _timetable =[];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentWeek = _getWeekDates(_selectedDate);
    _fetchTimetable();
  }
  Future<void> _fetchTimetable() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try{
      final String studentId = 'HE182093';
      final data = await TimetableRepo().getTimetable(studentId, _selectedDate.weekday);
      setState(() {
        _timetable = data;
        _isLoading = false;
      });
    }catch(e){
      setState(() {
        _isLoading = false;
        _errorMessage = "Lỗi thực tế : $e";
      });
      print("DEBUGGGG: $e");
    }

  }
  void _onDateTapped(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _fetchTimetable(); // moi lan tap se lay lich moi
  }


  // 2. Hàm tự động sinh ra 7 ngày trong tuần dựa vào một ngày bất kỳ
  List<DateTime> _getWeekDates(DateTime baseDate) {
    // Trong Dart, DateTime.monday = 1, sunday = 7
    int currentWeekday = baseDate.weekday;

    // Tìm ngày Thứ 2 của tuần này
    DateTime monday = baseDate.subtract(Duration(days: currentWeekday - 1));

    // Tạo danh sách 7 ngày từ Thứ 2 đến Chủ Nhật
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  // 3. Hàm chuyển tuần khi bấm mũi tên
  void _changeWeek(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _currentWeek = _getWeekDates(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Thời Khóa Biểu'),
        centerTitle: true,
        backgroundColor: const Color(0xFFD35433),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }
  Widget _buildMainContent(){
    if(_isLoading){
      return const Center(child: CircularProgressIndicator(color: Color(0xFFD35433),));
    }
    if(_errorMessage != null){
      return Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red),));
    }
    if(_timetable.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text("Hôm nay không có lịch học!",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: _timetable.length+1, // thêm 1 để hien tiêu đề hc ngày ...
      itemBuilder: (context, index) {
        if(index == 0){
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
           child: Text(
             "Lịch học ngày ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
             style: const TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142)
             )
           )
          );
        }
        final item = _timetable[index-1]; // -1 vi tieu de

        return _buildScheduleCard(
          startTime: item.startTime.substring(0, 5), // Lấy "07:30" từ "07:30:00"
          endTime: item.endTime.substring(0, 5),
          subject: "Môn: ${item.subjectName}",
          teacher: "Giáo Viên: ${item.teacherName}",
          isHappeningNow: _checkIfNow(item.startTime, item.endTime),
        );
      }
    );
  }
  bool _checkIfNow(String start, String end) {
    final now = TimeOfDay.now();
    // Logic so sánh thời gian đơn giản (Bạn có thể tối ưu thêm)
    // Nếu ngày được chọn là "Hôm nay" và nằm trong khoảng thời gian tiết học
    return _selectedDate.day == DateTime.now().day;
  }
  bool _hasScheduleOn(DateTime date){
    return _timetable.any((item) => item.dayOfWeek == date.weekday);
  }

  // --- CẬP NHẬT GIAO DIỆN LỊCH ĐỘNG ---
  Widget _buildDateSelector() {
    // Mảng tên thứ bằng tiếng Việt
    final dayNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút lùi 1 tuần (-7 ngày)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
                  onPressed: () => _changeWeek(-7),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                // Tiêu đề tháng động
                Text(
                  'Tháng ${_currentWeek.first.month}, ${_currentWeek.first.year}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                // Nút tiến 1 tuần (+7 ngày)
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onPressed: () => _changeWeek(7),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Dải ngày trong tuần
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              DateTime date = _currentWeek[index];

              // So sánh ngày trong mảng với ngày đang được chọn
              bool isSelected = date.day == _selectedDate.day &&
                  date.month == _selectedDate.month &&
                  date.year == _selectedDate.year;

              // So sánh xem ngày này có phải hôm nay không (để hiện dấu chấm đỏ)
              DateTime today = DateTime.now();
              bool isToday = date.day == today.day &&
                  date.month == today.month &&
                  date.year == today.year;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date; // Cập nhật ngày được chọn
                  });
                  _fetchTimetable();
                },
                child: Column(
                  children: [
                    Text(
                      dayNames[index], // Hiện T2, T3...
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFD35433) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFD35433) : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}', // Hiện ngày động (14, 15, 16...)
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Dấu chấm đỏ đánh dấu ngày "Hôm nay"
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: isToday && !isSelected
                          ? const Color(0xFFD35433)
                          : Colors.transparent,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  Widget _buildScheduleCard({
    required String startTime,
    required String endTime,
    required String subject,
    required String teacher,
    required bool isHappeningNow,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        // The orange accent line on the left
        border: Border(
          left: BorderSide(
            color: isHappeningNow ? const Color(0xFFD35433) : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Time Column
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    startTime,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isHappeningNow ? FontWeight.bold : FontWeight.w600,
                      color: isHappeningNow ? const Color(0xFFD35433) : Colors.black87,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(':', style: TextStyle(color: Colors.grey)),
                  ),
                  Text(
                    endTime,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Vertical Divider
            const VerticalDivider(
              color: Color(0xFFF0F0F0),
              thickness: 1,
              width: 1,
              indent: 15,
              endIndent: 15,
            ),

            // Details Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 18, color: Color(0xFFD35433)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subject,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            teacher,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}