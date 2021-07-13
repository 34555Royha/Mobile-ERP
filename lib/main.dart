import 'package:bank/provider/auth/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SBILH Bank',
      home: SplashScreen(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
