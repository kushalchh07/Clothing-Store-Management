// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/salesBloc/sales_bloc.dart';
import 'package:nepstyle_management_system/pages/Home/customers.dart';

import '../../constants/color/color.dart';
import '../../models/sales_model.dart';
import '../../utils/customwidgets/dividerText.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

TextEditingController _customerNameController = TextEditingController();
TextEditingController _productNameController = TextEditingController();

TextEditingController _salesPriceController = TextEditingController();
TextEditingController _quantityController = TextEditingController();
DateTime _selectedDate = DateTime.now();

class _SalesState extends State<Sales> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SalesBloc>(context).add(SalesLoadEvent());
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
              title: Text("Sales",
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
                  onPressed: _showSalesAddDialog,
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
                        "Add Sales",
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
              child: BlocBuilder<SalesBloc, SalesState>(
                builder: (context, state) {
                  if (state is SalesLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SalesLoadSuccessState) {
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
                                'Customer Name',
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
                                'Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Sales Price',
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
                                'Actions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            state.sales.length,
                            (index) {
                              final sales = state.sales[index];
                              log(sales.nameCustomer);
                              log(sales.nameProduct);
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    sales.nameCustomer,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    sales.nameProduct,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    sales.date,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    sales.perPiecePrice,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    sales.quantity,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    sales.totalAmount,
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
                                          _showSalesEditDialog(sales);
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
                                                sales.id);
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
    );
  }

  void _showDeleteConfirmationDialog(String salesId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this customer?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: greenColor,
              ),
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
                BlocProvider.of<SalesBloc>(context)
                    .add(SalesDeleteButtonTappedEvent(id: salesId));
                BlocProvider.of<SalesBloc>(context).add(SalesLoadEvent());
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showSalesAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Sales'),
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
                        borderSide: BorderSide(color: primaryColor, width: 2)),
                    labelStyle: TextStyle(color: greyColor, fontSize: 13),
                    labelText: 'Customer Name',
                    hintText: 'Customer Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                  controller: _customerNameController,
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
                      labelText: 'Product Name',
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
                      labelText: 'Selling Price',
                      hintText: 'Selling Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the selling Price';
                    }
                    return null;
                  },
                  controller: _salesPriceController,
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
                      labelText: 'Quantity',
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  BlocProvider.of<SalesBloc>(context).add(
                    SalesAddButtonTappedEvent(
                      id: DateTime.now().toString(),
                      customerName: _customerNameController.text,
                      productName: _productNameController.text,
                      salesPrice: double.parse(_salesPriceController.text),
                      quantity: int.parse(_quantityController.text),
                      date: _selectedDate,
                    ),
                  );

                  log("Added to the bloc");
                  BlocProvider.of<SalesBloc>(context).add(SalesLoadEvent());
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
    _productNameController.clear();
    _quantityController.clear();
    _customerNameController.clear();
    _salesPriceController.clear();
  }

  void _showSalesEditDialog(SalesModel sales) {
    _customerNameController.text = sales.nameCustomer;
    _productNameController.text = sales.nameProduct;
    _salesPriceController.text = sales.perPiecePrice;
    _quantityController.text = sales.quantity;
    _selectedDate = DateTime.parse(sales.date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Sales'),
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
                        borderSide: BorderSide(color: primaryColor, width: 2)),
                    labelStyle: TextStyle(color: greyColor, fontSize: 13),
                    labelText: 'Customer Name',
                    hintText: 'Customer Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                  controller: _customerNameController,
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
                      labelText: 'Product Name',
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
                      labelText: 'Selling Price',
                      hintText: 'Selling Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the selling Price';
                    }
                    return null;
                  },
                  controller: _salesPriceController,
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
                      labelText: 'Quantity',
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  BlocProvider.of<SalesBloc>(context).add(
                    SalesUpdateButtonTappedEvent(
                      id: sales.id,
                      customerName: _customerNameController.text,
                      productName: _productNameController.text,
                      salesPrice: double.parse(_salesPriceController.text),
                      quantity: int.parse(_quantityController.text),
                      date: _selectedDate,
                    ),
                  );

                  log("Updated in the bloc");
                  BlocProvider.of<SalesBloc>(context).add(SalesLoadEvent());
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
}
