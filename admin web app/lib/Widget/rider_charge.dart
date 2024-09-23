import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RiderCharge extends StatefulWidget {
  const RiderCharge({super.key});

  @override
  State<RiderCharge> createState() => _RiderChargeState();
}

class _RiderChargeState extends State<RiderCharge> {
  final _formKey = GlobalKey<FormState>();
  num referralAmount = 0;
  bool status = false;

  getReferralDetails() {
    FirebaseFirestore.instance
        .collection('Rider Charge')
        .doc('Rider Charge')
        .snapshots()
        .listen((value) {
      setState(() {
        if (mounted) {
          referralAmount = value['Rider Charge'];
        }
      });
    });
  }

  updateRiderCharges(num amount) {
    FirebaseFirestore.instance
        .collection('Rider Charge')
        .doc('Rider Charge')
        .set({
      'Rider Charge': amount,
    });
  }

  @override
  void initState() {
    getReferralDetails();
    getEnableRiderStatusDetails();
    super.initState();
  }

  updateRiderStatus(
    bool status,
  ) {
    FirebaseFirestore.instance
        .collection('Enable Rider System')
        .doc('Enable Rider System')
        .set({
      'Status': status,
      // 'Referral Amount': amount,
    });
  }

  bool enableRiderSystem = false;

  getEnableRiderStatusDetails() {
    FirebaseFirestore.instance
        .collection('Enable Rider System')
        .doc('Enable Rider System')
        .snapshots()
        .listen((value) {
      setState(() {
        if (mounted) {
          // referralAmount = value['Referral Amount'];
          enableRiderSystem = value['Status'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Enable Delivery System'),
          value: enableRiderSystem,
          onChanged: (bool? value) {
            setState(() {
              // enableRiderSystem = !enableRiderSystem;
              // updateRiderStatus(enableRiderSystem);
              Fluttertoast.showToast(
                  msg: "You can't delete this because its a test mode".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 14.0);
            });
          },
        ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Rider Charge In Percentage',
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
                        child: Text('Percatage:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    Flexible(
                        flex: 4,
                        child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                referralAmount = int.parse(value);
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                              ),
                              hintText: '$referralAmount%',
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
                    elevation: MaterialStateProperty.all(10),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade800,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateRiderCharges(referralAmount);
                      _formKey.currentState!.reset();
                      Fluttertoast.showToast(
                          msg: "Update completed",
                          backgroundColor: Colors.blue.shade800,
                          textColor: Colors.white);
                    }
                  },
                  child: const Text('Update',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        // const Divider(
        //   color: Colors.grey,
        //   thickness: 2,
        // ),
      ],
    );
  }
}
