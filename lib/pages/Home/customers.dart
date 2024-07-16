// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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

  void _viewCustomerDetailsDialogBox(
    BuildContext context, {
    required String customerName,
    required String phoneNumber,
    required String emailAddress,
    required String address,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Customer Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  _buildCustomerDetailRow("Name", customerName),
                  _buildCustomerDetailRow("Phone Number", phoneNumber),
                  _buildCustomerDetailRow("Email Address", emailAddress),
                  _buildCustomerDetailRow("Address", address),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Text(
              "$label",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                'Add New Customer',
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontFamily: 'inter'),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      BlocProvider.of<CustomerBloc>(context).add(
                          CustomerUpdateButtonTappedEvent(
                              name: _nameController.text.trim(),
                              address: _addressController.text.trim(),
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              id: customer.id));
                      BlocProvider.of<CustomerBloc>(context)
                          .add(CustomerLoadEvent());
                      _clearControllers();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this customer?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
              expandedHeight: 80.0,
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
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColorJustLight,
                      shape: StadiumBorder(),
                    ),
                    onPressed: _showAddCustomerDialog,
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
                          "Add Customer",
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
        body: BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerDeletedActionState) {
              Fluttertoast.showToast(
                msg: 'Deleted Successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: whiteColor,
              );
            } else if (state is CustomerAddedActionState) {
              Fluttertoast.showToast(
                msg: 'Customer added Successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: whiteColor,
              );
            } else if (state is CustomerErrorActionState) {
              Fluttertoast.showToast(
                msg: 'Something went wrong',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: whiteColor,
              );
            } else if (state is CustomerEditedActionState) {
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
            if (state is CustomerLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CustomerLoadedState) {
              final customers = state.customers;
              if (customers.isEmpty) {
                return Center(child: Text('No customers available'));
              }
              return ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return GestureDetector(
                    onTap: () {
                      _viewCustomerDetailsDialogBox(
                        context,
                        customerName: customer.name,
                        phoneNumber: customer.phone,
                        emailAddress: customer.email,
                        address: customer.address,
                      );
                    },
                    child: Card(
                      elevation: 4.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(
                            customer.name[0],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(customer.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 5),
                                Flexible(child: Text(customer.address)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone, size: 16, color: Colors.grey),
                                SizedBox(width: 5),
                                Text(customer.phone),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Icon(Icons.email, size: 16, color: Colors.grey),
                                SizedBox(width: 5),
                                Flexible(child: Text(customer.email)),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                _showEditDialog(customer);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(customer.id);
                                BlocProvider.of<CustomerBloc>(context)
                                    .add(CustomerLoadEvent());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ),
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
}

OutlineInputBorder customFocusBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
      borderSide: BorderSide(color: primaryColor, width: 2));
}

TextStyle floatingLabelTextStyle() {
  return TextStyle(color: primaryColor, fontSize: 13);
}
