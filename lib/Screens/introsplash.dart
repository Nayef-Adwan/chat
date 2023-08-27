import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'MainScreen.dart';
import 'Splash.dart'; // Import the animation package

class IntroSplashScreen extends StatefulWidget {

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  @override
  void initState() {
    super.initState();

    // Use a Timer to show the splash screen for 6 seconds
    Timer(Duration(seconds: 6), () {
      // After 6 seconds, navigate to the main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set your desired background color
      body: Center(
        child:
        Lottie.asset(
          'assets/introvideo.json', // Replace with your animation asset
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
