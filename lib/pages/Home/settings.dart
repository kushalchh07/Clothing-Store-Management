// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
            expandedHeight: 120.0,
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
              title: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Text("Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
            ),
          ),
        ];
      },
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.photo),
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
}
