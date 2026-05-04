import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/score_model.dart';
import 'package:myfschools/models/user_model.dart';

class ScoreScreen extends StatefulWidget {
  final User user;
  const ScoreScreen({super.key, required this.user});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  String _selectedYear = '2025-2026';

  List<ScoreModel> _scores = [];
  bool _isLoading = true;
  String? _errorMessage;

  final String _baseUrl = 'http://10.0.2.2:8080';

  @override
  void initState() {
    super.initState();
    _fetchScores(_selectedYear);
  }

  Future<void> _fetchScores(String year) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/student/scores/${widget.user.id}?schoolYear=$year'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          _scores = data.map((json) => ScoreModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Lỗi máy chủ: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể kết nối tới máy chủ. Vui lòng kiểm tra mạng!';
        _isLoading = false;
      });
      print("Lỗi API Điểm: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterSection(),

          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Bảng Điểm', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1A33B), Color(0xFFAF4034)],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedYear,
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFD35433)),
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
            items: ['2024-2025', '2025-2026', '2026-2027'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('Năm học: $value'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null && newValue != _selectedYear) {
                setState(() {
                  _selectedYear = newValue;
                });
                _fetchScores(newValue);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD35433)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchScores(_selectedYear), // Nút thử lại
              child: const Text('Thử lại'),
            )
          ],
        ),
      );
    }

    if (_scores.isEmpty) {
      return const Center(
        child: Text('Chưa có dữ liệu điểm cho năm học này.',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return _buildScoreTable();
  }

  Widget _buildScoreTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFFFF3E0)),
              columnSpacing: 25,
              dataRowMinHeight: 45,
              dataRowMaxHeight: 45,
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              columns: const [
                DataColumn(label: Text('Môn', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Trên lớp', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Giữa kì', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Cuối kì', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Tổng kết', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFAF4034)))),
              ],

              // 5. Đổ dữ liệu thật từ _scores vào các dòng (Rows)
              rows: _scores.map((score) {
                int index = _scores.indexOf(score);
                Color rowColor = index % 2 == 0 ? Colors.white : Colors.grey.shade50;

                return DataRow(
                  color: MaterialStateProperty.resolveWith((states) => rowColor),
                  cells: [
                    DataCell(Text(score.subjectName, style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(Center(child: Text(score.classScore))),
                    DataCell(Center(child: Text(score.midtermScore))),
                    DataCell(Center(child: Text(score.finalScore))),
                    DataCell(Center(
                      child: Text(
                        score.averageScore,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFAF4034)),
                      ),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}