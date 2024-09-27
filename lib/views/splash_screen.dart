import 'package:assignment_app/views/Update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // For the delay

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller and animation
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    Timer(Duration(seconds: 4), () {
      Get.off(UpdateProfilePage());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScaleTransition(
        scale: _animation,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 150, // Size of the Flutter logo
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Assignment Task",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
