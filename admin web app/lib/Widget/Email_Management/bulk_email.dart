// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Models/email_model.dart';

class BulkEmailDataTable extends StatefulWidget {
  const BulkEmailDataTable({super.key});

  @override
  State<BulkEmailDataTable> createState() => _BulkEmailDataTableState();
}

class _BulkEmailDataTableState extends State<BulkEmailDataTable> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  final bool _sortAscending = true;

  @override
  void initState() {
    getBulkEmails();
    super.initState();
  }

  List<EmailModel> bulkEmails = [];
  getBulkEmails() {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance
        .collection('Bulk Email')
        .snapshots()
        .listen((event) {
          setState(() {
            isLoaded = false;
          });
      bulkEmails.clear();
      for (var element in event.docs) {
        var bulks = EmailModel.fromMap(element, element.id);
        setState(() {
          bulkEmails.add(bulks);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoaded == true
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : ListView(
                shrinkWrap: true,
                children: [
                  PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bulk Email',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            .tr(),
                        ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue.shade800,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Send bulk email').tr(),
                                      content: const SizedBox(
                                        height: 500,
                                        width: 400,
                                        child: BulkEMailForm(),
                                      ),
                                    );
                                  });
                            },
                            child: const Text('Send bulk email').tr())
                      ],
                    ),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (int? value) {
                      setState(() {
                        _rowsPerPage = value!;
                      });
                    },
                    source: VendorDataSource(bulkEmails, context),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      DataColumn(
                        label: const Text('Index',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            .tr(),
                      ),
                      DataColumn(
                        label: const Text('Title',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            .tr(),
                      ),
                      DataColumn(
                        label: const Text('Message',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            .tr(),
                      ),
                      DataColumn(
                        label: const Text('Time Created',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            .tr(),
                      ),
                      DataColumn(
                        label: const Text('Manage',
                                style: TextStyle(fontWeight: FontWeight.bold))
                            .tr(),
                      ),
                    ],
                  ),
                ],
              ));
  }
}

int numberOfdelivery = 0;

List<int> categoriesAmount = [];

class VendorDataSource extends DataTableSource {
  final List<EmailModel> vendor;
  VendorDataSource(this.vendor, this.context);
  final BuildContext context;
  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= vendor.length) return null;
    final EmailModel result = vendor[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${index + 1}')),
      DataCell(Text(result.title)),
      DataCell(Text(result.timeCreated)),
      DataCell(Text(result.message)),
      DataCell(InkWell(
          onTap: () {
            FirebaseFirestore.instance
                .collection('Bulk Email')
                .doc(result.uid)
                .delete();
          },
          child: const Text('Delete Email'))),
    ]);
  }

  @override
  int get rowCount => vendor.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class BulkEMailForm extends StatefulWidget {
  const BulkEMailForm({super.key});

  @override
  State<BulkEMailForm> createState() => _BulkEMailFormState();
}

class _BulkEMailFormState extends State<BulkEMailForm> {
  String message = '';

  String title = '';
  void sendEmail(String message) async {
    FirebaseFirestore.instance.collection('users').get().then((value) async {
      for (var v in value.docs) {
        print('Emails are ${v['email']}');
        try {
          await EmailJS.send(
            'service_afqv77j',
            'template_m3nid9v',
            {
              'user_email': v['email'],
              'message': message,
            },
            const Options(
              publicKey: 'no0bvzBj1Qp1S3ZHn',
              privateKey: 'aGuyOpL7gnZtncFdKVAup',
            ),
          );
          print('SUCCESS!');
        } catch (error) {
          if (error is EmailJSResponseStatus) {
            print('ERROR... ${error.status}: ${error.text}');
          }
          print(error.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            //  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.name,
            onChanged: (v) {
              setState(() {
                title = v;
              });
            },
            decoration: InputDecoration(hintText: 'Enter title'.tr()),
          ),
          const SizedBox(height: 20),
          TextFormField(
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLines: 5,
            onChanged: (v) {
              setState(() {
                message = v;
              });
            },
            decoration: InputDecoration(hintText: 'Enter Message'.tr()),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue.shade800,
                ),
              ),
              onPressed: () {
                if (message == '' || title == '') {
                  Fluttertoast.showToast(
                      msg: "All fields are required",
                      backgroundColor: const Color.fromARGB(255, 47, 37, 37),
                      textColor: Colors.white);
                } else {
                  sendEmail(message);
                  FirebaseFirestore.instance.collection('Bulk Email').add({
                    'title': title,
                    'message': message,
                    'emailType': 'Bulk Email',
                    'timeCreated': DateFormat.yMMMMEEEEd()
                        .format(DateTime.now())
                        .toString(),
                  }).then((value) {
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Email successfully sent",
                        backgroundColor: const Color.fromARGB(255, 47, 37, 37),
                        textColor: Colors.white);
                  });
                }
              },
              child: const Text('Send Email'))
        ],
      ),
    );
  }
}
