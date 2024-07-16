// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:nepstyle_management_system/constants/sharedPreferences/sharedPreferences.dart';
import 'package:nepstyle_management_system/pages/login%20&%20signup/login.dart';
import 'package:nepstyle_management_system/services/auth_service.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

import '../../constants/color/color.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 80.0,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              )),
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                title: Text("Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
            ),
          ];
        },
        body: Container(
          child: Column(
            children: [
              Text("My Profile"),
              ElevatedButton(onPressed: logOut, child: Text("Log Out")),
            ],
          ),
        ));
  }

  logOut() {
    AuthService.logout();
    saveStatus(false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  }
}
