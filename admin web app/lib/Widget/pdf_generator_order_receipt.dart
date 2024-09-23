// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../Models/order_model.dart';

class PdfGeneratorOrderReceipt extends StatefulWidget {
  final OrderModel2 orderModel2;
  final String fullName;
  const PdfGeneratorOrderReceipt({
    super.key,
    required this.orderModel2, required this.fullName,
  });

  @override
  State<PdfGeneratorOrderReceipt> createState() =>
      _PdfGeneratorOrderReceiptState();
}

class _PdfGeneratorOrderReceiptState extends State<PdfGeneratorOrderReceipt> {
  DocumentReference? userRef;

  @override
  initState() {
    super.initState();
    getCurrencyDetails();
    // fetchOrders();
  }

  Future<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      fetchOrders() async {
    return FirebaseFirestore.instance
        .collection('Orders')
        .snapshots()
        .listen((data) {
      orders.clear();
      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            orders.add(OrderModel2(
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              marketID: doc.data()['marketID'],
              vendorID: doc.data()['vendorID'],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ));
          });
        }
      }
    });
  }

  String userID = '';
  List<OrderModel2> orders = [];

  String currencyName = '';
  String currencyCode = '';
  String currencySymbol = '';
  String getcurrencyName = '';
  String getcurrencyCode = '';
  String getcurrencySymbol = '';

  getCurrencyDetails() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        getcurrencyName = value['Currency name'];
        getcurrencyCode = value['Currency code'];
        getcurrencySymbol = value['Currency symbol'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Orders are $orders');
    print('Orders are $getcurrencySymbol');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)),
          )
        ],
      ),
      body: orders.isEmpty && getcurrencySymbol.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PdfPreview(
              build: (format) => _generatePdf(format, 'Order Receipt',
                  widget.orderModel2, context, getcurrencySymbol,widget.fullName),
            ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title,
      OrderModel2 users, BuildContext context, String currencySymbol,String fullname) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.MultiPage(
          pageFormat: format,
          build: (context) {
            return [
              pw.Text(title,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

              pw.SizedBox(height: 20),
              pw.Text('Order ID: ${users.orderID}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                     pw.SizedBox(height: 5),
              pw.Text(
                "Customer's name: $fullname",
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "Total Amount: \$${users.total}",
              ),
              pw.SizedBox(height: 10),
              // ignore: deprecated_member_use
              pw.Table.fromTextArray(
                headers: [
                  'Index      ',
                  'Product',
                  'Selected Product',
                  'Quantity',
                  'Price'
                ],
                data:
                    List<List<dynamic>>.generate(users.orders.length, (index) {
                  OrdersList userModel = users.orders[index];
                  return <dynamic>[
                    1 + index,
                    '#${userModel.productName}',
                    userModel.selected,
                    '${userModel.quantity}',
                    '\$${(userModel.selectedPrice)}',
                  ];
                }),
                headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey,
                ),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      color: PdfColors.grey,
                      width: .5,
                    ),
                  ),
                ),
                cellAlignment: pw.Alignment.topLeft,
                cellAlignments: {0: pw.Alignment.topLeft},
              )
            ];
          }),
    );

    return pdf.save();
  }
}
