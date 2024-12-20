import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/pages/Home/category.dart';
import 'package:nepstyle_management_system/pages/login%20&%20signup/login.dart';
import 'package:nepstyle_management_system/pages/login%20&%20signup/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/color/color.dart';
import '../Home/mainlayout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String KEYLOGIN = "login";

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  void navigateToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedin = prefs.getBool(SplashScreen.KEYLOGIN);

    Future.delayed(Duration(seconds: 1), () {
      if (isLoggedin != null && isLoggedin) {
        Get.offAll(() => MainLayout());
      } else {
        // Get.offAll(() => Login());
        Get.offAll(() => MainLayout());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SizedBox(
                // width: Get.width * 0.80,
                child: Image.asset(
                  "assets/icons/logo.png",
                  fit: BoxFit.fitWidth,
                  // scale: 2,
                  height: 400,
                  width: 400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
