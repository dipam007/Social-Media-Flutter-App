import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: new Center(
        child: Lottie.asset(
          'assets/json/lottieLoading.json',
          width: double.infinity,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      )
    );
  }
}
