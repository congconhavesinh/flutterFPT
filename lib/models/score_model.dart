class ScoreModel {
  final String subjectName;
  final String classScore;
  final String midtermScore;
  final String finalScore;
  final String averageScore;

  ScoreModel({
    required this.subjectName,
    required this.classScore,
    required this.midtermScore,
    required this.finalScore,
    required this.averageScore,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      subjectName: json['subjectName'] ?? 'Chưa rõ',
      classScore: json['classScore']?.toString() ?? '',
      midtermScore: json['midtermScore']?.toString() ?? '',
      finalScore: json['finalScore']?.toString() ?? '',
      averageScore: json['averageScore']?.toString() ?? '',
    );
  }
}