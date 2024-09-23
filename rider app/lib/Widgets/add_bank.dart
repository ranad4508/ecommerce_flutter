import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:rider_app/Model/bank_model.dart';
//import 'package:rider_app/Widgets/footer_widget.dart';

class AddBank extends StatefulWidget {
  const AddBank({super.key});

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  String bankName = '';
  String accountNumber = '';
  bool isLoading = false;
  String id = '';
  final _formKey = GlobalKey<FormState>();

  addBank(BankModel bankModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Banks')
        .doc(id)
        .set(bankModel.toMap())
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Bank has been added successfully...".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    var uid = const Uuid();
    id = uid.v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add a new bank',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(children: [
                    const Text('Bank Name:').tr(),
                  ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      onSaved: (value) {
                        setState(() {
                          bankName = value!;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          bankName = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required field'.tr();
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Bank Name'.tr(),
                        focusColor: Colors.grey,
                        filled: true,
                        fillColor: Colors.white10,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    const Text('Account Number:').tr(),
                  ]),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      setState(() {
                        accountNumber = value!;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        accountNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required field'.tr();
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Account Number'.tr(),
                      focusColor: Colors.grey,
                      filled: true,
                      fillColor: Colors.white10,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange,
                        ),
                      ),
                      onPressed: isLoading == true
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                addBank(BankModel(
                                  timeCreated: DateTime.now(),
                                    account: '',
                                    id: id,
                                    bankName: bankName,
                                    accountNumber: accountNumber));
                              }
                            },
                      child: isLoading == true
                          ? const Text('Please wait...',
                                  style: TextStyle(color: Colors.white))
                              .tr()
                          : const Text('Add Bank',
                                  style: TextStyle(color: Colors.white))
                              .tr()),
                  //const FooterWidget()
                ],
              ),
            ),
          ),
        ));
  }
}
