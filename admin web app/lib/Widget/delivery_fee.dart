import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryFeeSettings extends StatefulWidget {
  static const routeName = '/push-notifications-settings';

  const DeliveryFeeSettings({super.key});

  @override
  State<DeliveryFeeSettings> createState() => _DeliveryFeeSettingsState();
}

class _DeliveryFeeSettingsState extends State<DeliveryFeeSettings> {
  @override
  void initState() {
    getOneSignalDetails();
    getCurrencyDetails();
    super.initState();
  }

  int? oneSignalKey;

  final _formKey = GlobalKey<FormState>();

  int getOnesignalKey = 0;

  getOneSignalDetails() {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc('Admin')
        .snapshots()
        .listen((value) {
      if (mounted) {
        setState(() {
          getOnesignalKey = value['Delivery Fee'];
        });
      }
    });
  }

  String getcurrencyName = '';
  String getcurrencyCode = '';
  String getcurrencySymbol = '';

  getCurrencyDetails() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          getcurrencyName = value['Currency name'];
          getcurrencyCode = value['Currency code'];
          getcurrencySymbol = value['Currency symbol'];
        });
      }
    });
  }

  updateOneSignalKey() {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc('Admin')
        .update({'Delivery Fee': oneSignalKey});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Enter Delivery Fee',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                        flex: 1,
                        child: Text('Delivery Fee:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    Flexible(
                        flex: 4,
                        child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                oneSignalKey = int.parse(value);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                              hintText: '$getcurrencySymbol$getOnesignalKey',
                              focusColor: Colors.grey,
                              filled: true,
                              fillColor: Colors.white10,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                            )))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade800,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateOneSignalKey();
                      _formKey.currentState!.reset();
                      Fluttertoast.showToast(
                          msg: "Update completed",
                          backgroundColor: Colors.blue.shade800,
                          textColor: Colors.white);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
