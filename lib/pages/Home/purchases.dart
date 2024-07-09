// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/supplierBloc/supplier_bloc.dart';

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
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Yes'),
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

  void _showpurchaseadd() {
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
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Product name';
                    }
                    return null;
                  },
                  controller: _productNameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Category';
                    }
                    return null;
                  },
                  controller: _categoryController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Quantity';
                    }
                    return null;
                  },
                  controller: _quantityController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Per Piece Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Purchase price';
                    }
                    return null;
                  },
                  controller: _purPriceController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Supplier Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Selling price';
                    }
                    return null;
                  },
                  controller: _supplierNameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Description';
                    }
                    return null;
                  },
                  controller: _descriptionController,
                ),
                SizedBox(
                  height: 4,
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
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
                  onPressed: _showpurchaseadd,
                  child: Text("Add new"),
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
                                    purchase.date.toString(),
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
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          log('Edit ${purchase.productName}');
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              purchase.id);
                                        },
                                      ),
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
