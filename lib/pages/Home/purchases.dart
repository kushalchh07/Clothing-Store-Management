// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/supplierBloc/supplier_bloc.dart';
import 'package:nepstyle_management_system/models/purchase_model.dart';
import 'package:nepstyle_management_system/pages/Home/customers.dart';

import '../../Logic/Bloc/purchaseBloc/purchase_bloc.dart';
import '../../constants/color/color.dart';
import '../../utils/customwidgets/dividerText.dart';

class Purchases extends StatefulWidget {
  const Purchases({super.key});

  @override
  State<Purchases> createState() => _PurchasesState();
}

TextEditingController _productNameController = TextEditingController();
TextEditingController _supplierNameController = TextEditingController();
TextEditingController _categoryController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
TextEditingController _purPriceController = TextEditingController();
TextEditingController _quantityController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
DateTime _selectedDate = DateTime.now();

class _PurchasesState extends State<Purchases> {
  void _clearControllers() {
    _productNameController.clear();
    _categoryController.clear();
    _descriptionController.clear();
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
                BlocProvider.of<PurchaseBloc>(context)
                    .add(PurchaseDeleteButtonTappedEvent(id: id));
                BlocProvider.of<PurchaseBloc>(context).add(PurchaseLoadEvent());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditPurchaseDialog(PurchaseModel purchase) {
    _productNameController.text = purchase.productName;
    _categoryController.text = purchase.category;
    _descriptionController.text = purchase.description;
    _purPriceController.text = purchase.perPiecePrice.toString();
    _quantityController.text = purchase.quantity.toString();
    _supplierNameController.text = purchase.supplier;
    _selectedDate = DateTime.parse(purchase.date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Purchase'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildTextFormField(_productNameController, 'Product Name'),
                const SizedBox(height: 10),
                _buildTextFormField(_categoryController, 'Category'),
                const SizedBox(height: 10),
                _buildTextFormField(_quantityController, 'Quantity'),
                const SizedBox(height: 10),
                _buildTextFormField(_purPriceController, 'Per Piece Price'),
                const SizedBox(height: 10),
                _buildTextFormField(_supplierNameController, 'Supplier Name'),
                const SizedBox(height: 10),
                _buildTextFormField(_descriptionController, 'Description'),
                const SizedBox(height: 10),
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
                  log('Product Name: ${_productNameController.text.trim()}');
                  log('Category: ${_categoryController.text.trim()}');
                  log('Quantity: ${_quantityController.text.trim()}');
                  log('Per Piece Price: ${_purPriceController.text.trim()}');
                  log('Supplier Name: ${_supplierNameController.text.trim()}');
                  log('Description: ${_descriptionController.text.trim()}');
                  log('Date: $_selectedDate');

                  BlocProvider.of<PurchaseBloc>(context).add(
                    PurchaseUpdateButtonTappedEvent(
                      id: purchase.id,
                      productName: _productNameController.text.trim(),
                      category: _categoryController.text.trim(),
                      description: _descriptionController.text.trim(),
                      purPrice: double.parse(_purPriceController.text.trim()),
                      quantity: int.parse(_quantityController.text.trim()),
                      supplierName: _supplierNameController.text.trim(),
                      date: _selectedDate,
                    ),
                  );
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(PurchaseLoadEvent());
                  log("Updated in the bloc");

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
          return 'Please enter the $hint';
        }
        return null;
      },
      controller: controller,
    );
  }

  void _showPurchaseAdd() {
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
                      labelText: 'Category',
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
                TextFormField(
                  decoration: InputDecoration(
                      floatingLabelStyle: floatingLabelTextStyle(),
                      focusedBorder: customFocusBorder(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: primaryColor, width: 2)),
                      labelStyle: TextStyle(color: greyColor, fontSize: 13),
                      labelText: 'Per Piece Price',
                      hintText: 'Per Piece Price'),
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
                      labelText: 'Supplier Name',
                      hintText: 'Supplier Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Supplier name';
                    }
                    return null;
                  },
                  controller: _supplierNameController,
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
                      labelText: 'Description',
                      hintText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Description';
                    }
                    return null;
                  },
                  controller: _descriptionController,
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  BlocProvider.of<PurchaseBloc>(context)
                      .add(PurchaseAddButtonTappedEvent(
                    productName: _productNameController.text.trim(),
                    category: _categoryController.text.trim(),
                    description: _descriptionController.text.trim(),
                    purPrice: double.parse(_purPriceController.text.trim()),
                    quantity: int.parse(_quantityController.text.trim()),
                    supplierName: _supplierNameController.text.trim(),
                    date: _selectedDate,
                    id: DateTime.now().toString(),
                  ));
                  log("Added to the bloc");
                  BlocProvider.of<PurchaseBloc>(context)
                      .add(PurchaseLoadEvent());
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
    BlocProvider.of<PurchaseBloc>(context).add(PurchaseLoadEvent());
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
              title: Text("Purchases",
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
                  dividerText: "Purchases",
                  desc: "",
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: StadiumBorder(),
                  ),
                  onPressed: _showPurchaseAdd,
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
                        "Add Purchases",
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
              child: BlocBuilder<PurchaseBloc, PurchaseState>(
                builder: (context, state) {
                  if (state is PurchaseLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is PurchaseLoadSuccessState) {
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
                                'Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Supplier',
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
                                'Quantity',
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
                            state.purchases.length,
                            (index) {
                              final purchase = state.purchases[index];

                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    purchase.date,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    purchase.supplier,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    purchase.productName,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    purchase.quantity.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    purchase.perPiecePrice.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    purchase.totalAmount.toString(),
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
                                          _showEditPurchaseDialog(purchase);
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
                                                purchase.id);
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
