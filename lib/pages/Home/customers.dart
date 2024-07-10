// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/customersBloc/customer_bloc.dart';

import 'package:nepstyle_management_system/utils/customwidgets/dividerText.dart';
import '../../constants/color/color.dart';
import '../../models/customerModel.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

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
        return Container(
          width: Get.width * 0.6,
          height: Get.height * 0.7,
          child: AlertDialog(
            title: Text(
              'Add New Customer',
              style: TextStyle(fontFamily: 'inter', fontSize: 16),
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    cursorColor: primaryColor,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        floatingLabelStyle: floatingLabelTextStyle(),
                        focusedBorder: customFocusBorder(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: primaryColor, width: 2)),
                        labelStyle: TextStyle(color: greyColor, fontSize: 13),
                        hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                    controller: _nameController,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        floatingLabelStyle: floatingLabelTextStyle(),
                        focusedBorder: customFocusBorder(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: primaryColor, width: 2)),
                        labelStyle: TextStyle(color: greyColor, fontSize: 13),
                        hintText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                    controller: _addressController,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        floatingLabelStyle: floatingLabelTextStyle(),
                        focusedBorder: customFocusBorder(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: primaryColor, width: 2)),
                        labelStyle: TextStyle(color: greyColor, fontSize: 13),
                        hintText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                    controller: _phoneController,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        floatingLabelStyle: floatingLabelTextStyle(),
                        focusedBorder: customFocusBorder(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: primaryColor, width: 2)),
                        labelStyle: TextStyle(color: greyColor, fontSize: 13),
                        hintText: 'Email Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email address';
                      }
                      return null;
                    },
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontFamily: 'inter'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontFamily: 'inter'),
                ),
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

                    log("Added to the bloc");
                    BlocProvider.of<CustomerBloc>(context)
                        .add(CustomerLoadEvent());
                    _clearControllers();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(Customer customer) {
    _nameController.text = customer.name;
    _addressController.text = customer.address;
    _phoneController.text = customer.phone;
    _emailController.text = customer.email;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Customer',
            style: TextStyle(fontFamily: 'inter', fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTextFormField(_nameController, 'Name'),
                  const SizedBox(height: 8),
                  _buildTextFormField(_addressController, 'Address'),
                  const SizedBox(height: 8),
                  _buildTextFormField(_phoneController, 'Phone Number'),
                  const SizedBox(height: 8),
                  _buildTextFormField(_emailController, 'Email Address'),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: 'inter'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: 'inter'),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

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
          content: Text('Are you sure you want to delete this customer?'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Text(
                'No',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: 'inter'),
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
                    color: Colors.white, fontSize: 16, fontFamily: 'inter'),
              ),
              onPressed: () {
                // Perform delete operation here
                BlocProvider.of<CustomerBloc>(context)
                    .add(CustomerDeleteButtonTappedEvent(id: customerId));
                BlocProvider.of<CustomerBloc>(context).add(CustomerLoadEvent());
                Navigator.of(context).pop(); // Close the dialog
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
    return Scaffold(
      body: NestedScrollView(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myButtonColor,
                      shape: StadiumBorder(),
                    ),
                    onPressed: _showAddCustomerDialog,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.add_circle_outline_outlined,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Add new",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'inter'),
                        ),
                      ],
                    ),
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
                            columnSpacing: 10,
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
                                          onPressed: () =>
                                              _showEditDialog(customer),
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
                                                  customer.id);
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
                      return Center(child: Text('Failed to load customers'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextFormField(
    TextEditingController controller,
    String hint,
  ) {
    return TextFormField(
      decoration: InputDecoration(
          floatingLabelStyle: floatingLabelTextStyle(),
          focusedBorder: customFocusBorder(),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: primaryColor, width: 2)),
          labelStyle: TextStyle(color: greyColor, fontSize: 13),
          labelText: hint,
          hintText: hint),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the  ${hint}';
        }
        return null;
      },
      controller: controller,
    );
  }
}

OutlineInputBorder customFocusBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
      borderSide: BorderSide(color: primaryColor, width: 2));
}

TextStyle floatingLabelTextStyle() {
  return TextStyle(color: primaryColor, fontSize: 13);
}
