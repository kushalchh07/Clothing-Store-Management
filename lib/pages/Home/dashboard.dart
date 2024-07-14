// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:nepstyle_management_system/Logic/Bloc/dashboardBloc/dashboard_bloc.dart';
import 'package:nepstyle_management_system/constants/color/color.dart';
import 'package:nepstyle_management_system/utils/customwidgets/dividerText.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getDocumentCount() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('category').get();
    return snapshot.size;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<DashboardBloc>(context).add(DashboardLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 90.0,
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text("Dashboard ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        ];
      },
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial) {
            BlocProvider.of<DashboardBloc>(context).add(DashboardLoadEvent());
          }
          if (state is DashboardLoadedState) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        children: [
                          Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.2,
                              decoration: BoxDecoration(
                                  // border: Border.all(color: myBlack, width: 2),
                                  ),
                              child: cards(
                                  state.customercount,
                                  "Total Customers",
                                  myBlue,
                                  Icon(
                                    Icons.people,
                                    color: whiteColor,
                                    size: 50,
                                  ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.2,
                              decoration: BoxDecoration(
                                  // border: Border.all(color: myBlack, width: 2),
                                  ),
                              child: cards(
                                  state.categorycount,
                                  "Total Category",
                                  redColor,
                                  Icon(
                                    Icons.folder_copy_outlined,
                                    color: whiteColor,
                                    size: 50,
                                  ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.2,
                              decoration: BoxDecoration(
                                  // border: Border.all(color: myBlack, width: 2),
                                  ),
                              child: cards(
                                  state.suppliercount,
                                  "Total Supliers",
                                  yellowColor,
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    color: whiteColor,
                                    size: 50,
                                  ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: Get.height * 0.15,
                            width: Get.width * 0.2,
                            decoration: BoxDecoration(
                                // border: Border.all(color: myBlack, width: 2),
                                ),
                            child: cards(
                                state.productcount,
                                'Total Products',
                                greenColor,
                                Icon(
                                  Icons.shopping_bag,
                                  color: whiteColor,
                                  size: 50,
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Failed to load Screen'));
          }
        },
      ),
    );
  }

  Widget cards(
      // BuildContext context,
      int count,
      String text,
      Color color,
      Icon icon) {
    return Card(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                        color: myWhite,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  icon,
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 5),
            child: Text(
              text,
              style: TextStyle(
                  color: myWhite, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
