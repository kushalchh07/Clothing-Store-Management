// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously, unused_local_variable

import 'dart:developer';
import 'dart:io' as io; // Alias for native file handling
import 'dart:html' as html; // Import for web image handling
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:nepstyle_management_system/Logic/Bloc/categoryBloc/category_bloc.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
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
CollectionReference _reference =
    FirebaseFirestore.instance.collection('products');

enum UploadType {
  string,
  file,
  clear,
}

class _InventoryScreenState extends State<InventoryScreen> {
  dynamic _imageFile;
  String? selectedValue; // Holds the selected dropdown value

  String? _imageUrl;
  String defaultImageUrl =
      'https://cdn.pixabay.com/photo/2016/03/23/15/00/ice-cream-1274894_1280.jpg';
  String selectedFile = '';
  XFile? file;
  Uint8List? selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];
  List<firabase_storage.UploadTask> _uploadTasks = [];
  pickImage() async {
    html.File? imageFile = (await ImagePickerWeb.getMultiImagesAsFile())?[0];
    log(imageFile.toString());
    setState(() {
      _imageFile = imageFile;
    });
  }

  // Future<void> _selectFile(bool imageFrom) async {
  //   FilePickerResult? fileResult =
  //       await FilePicker.platform.pickFiles(allowMultiple: true);

  //   if (fileResult != null) {
  //     selectedFile = fileResult.files.first.name;
  //     fileResult.files.forEach((element) {
  //       setState(() {
  //         if (element.bytes != null) {
  //           pickedImagesInBytes.add(element.bytes!);
  //         } //selectedImageInBytes = fileResult.files.first.bytes;
  //         // imageCounts += 1;
  //       });
  //     });
  //   }
  //   print(selectedFile);
  // }
  Future<void> _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (fileResult != null) {
      setState(() {
        selectedFile = fileResult.files.first.name;
        pickedImagesInBytes = fileResult.files
            .where((element) => element.bytes != null)
            .map((element) => element.bytes!)
            .toList();
      });
    }
    print(selectedFile);
  }

  Future<String> _uploadFile(String selectedFile) async {
    log(selectedFile);
    String imageUrl = '';
    try {
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('product')
          .child('/' + selectedFile);
      print("ref: $ref");
      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/jpeg');

      uploadTask = ref.putFile(File(file!.path));
      log(uploadTask.toString());
      uploadTask = ref.putData(selectedImageInBytes!, metadata);
      await uploadTask.whenComplete(() => {});
      imageUrl = await ref.getDownloadURL();
      log(imageUrl);
    } catch (e) {
      print(e);
    }
    return imageUrl;
  }

  // uploadImage(XFile file) async {
  //   try {
  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child('flutter-tests')
  //         .child('/some-image.jpg');
  //     final metadata = SettableMetadata(
  //       contentType: 'image/jpeg',
  //       customMetadata: {'picked-file-path': file.path},
  //     );
  //     if (kIsWeb) {
  //       uploadTask = ref.putData(await file.readAsBytes(), metadata);
  //     } else {
  //       uploadTask = ref.putFile(io.File(file.path), metadata);
  //     }
  //     return Future.value(uploadTask);
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

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
                _buildTextFormField(_productNameController, 'Product Name'),

                const SizedBox(
                  height: 10,
                ),

                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      //
                      return DropdownButtonFormField<String>(
                        value: selectedValue,
                        hint: const Text('Choose an Category'),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        items: state.category.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.category,
                            child: Text(item.category),
                          );
                        }).toList(),
                      );
                    } else {
                      return Container(
                        child: Text("Loading..."),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(
                  height: 10,
                ),
                _buildTextFormField(_quantityController, 'Quantity'),

                const SizedBox(
                  height: 10,
                ),
                _buildTextFormField(_purPriceController, 'Purchase Price'),

                const SizedBox(
                  height: 10,
                ),
                _buildTextFormField(_sellingPriceController, 'Selling Price'),

                const SizedBox(
                  height: 10,
                ),
                _buildTextFormField(_descriptionController, 'Description'),

                SizedBox(
                  height: 4,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => _selectFile(true),
                  child: Text('Pick Image'),
                ),
                // if (selectedFile != null)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                //     child: kIsWeb
                //         ? Image.network((selectedFile as html.File).name,
                //             height: 150)
                //         : Image.file(selectedFile as io.File, height: 150),
                //   ),
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

                  print(selectedFile);
                  _imageUrl = await _uploadFile(selectedFile);
                  log(_imageUrl.toString());
                  BlocProvider.of<InventoryBloc>(context)
                      .add(InventoryAddButtonTappedEvent(
                    name: _productNameController.text.trim(),
                    category: selectedValue.toString(),
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

  void viewInventoryDetailsDialogBox(
    BuildContext context, {
    required String productName,
    required String productImage,
    required String category,
    required int quantity,
    required double purchasePrice,
    required double sellingPrice,
    required String description,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: Get.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Inventory Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      _buildInventoryDetailRow("Product Name", productName),
                      SizedBox(height: 10),
                      _buildInventoryDetailRow("Category", category),
                      SizedBox(height: 10),
                      _buildInventoryDetailRow("Quantity", quantity.toString()),
                      SizedBox(height: 10),
                      _buildInventoryDetailRow("Purchase Price",
                          "Rs ${purchasePrice.toStringAsFixed(2)}"),
                      SizedBox(height: 10),
                      _buildInventoryDetailRow("Selling Price",
                          "Rs ${sellingPrice.toStringAsFixed(2)}"),
                      SizedBox(height: 10),
                      _buildInventoryDetailRow("Description", description),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            productImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInventoryDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
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
                    onPressed: pickImage,
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // if (_imageFile != null) {
                  //   _imageUrl = await uploadImage(_imageFile);
                  // } else {
                  //   _imageUrl = inventory.productImage;
                  // }

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
    BlocProvider.of<CategoryBloc>(context).add(CategoryLoadEvent());
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
                padding: const EdgeInsets.only(top: 25.0, right: 20),
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
                    Fluttertoast.showToast(
                      msg: 'Deleted Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: whiteColor,
                    );
                  } else if (state is InventoryAddedActionState) {
                    Fluttertoast.showToast(
                      msg: 'Product Added Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: whiteColor,
                    );
                  } else if (state is InventoryErrorActionState) {
                    Fluttertoast.showToast(
                      msg: 'Something went wrong',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: whiteColor,
                    );
                  } else if (state is InventoryEditedActionState) {
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
                                    "Rs ${inventory.purchasePrice.toString()}",
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    "Rs ${inventory.sellingPrice.toString()}",
                                    style: TextStyle(fontSize: 14),
                                  )),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              viewdetailsColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            viewInventoryDetailsDialogBox(
                                                context,
                                                productName:
                                                    inventory.productName,
                                                productImage:
                                                    inventory.productImage,
                                                category: inventory.category,
                                                quantity: inventory.quantity,
                                                purchasePrice:
                                                    inventory.purchasePrice,
                                                sellingPrice:
                                                    inventory.sellingPrice,
                                                description:
                                                    inventory.description);
                                          },
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
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    BlocProvider.of<InventoryBloc>(context)
                        .add(InventoryLoadEvent());
                    return Center(child: CupertinoActivityIndicator());
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
