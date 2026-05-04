class Timetable {
  final int? id;
  final String subjectName;
  final String teacherName;
  final String className;
  final String startTime;
  final String endTime;
  final int dayOfWeek;

  Timetable({
    this.id,
    required this.subjectName,
    required this.teacherName,
    required this.className,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
  });


  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'],
      subjectName: json['subjectName'] ?? 'Không rõ môn',
      teacherName: json['teacherName'] ?? 'Chưa xếp GV',
      className: json['className'] ?? '',
      startTime: json['startTime'] ?? '00:00',
      endTime: json['endTime'] ?? '00:00',
      dayOfWeek: json['dayOfWeek'] ?? 0,
    );
  }
}