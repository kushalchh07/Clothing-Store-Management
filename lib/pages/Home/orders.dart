// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../constants/color/color.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
              // centerTitle: tru,
              title: Text("Orders ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
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
