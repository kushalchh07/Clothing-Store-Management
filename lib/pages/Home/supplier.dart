// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/supplierBloc/supplier_bloc.dart';
import 'package:nepstyle_management_system/models/supplier_model.dart';
import 'package:nepstyle_management_system/pages/Home/customers.dart';

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

  void _showEditSupplierDialog(SupplierModel supplier) {
    _nameController.text = supplier.name;
    _addressController.text = supplier.address;
    _emailController.text = supplier.email;
    _phoneController.text = supplier.phone;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Supplier'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTextFormField(_nameController, 'Name'),
                const SizedBox(height: 10),
                _buildTextFormField(_addressController, 'Address'),
                const SizedBox(height: 10),
                _buildTextFormField(_phoneController, 'Phone Number'),
                const SizedBox(height: 10),
                _buildTextFormField(_emailController, 'Email Address'),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(redColor)),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _clearControllers();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: greenColor),
              child: Text(
                'Save',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  log('Name: ${_nameController.text.trim()}');
                  log('Address: ${_addressController.text}');
                  log('Phone Number: ${_phoneController.text}');
                  log('Email Address: ${_emailController.text}');

                  BlocProvider.of<SupplierBloc>(context).add(
                    SupplierUpdateButtonTappedEvent(
                      id: supplier.id,
                      name: _nameController.text.trim(),
                      address: _addressController.text.trim(),
                      phone: _phoneController.text.trim(),
                      email: _emailController.text.trim(),
                    ),
                  );

                  log("Updated in the bloc");
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

  Widget _buildTextFormField(
      TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
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
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(greenColor)),
              child: Text(
                'No',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                'Yes',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
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

  void _showAddCSupplierDialog() {
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
                _buildTextFormField(_nameController, 'Name'),
                const SizedBox(height: 10),
                _buildTextFormField(_addressController, 'Address'),
                const SizedBox(height: 10),
                _buildTextFormField(_phoneController, 'Phone Number'),
                const SizedBox(height: 10),
                _buildTextFormField(_emailController, 'Email Address'),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(redColor)),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _clearControllers();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: greenColor),
              child: Text(
                'Save',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
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
              title: Text("Suppliers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColorJustLight,
                    shape: StadiumBorder(),
                  ),
                  onPressed: _showAddCSupplierDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add_circle_outline_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Add Supplier",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'inter'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
        child: Column(
          children: [
            Divider(
              thickness: 1,
              color: myBlack,
            ),
            Expanded(
              child: BlocConsumer<SupplierBloc, SupplierState>(
                listener: (context, state) {
                  if (state is SupplierDeletedActionState) {
                    Fluttertoast.showToast(
                      msg: 'Deleted Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: whiteColor,
                    );
                  } else if (state is SupplierAddedActionState) {
                    Fluttertoast.showToast(
                      msg: 'Supplier Added Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: whiteColor,
                    );
                  } else if (state is SupplierErrorActionState) {
                    Fluttertoast.showToast(
                      msg: 'Something went wrong',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: whiteColor,
                    );
                  } else if (state is SupplierEditedActionState) {
                    Fluttertoast.showToast(
                      msg: 'Edited Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: whiteColor,
                    );
                  }
                },
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
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                            editButtonColor,
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.edit,
                                          color: whiteColor,
                                        ),
                                        onPressed: () {
                                          // Handle edit action
                                          // You can navigate to an edit screen or show a dialog
                                          _showEditSupplierDialog(supplier);
                                        },
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              redColor,
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.delete,
                                            color: whiteColor,
                                          ),
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
