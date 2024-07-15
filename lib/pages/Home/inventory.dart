// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:developer';
import 'dart:io' as io; // Alias for native file handling
import 'dart:html' as html; // Import for web image handling

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepstyle_management_system/Logic/Bloc/InventoryBloc/inventory_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:nepstyle_management_system/pages/Home/customers.dart';
import 'dart:typed_data';
import '../../constants/color/color.dart';
import '../../models/inventory_model.dart';
import '../../utils/customwidgets/dividerText.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

TextEditingController _productNameController = TextEditingController();
TextEditingController _categoryController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
TextEditingController _purPriceController = TextEditingController();
TextEditingController _sellingPriceController = TextEditingController();
TextEditingController _quantityController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _InventoryScreenState extends State<InventoryScreen> {
  dynamic _imageFile;
  String? _imageUrl;

  // Needed for handling file bytes

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isNotEmpty) {
          final file = files[0];
          setState(() {
            _imageFile = file; // Store the selected file
          });
        }
      });
    } else {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = io.File(pickedFile.path);
        });
      }
    }
  }

  Future<String> uploadImage(dynamic imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('products/$fileName');

      if (kIsWeb) {
        // Handle web image upload
        final reader = html.FileReader();
        reader.readAsArrayBuffer(imageFile);
        await reader.onLoadEnd.first;
        final data = reader.result as Uint8List;

        final uploadTask = storageRef.putData(
          data,
          SettableMetadata(contentType: imageFile.type), // Set content type
        );

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        // Handle native image upload
        final uploadTask = storageRef.putFile(imageFile as io.File);

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  void _showInventoryadd() {
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
                      hintText: 'Selling Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Selling price';
                    }
                    return null;
                  },
                  controller: _sellingPriceController,
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
                      hintText: 'Description'),
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                if (_imageFile != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: kIsWeb
                        ? Image.network((_imageFile as html.File).name,
                            height: 150)
                        : Image.file(_imageFile as io.File, height: 150),
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
                  _imageUrl = await uploadImage(_imageFile);
                  log(_imageUrl.toString());
                  BlocProvider.of<InventoryBloc>(context)
                      .add(InventoryAddButtonTappedEvent(
                    name: _productNameController.text.trim(),
                    category: _categoryController.text.trim(),
                    description: _descriptionController.text.trim(),
                    purPrice: _purPriceController.text.trim(),
                    sellingPrice: _sellingPriceController.text.trim(),
                    quantity: _quantityController.text.trim(),
                    productImage: _imageUrl.toString(),
                    id: DateTime.now().toString(),
                  ));
                  log("Added to the bloc");
                  BlocProvider.of<InventoryBloc>(context)
                      .add(InventoryLoadEvent());
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

  void _showInventoryEditDialog(Inventory inventory) {
    _productNameController.text = inventory.productName;
    _categoryController.text = inventory.category;
    _descriptionController.text = inventory.description;
    _purPriceController.text = inventory.purchasePrice.toString();
    _sellingPriceController.text = inventory.sellingPrice.toString();
    _quantityController.text = inventory.quantity.toString();
    _imageFile = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Product',
            style: TextStyle(fontFamily: 'inter', fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Form(
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
                  _buildTextFormField(_purPriceController, 'Purchase Price'),
                  const SizedBox(height: 10),
                  _buildTextFormField(_sellingPriceController, 'Selling Price'),
                  const SizedBox(height: 10),
                  _buildTextFormField(_descriptionController, 'Description'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  if (_imageFile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: kIsWeb
                          ? Image.network((_imageFile as html.File).name,
                              height: 150)
                          : Image.file(_imageFile as io.File, height: 150),
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
                  if (_imageFile != null) {
                    _imageUrl = await uploadImage(_imageFile);
                  } else {
                    _imageUrl = inventory.productImage;
                  }

                  BlocProvider.of<InventoryBloc>(context).add(
                    InventoryUpdateButtonTappedEvent(
                      id: inventory.id,
                      name: _productNameController.text.trim(),
                      category: _categoryController.text.trim(),
                      description: _descriptionController.text.trim(),
                      purPrice: _purPriceController.text.trim(),
                      sellingPrice: _sellingPriceController.text.trim(),
                      quantity: _quantityController.text.trim(),
                      productImage: _imageUrl!,
                    ),
                  );
                  log("Updated in the bloc");
                  BlocProvider.of<InventoryBloc>(context)
                      .add(InventoryLoadEvent());
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
    super.initState();
    BlocProvider.of<InventoryBloc>(context).add(InventoryLoadEvent());
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
              title: Text("Inventory ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
            ),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(top: 25.0,right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColorJustLight,
                      shape: StadiumBorder(),
                    ),
                    onPressed: _showInventoryadd,
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
                          "Add Product",
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
              child: BlocConsumer<InventoryBloc, InventoryState>(
                listener: (context, state) {
                    if (state is InventoryDeletedActionState) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Deleted Successfully'),
                    //     backgroundColor: Colors.red,
                    //   ),
                    // );
                    Fluttertoast.showToast(
                      msg: 'Deleted Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: whiteColor,
                    );
                  } else if (state is InventoryAddedActionState) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Order Added Successfully'),
                    //     backgroundColor: Colors.green,
                    //   ),
                    // );
                     Fluttertoast.showToast(
                      msg: 'Product Added Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: whiteColor,
                    );
                  } else if (state is InventoryErrorActionState) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Something went wrong'),
                    //     backgroundColor: Colors.red,
                    //   ),
                    // );
                     Fluttertoast.showToast(
                      msg: 'Something went wrong',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: whiteColor,
                    );
                  } else if (state is InventoryEditedActionState) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Edited Successfully'),
                    //     backgroundColor: Colors.green,
                    //   ),
                    // );
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
                  if (state is InventoryLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is InventoryLoadedState) {
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
                                'Product Image',
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
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Purchase price',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Selling price',
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
                            state.inventory.length,
                            (index) {
                              final inventory = state.inventory[index];
                              log(inventory.productImage);
                              log(inventory.category);
                              log(inventory.quantity.toString());
                              log(inventory.purchasePrice.toString());
                              log(inventory.sellingPrice.toString());
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    (index + 1).toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    inventory.productName,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(kIsWeb
                                      ? Image.network(
                                          inventory.productImage,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return Icon(Icons.error);
                                          },
                                        )
                                      : Image.file(
                                          io.File(inventory.productImage),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )),
                                  DataCell(Text(
                                    inventory.category,
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    inventory.quantity.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    inventory.purchasePrice.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    inventory.sellingPrice.toString(),
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Row(
                                    children: [ IconButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              viewdetailsColor,
                                            ),
                                          ),
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.visibility,
                                            color: Colors.white,
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
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
                                          _showInventoryEditDialog(inventory);
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
                                                inventory.id);
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
                    return Center(child: Text('Failed to load inventory'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearControllers() {
    _productNameController.clear();
    _categoryController.clear();
    _descriptionController.clear();
    _purPriceController.clear();
    _sellingPriceController.clear();
    _quantityController.clear();
    setState(() {
      _imageFile = null;
      _imageUrl = null;
    });
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
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
                BlocProvider.of<InventoryBloc>(context)
                    .add(InventoryDeleteButtonTappedEvent(id: id));
                BlocProvider.of<InventoryBloc>(context)
                    .add(InventoryLoadEvent());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
