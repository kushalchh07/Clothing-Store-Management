// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/orderBloc/order_bloc.dart';
import 'package:nepstyle_management_system/models/order_model.dart';
import 'package:nepstyle_management_system/pages/Home/customers.dart';

import '../../constants/color/color.dart';
import '../../utils/customwidgets/dividerText.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _supplierNameController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _purPriceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String generateOrderCode() {
    var random = Random();
    int randomNumber =
        1000 + random.nextInt(9000); // Generates a number between 1000 and 9999
    return randomNumber.toString();
  }

  void _clearControllers() {
    _productNameController.clear();
    _categoryController.clear();
    _customerNameController.clear();
    _purPriceController.clear();
    // _sellingPriceController.clear();
    _quantityController.clear();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this detail?'),
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
                BlocProvider.of<OrderBloc>(context)
                    .add(OrderDeleteButtonTappedEvent(id: id));
                BlocProvider.of<OrderBloc>(context).add(OrderLoadEvent());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showOrderAdd() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Product'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      floatingLabelStyle: floatingLabelTextStyle(),
                      focusedBorder: customFocusBorder(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: primaryColor, width: 2)),
                      labelStyle: TextStyle(color: greyColor, fontSize: 13),
                      hintText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Product name';
                    }
                    return null;
                  },
                  controller: _productNameController,
                ),
                const SizedBox(
                  height: 10,
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
                      hintText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Category';
                    }
                    return null;
                  },
                  controller: _categoryController,
                ),
                const SizedBox(
                  height: 10,
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
                      hintText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Quantity';
                    }
                    return null;
                  },
                  controller: _quantityController,
                ),
                const SizedBox(
                  height: 10,
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
                      hintText: 'Purchase Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Purchase price';
                    }
                    return null;
                  },
                  controller: _purPriceController,
                ),
                const SizedBox(
                  height: 10,
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
                      hintText: 'Customer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Customer name';
                    }
                    return null;
                  },
                  controller: _customerNameController,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 40,
                  width: 180,
                  child: TextButton(
                    style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(myButtonColor),
                    ),
                    onPressed: () => _selectDate(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        Text(
                          'Select Date',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(redColor),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: greenColor),
              child: Text(
                'Save',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  BlocProvider.of<OrderBloc>(context)
                      .add(OrderAddButtonTappedEvent(
                    productName: _productNameController.text.trim(),
                    category: _categoryController.text.trim(),
                    orderCode: generateOrderCode(),
                    customerName: _customerNameController.text.trim(),
                    orderPrice: double.parse(_purPriceController.text.trim()),
                    quantity: int.parse(_quantityController.text.trim()),
                    date: _selectedDate,
                    id: DateTime.now().toString(),
                  ));
                  // log("Added to the bloc");
                  BlocProvider.of<OrderBloc>(context).add(OrderLoadEvent());
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

  void _showEditOrderDialog(OrderModel order) {
    _productNameController.text = order.productName;
    _categoryController.text = order.category;
    _customerNameController.text = order.customerName;
    _purPriceController.text = order.perPiecePrice.toString();
    _quantityController.text = order.quantity.toString();
    _selectedDate = DateTime.parse(order.date);
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Order',
            style: TextStyle(fontFamily: 'inter', fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTextFormField(_productNameController, 'Name'),
                  const SizedBox(height: 10),
                  _buildTextFormField(_categoryController, 'Category'),
                  const SizedBox(height: 10),
                  _buildTextFormField(_quantityController, 'Quantity'),
                  const SizedBox(height: 10),
                  _buildTextFormField(_purPriceController, 'Purchase Price'),
                  const SizedBox(height: 10),
                  _buildTextFormField(_customerNameController, 'Customer Name'),
                  const SizedBox(height: 12),
                  Container(
                    height: 40,
                    width: 180,
                    child: TextButton(
                      style: ButtonStyle(
                        iconColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(myButtonColor),
                      ),
                      onPressed: () => _selectDate(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.calendar_month_outlined),
                          Text(
                            'Select Date',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: greenColor),
              child: Text(
                'Save',
                style: TextStyle(
                    color: whiteColor, fontFamily: 'inter', fontSize: 16),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  BlocProvider.of<OrderBloc>(context)
                      .add(OrderUpdateButtonTappedEvent(
                    id: order.id,
                    productName: _productNameController.text.trim(),
                    category: _categoryController.text.trim(),
                    orderCode: order.orderCode,
                    customerName: _customerNameController.text.trim(),
                    orderPrice: double.parse(_purPriceController.text.trim()),
                    quantity: int.parse(_quantityController.text.trim()),
                    date: _selectedDate,
                  ));
                  BlocProvider.of<OrderBloc>(context).add(OrderLoadEvent());
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
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<OrderBloc>(context).add(OrderLoadEvent());
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dividerText(
                  context: context,
                  dividerText: "Orders",
                  desc: "",
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myButtonColor,
                    shape: StadiumBorder(),
                  ),
                  onPressed: _showOrderAdd,
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
                        "Place Order",
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
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is OrderLoadSuccessState) {
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
                                'Product Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Order Code',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Per Piece Price',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Customer Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Date',
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
                            DataColumn(
                              label: Text(
                                'Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            state.orders.length,
                            (index) {
                              final orders = state.orders[index];

                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.productName,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.category,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.orderCode,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.perPiecePrice.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.quantity,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.totalAmount.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.customerName,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    orders.date,
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
                                          _showEditOrderDialog(orders);
                                          // Handle edit action
                                          // You can navigate to an edit screen or show a dialog
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
                                                orders.id);
                                          }),
                                    ],
                                  )),
                                  DataCell(
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text('View More',
                                            style: TextStyle(
                                                fontSize: 14, color: myWhite)),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ))),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('Failed to load purchase'));
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
