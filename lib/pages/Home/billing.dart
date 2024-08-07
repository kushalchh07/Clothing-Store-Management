// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../constants/color/color.dart';

class Billing extends StatefulWidget {
  const Billing({super.key});

  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _paymentMethodController = TextEditingController();

  List<Map<String, dynamic>> _products = [];
  String? _customerName;
  String? _customerAddress;
  String? _paymentMethod;

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _products.add({
          'name': _productNameController.text,
          'price': double.parse(_productPriceController.text),
          'quantity': int.parse(_quantityController.text),
          'total': double.parse(_productPriceController.text) *
              int.parse(_quantityController.text),
        });
        // Clear form fields after adding product
        _productNameController.clear();
        _productPriceController.clear();
        _quantityController.clear();
      });
    }
  }

  void _createInvoice() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _customerName = _customerNameController.text;
        _customerAddress = _customerAddressController.text;
        _paymentMethod = _paymentMethodController.text;
      });

      Navigator.of(context).pop();
    }
  }

  void _showInvoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Invoice'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTextFormField(
                    controller: _productNameController,
                    labelText: 'Product Name',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _productPriceController,
                    labelText: 'Per Piece Price',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _quantityController,
                    labelText: 'Quantity',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addProduct,
                    child: Text('Add Product'),
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _customerNameController,
                    labelText: 'Customer Name',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _customerAddressController,
                    labelText: 'Customer Address',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _paymentMethodController,
                    labelText: 'Payment Method',
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
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
              child: Text('Create Invoice'),
              onPressed: _createInvoice,
            ),
          ],
        );
      },
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
    );
  }

  pw.Document _generateInvoicePdf() {
    final pdf = pw.Document();
    double totalAmount = _products.fold(0, (sum, item) => sum + item['total']);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Invoice',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Customer Name: $_customerName'),
                pw.Text('Customer Address: $_customerAddress'),
                pw.Text('Payment Method: $_paymentMethod'),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Product Name'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Price'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Quantity'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Total'),
                        ),
                      ],
                    ),
                    for (var product in _products)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(product['name']),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                                'Rs${product['price'].toStringAsFixed(2)}'),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text('${product['quantity']}'),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                                'Rs${product['total'].toStringAsFixed(2)}'),
                          ),
                        ],
                      ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(''),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(''),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Total:'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('Rs${totalAmount.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf;
  }

  void _printInvoice() {
    final pdf = _generateInvoicePdf();
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
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
                  "Billing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: MaterialButton(
                  minWidth: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  // height: 50,
                  color: primaryColor,
                  onPressed: _showInvoiceDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Make Invoice',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_products.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Invoice Details:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Customer Name: $_customerName'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Customer Address: $_customerAddress'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Payment Method: $_paymentMethod'),
                        ),
                        Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                _buildTableCell('Product Name'),
                                _buildTableCell('Price'),
                                _buildTableCell('Quantity'),
                                _buildTableCell('Total'),
                              ],
                            ),
                            for (var product in _products)
                              TableRow(
                                children: [
                                  _buildTableCell(product['name']),
                                  _buildTableCell(
                                      'Rs${product['price'].toStringAsFixed(2)}'),
                                  _buildTableCell('${product['quantity']}'),
                                  _buildTableCell(
                                      'Rs${product['total'].toStringAsFixed(2)}'),
                                ],
                              ),
                            TableRow(
                              children: [
                                _buildTableCell(''),
                                _buildTableCell(''),
                                _buildTableCell('Total:'),
                                _buildTableCell(
                                    'Rs${_products.fold<num>(0, (sum, item) => sum + (item['total'] ?? 0.0))}')
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 200,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                                // height: 50,
                                color: primaryColor,
                                onPressed: _printInvoice,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Print Invoice',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: whiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 200,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35)),
                                // height: 50,
                                color: primaryColor,
                                onPressed: _showInvoiceDialog,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Edit Invoice',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: whiteColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
