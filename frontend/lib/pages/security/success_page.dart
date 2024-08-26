import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    // Navigate back after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LottieBuilder.asset(
          'assets/animations/success2.json',
          width: 300,
          // repeat: true,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
