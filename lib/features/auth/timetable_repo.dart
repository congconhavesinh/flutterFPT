import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/user_model.dart';
import '../../models/timetable_model.dart';
class TimetableRepo {
  final String _baseUrl = "http://10.0.2.2:8080";

  Future<List<Timetable>> getTimetable(String studentId,int day) async {
      final response = await http.get(
          Uri.parse('$_baseUrl/api/student/timetable/$studentId/day/$day')
      );

      print("Checkkkkkkkkkk: ${response.body}" );
      if(response.statusCode==200){
        List<dynamic> body = json.decode(response.body);

        List<Timetable> timetable = body.map((item) => Timetable.fromJson(item)).toList();
        return timetable;
      }else{
        throw Exception("Không thể lấy lịch học");
      }
  }
}