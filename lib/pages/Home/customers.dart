// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/customersBloc/customer_bloc.dart';
import 'package:nepstyle_management_system/utils/customwidgets/dividerText.dart';
import '../../constants/color/color.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CustomerBloc>(context).add(CustomerLoadEvent());
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Customer'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                  controller: _nameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                  controller: _addressController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                  controller: _phoneController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email address';
                    }
                    return null;
                  },
                  controller: _emailController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  log('Name: ${_nameController.text.trim()}');
                  log('Address: ${_addressController.text}');
                  log('Phone Number: ${_phoneController.text}');
                  log('Email Address: ${_emailController.text}');

                  BlocProvider.of<CustomerBloc>(context).add(
                    CustomerAddButtonTappedEvent(
                      name: _nameController.text.trim(),
                      address: _addressController.text.trim(),
                      phone: _phoneController.text.trim(),
                      email: _emailController.text.trim(),
                      id: DateTime.now().toString(),
                    ),
                  );
                  log("added to the bloc");
                  BlocProvider.of<CustomerBloc>(context)
                      .add(CustomerLoadEvent());
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
              ),
            ),
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Customers",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dividerText(
                  context: context,
                  dividerText: "Customers",
                  desc: "",
                ),
                ElevatedButton(
                  onPressed: _showAddCustomerDialog,
                  child: Text("Add new"),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: myBlack,
            ),
            Expanded(
              child: BlocBuilder<CustomerBloc, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CustomerLoadedState) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        constraints: BoxConstraints(minWidth: Get.width),
                        child: DataTable(
                          columnSpacing: 20,
                          columns: [
                            DataColumn(
                                label: Text(
                              'S.N.',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Phone',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Address',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                          ],
                          rows: List<DataRow>.generate(
                            state.customers.length,
                            (index) {
                              final customer = state.customers[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    customer.name,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    customer.phone,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    customer.email,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    customer.address,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('Failed to load customers'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
