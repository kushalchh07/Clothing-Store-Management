// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io' as io; // Alias for native file handling
import 'dart:html' as html; // Import for web image handling

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepstyle_management_system/Logic/Bloc/InventoryBloc/inventory_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'dart:typed_data';
import '../../constants/color/color.dart';
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
                  decoration: InputDecoration(labelText: 'Purchase Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Purchase price';
                    }
                    return null;
                  },
                  controller: _purPriceController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Selling Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Selling price';
                    }
                    return null;
                  },
                  controller: _sellingPriceController,
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
              title: Text("Inventory ",
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
                  dividerText: "Inventory",
                  desc: "",
                ),
                ElevatedButton(
                  onPressed: _showInventoryadd,
                  child: Text("Add new"),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: myBlack,
            ),
            Expanded(
              child: BlocBuilder<InventoryBloc, InventoryState>(
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
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          log('Edit ${inventory.productName}');
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              inventory.id);
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
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Yes'),
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
