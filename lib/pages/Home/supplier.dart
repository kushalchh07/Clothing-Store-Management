// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/supplierBloc/supplier_bloc.dart';

import '../../constants/color/color.dart';
import '../../utils/customwidgets/dividerText.dart';

class Supplier extends StatefulWidget {
  const Supplier({super.key});

  @override
  State<Supplier> createState() => _SupplierState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController _nameController = TextEditingController();
TextEditingController _addressController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _phoneController = TextEditingController();

class _SupplierState extends State<Supplier> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SupplierBloc>(context).add(SupplierLoadEvent());
  }

  void _clearControllers() {
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

  void _showDeleteConfirmationDialog(String customerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this Supplier?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Yes'),
              onPressed: () {
                // Perform delete operation here
                BlocProvider.of<SupplierBloc>(context)
                    .add(SupplierDeleteButtonTappedEvent(id: customerId));
                BlocProvider.of<SupplierBloc>(context).add(SupplierLoadEvent());
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
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

                  BlocProvider.of<SupplierBloc>(context).add(
                    SupplierAddButtonTappedEvent(
                      name: _nameController.text.trim(),
                      address: _addressController.text.trim(),
                      phone: _phoneController.text.trim(),
                      email: _emailController.text.trim(),
                      id: DateTime.now().toString(),
                    ),
                  );

                  log("Added to the bloc");
                  BlocProvider.of<SupplierBloc>(context)
                      .add(SupplierLoadEvent());
                  _clearControllers();
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
            )),
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Text("Suppliers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
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
                  dividerText: "Suppliers",
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
              child: BlocBuilder<SupplierBloc, SupplierState>(
                builder: (context, state) {
                  if (state is SupplierLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SupplierLoadedState) {
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Phone',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Address',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Actions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            state.suppliersList.length,
                            (index) {
                              final supplier = state.suppliersList[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    supplier.name,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    supplier.phone,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    supplier.email,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    supplier.address,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          // Handle edit action
                                          // You can navigate to an edit screen or show a dialog
                                          log('Edit ${supplier.name}');
                                        },
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                supplier.id);
                                          }),
                                    ],
                                  )),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('Failed to load Suppliers'));
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
