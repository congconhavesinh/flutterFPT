import 'package:flutter/material.dart';

class AppColors {
  // 1. Định nghĩa các màu đơn lẻ
  static const Color orangeMain = Color(0xFFF1A33B); // 0%
  static const Color redMain = Color(0xFFAF4034);    // 100%

  // 2. Định nghĩa dải màu Gradient chuẩn
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [orangeMain, redMain],
    stops: [0.0, 1.0],
  );

  // 3. Shadow đi kèm để đồng bộ UI
  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}