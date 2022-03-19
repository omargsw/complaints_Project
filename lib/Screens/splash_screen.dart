import 'dart:async';
import 'package:complaints_project/Screens/home_page.dart';
import 'package:complaints_project/Screens/nav_bar.dart';
import 'package:complaints_project/Widgets/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => NavBar())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/logo.jpeg',
              height: 250,
              width: 250,
            ),
          ),
          const SizedBox(height: 250,),
          CircularProgressIndicator(color: ColorForDesign().blue,)
        ],
      ),
    );
  }
}