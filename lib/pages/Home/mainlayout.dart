// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:nepstyle_management_system/constants/color/color.dart';
import 'package:nepstyle_management_system/pages/Home/billing.dart';
import 'package:nepstyle_management_system/pages/Home/category.dart';
import 'package:nepstyle_management_system/pages/Home/customers.dart';
import 'package:nepstyle_management_system/pages/Home/dashboard.dart';
import 'package:nepstyle_management_system/pages/Home/help.dart';
import 'package:nepstyle_management_system/pages/Home/inventory.dart';
import 'package:nepstyle_management_system/pages/Home/orders.dart';
import 'package:nepstyle_management_system/pages/Home/purchases.dart';
import 'package:nepstyle_management_system/pages/Home/report.dart';
import 'package:nepstyle_management_system/pages/Home/sales.dart';
import 'package:nepstyle_management_system/pages/Home/settings.dart';
import 'package:nepstyle_management_system/pages/Home/supplier.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _showFooter = false;
  // List of widgets for each screen
  final List<Widget> _screens = [
    DashboardScreen(),
    CustomerScreen(),
    OrderScreen(),
    InventoryScreen(),
    Category(),
    Supplier(),
    Purchases(),
    Sales(),
    Report(),
    Billing(),
    // Help(),
    Settings(),
  ];
  // ScrollController _scrollController = ScrollController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _scrollController.addListener(_scrollListener);
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     setState(() {
  //       _showFooter = true;
  //     });
  //   } else {
  //     setState(() {
  //       _showFooter = false;
  //     });
  //   }
  // }

  @override
  void dispose() {
    // Dispose scroll controller to avoid memory leaks
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            // _scrollListener();
          }
          return true;
        },
        child: Column(
          children: [
            // Image.asset above the NavigationRail

            Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/icons/logo.png",
                        width: 150,
                        height: 150,
                      ),
                      Expanded(
                        child: NavigationRail(
                          selectedIndex: _selectedIndex,
                          onDestinationSelected: _onItemTapped,
                          labelType: NavigationRailLabelType.none,
                          extended: true,
                          minExtendedWidth: 200,
                          destinations: [
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.dashboard,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Dashboard',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.people,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Customers',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.shopping_cart,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Orders',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.production_quantity_limits,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Inventory',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.folder,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Category',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.local_shipping_outlined,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Supplier',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.shopping_bag,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Purchases',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.receipt,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Sales',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.report_outlined,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Report',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.credit_card_outlined,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Billing',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            // NavigationRailDestination(
                            //   icon: Icon(
                            //     Icons.help_center_outlined,
                            //     color: primaryColorLight,
                            //   ),
                            //   label: Text(
                            //     'Help',
                            //     style: TextStyle(
                            //         color: greyVeryDark,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w600),
                            //   ),
                            // ),
                            NavigationRailDestination(
                              icon: Icon(
                                Icons.settings,
                                color: primaryColorLight,
                              ),
                              label: Text(
                                'Settings',
                                style: TextStyle(
                                    color: greyVeryDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(thickness: 1, width: 1),
                  // Right side content
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: _screens,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[200],
              height: 60,
              width: double.infinity,
              child: Center(
                child: Text(
                  '© 2024 Clothing Store Management. All rights reserved.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
