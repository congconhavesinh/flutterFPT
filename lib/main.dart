import 'package:flutter/material.dart';
import 'package:myfschools/features/screens/login.dart';

void main() async {
  //initialize binding before running async
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginStu(),
    );
  }
}


