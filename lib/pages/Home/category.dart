// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/categoryBloc/category_bloc.dart';
import 'package:nepstyle_management_system/models/category_model.dart';
import 'package:nepstyle_management_system/pages/Home/customers.dart';

import '../../Logic/Bloc/reportBloc/report_bloc.dart';
import '../../constants/color/color.dart';
import '../../utils/customwidgets/dividerText.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

TextEditingController _categoryController = TextEditingController();
TextEditingController _quantityController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _CategoryState extends State<Category> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(CategoryLoadEvent());
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
                "Category",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, right: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColorJustLight,
                    shape: StadiumBorder(),
                  ),
                  onPressed: _showCategoryAddDialog,
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
                        "Add Category",
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
        child: Column(children: [
          Divider(
            thickness: 1,
            color: myBlack,
          ),
          Expanded(
            child: BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategoryDeletedActionState) {
                  Fluttertoast.showToast(
                    msg: 'Deleted Successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: whiteColor,
                  );
                } else if (state is CategoryAddedActionState) {
                  Fluttertoast.showToast(
                    msg: 'New category added Successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: whiteColor,
                  );
                } else if (state is CategoryErrorActionState) {
                  Fluttertoast.showToast(
                    msg: 'Something went wrong',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: whiteColor,
                  );
                } else if (state is CategoryEditedActionState) {
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
                if (state is CategoryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded) {
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
                              'Category',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Stock Quantity',
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
                          state.category.length,
                          (index) {
                            final category = state.category[index];
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  (index + 1).toString(),
                                  style: TextStyle(fontSize: 14),
                                )),
                                DataCell(Text(
                                  category.category,
                                  style: TextStyle(fontSize: 14),
                                )),
                                DataCell(Text(
                                  category.quantity,
                                  style: TextStyle(fontSize: 14),
                                )),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          editButtonColor,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.edit,
                                        color: whiteColor,
                                      ),
                                      onPressed: () =>
                                          _showEditDialog(category),
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
                                              category.id);
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
        ]),
      ),
    ));
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

  void _showCategoryAddDialog() {
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
                  const SizedBox(
                    height: 4,
                  ),
                  _buildTextFormField(_categoryController, "Category"),
                  const SizedBox(
                    height: 4,
                  ),
                  _buildTextFormField(_quantityController, "Quantity"),
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

                    BlocProvider.of<CategoryBloc>(context).add(
                      CategoryAddButtonTappedEvent(
                        categoryName: _categoryController.text.trim(),
                        quantity: _quantityController.text.trim(),
                        id: DateTime.now().toString(),
                      ),
                    );

                    BlocProvider.of<CategoryBloc>(context)
                        .add(CategoryLoadEvent());
                    BlocProvider.of<ReportBloc>(context).add(ReportLoadEvent());
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

  void _clearControllers() {
    _categoryController.clear();
    _quantityController.clear();
  }

  void _showDeleteConfirmationDialog(String categoryId) {
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
                BlocProvider.of<CategoryBloc>(context)
                    .add(CategoryDeleteButtonTappedEvent(id: categoryId));
                BlocProvider.of<CategoryBloc>(context).add(CategoryLoadEvent());
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(CategoryModel category) {
    _categoryController.text = category.category;
    _quantityController.text = category.quantity;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Category',
            style: TextStyle(fontFamily: 'inter', fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTextFormField(_categoryController, 'Category'),
                  const SizedBox(height: 8),
                  _buildTextFormField(_quantityController, 'Quantity'),
                  const SizedBox(height: 8),
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
                  BlocProvider.of<CategoryBloc>(context).add(
                      CategoryUpdateButtonTappedEvent(
                          categoryName: _categoryController.text.trim(),
                          quantity: _quantityController.text.trim(),
                          id: category.id));
                  BlocProvider.of<CategoryBloc>(context)
                      .add(CategoryLoadEvent());
                  BlocProvider.of<ReportBloc>(context).add(ReportLoadEvent());
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
