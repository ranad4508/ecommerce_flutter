// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Models/user.dart';


class PdfGenerator extends StatefulWidget {
  final String collection;
  const PdfGenerator({super.key, required this.collection});

  @override
  State<PdfGenerator> createState() => _PdfGeneratorState();
}

class _PdfGeneratorState extends State<PdfGenerator> {
  List<UserModel> users = [];
  final databaseReference = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchAllUsers() async {
    return FirebaseFirestore.instance
        .collection(widget.collection)
        .get()
        .then((event) {
      return event.docs.map((e) {
        setState(() {
          users.add(UserModel.fromMap(e.data(), e.id));
        });
        return UserModel.fromMap(e.data(), e.id);
      }).toList();
    });
  }

  @override
  void initState() {
    fetchAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(users);
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
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PdfPreview(
              build: (format) =>
                  _generatePdf(format, widget.collection, users, context),
            ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title,
      List<UserModel> users, BuildContext context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

    pdf.addPage(
      pw.MultiPage(
          pageFormat: format,
          build: (context) {
            return [
              pw.Text(title == 'users' ? 'Users Report' : 'Drivers Report',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              // ignore: deprecated_member_use
              pw.Table.fromTextArray(
                headers: ['Index      ', 'Name', 'Address', 'Wallet Balance'],
                data: List<List<dynamic>>.generate(users.length, (index) {
                  UserModel userModel = users[index];
                  return <dynamic>[
                    1 + index,
                    userModel.displayName,
                    userModel.address,
                    '\$${userModel.wallet}'
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
