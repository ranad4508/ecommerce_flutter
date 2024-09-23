import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:rider_app/Model/bank_model.dart';

import '../Model/history.dart';

class RequestWithdrawalWidget extends StatefulWidget {
  const RequestWithdrawalWidget({super.key});

  @override
  State<RequestWithdrawalWidget> createState() =>
      _RequestWithdrawalWidgetState();
}

class _RequestWithdrawalWidgetState extends State<RequestWithdrawalWidget> {
  final _formKey = GlobalKey<FormState>();
  num amount = 0;
  String bankName = '';
  String accountNumber = '';
  bool isLoading = false;
  String id = '';
  String userUID = '';
  num wallet = 0;

  addBank(BankModel bankModel) {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('Withdrawal Request')
        .doc(id)
        .set(bankModel.toMap())
        .then((value) {
      setState(() {
        isLoading = false;
      });
      FirebaseFirestore.instance
          .collection('riders')
          .doc(userUID)
          .update({'wallet': wallet - amount});
      DateTime now = DateTime.now();

      // Format the date to '24th January, 2024' format
      String formattedDate = DateFormat('d MMMM, y').format(now);
      history(HistoryModel(
          message: 'Debit Alert',
          amount: (amount).toString(),
          paymentSystem: 'Wallet',
          timeCreated: formattedDate));
      Fluttertoast.showToast(
          msg: "Request sent successfully...".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.pop(context);
    });
  }

  history(HistoryModel historyModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Transaction History')
        .add(historyModel.toMap());
  }

  getUserDetail() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        wallet = event['wallet'];
        userUID = user.uid;
      });
    });
  }

  @override
  void initState() {
    getUserDetail();
    // getCurrency();
    getBanks();
    id = const Uuid().v1();
    super.initState();
  }

  List<BankModel> banks = [];
  bool isLoaded = false;
  getBanks() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Banks')
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      banks.clear();
      for (var element in event.docs) {
        var prods = BankModel.fromMap(element, element.id);
        setState(() {
          banks.add(prods);
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              DropdownSearch<BankModel>(
                validator: (item) {
                  if (item == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                items: banks,
                popupProps: const PopupProps.bottomSheet(),
                dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                  hintText: 'Select Bank',
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
                )),
                itemAsString: (BankModel u) => u.bankName,
                onChanged: (BankModel? data) {
                  setState(() {
                    bankName = data!.bankName;
                    accountNumber = data.accountNumber;
                  });
                },
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
                    amount = num.parse(value!);
                  });
                },
                onChanged: (value) {
                  setState(() {
                    amount = num.parse(value);
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
                  hintText: 'Ammount'.tr(),
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
                            if (amount > wallet || wallet == 0) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Wallet amount is greater than ammount you entered or wallet amount is zero"
                                          .tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            } else {
                              addBank(BankModel(
                                timeCreated: DateTime.now(),
                                  account: 'rider',
                                  id: id,
                                  amount: amount,
                                  vendorID: userUID,
                                  paymentStatus: false,
                                  bankName: bankName,
                                  accountNumber: accountNumber));
                            }
                          }
                        },
                  child: isLoading == true
                      ? const Text('Please wait...',
                              style: TextStyle(color: Colors.white))
                          .tr()
                      : const Text('Send Request',
                              style: TextStyle(color: Colors.white))
                          .tr()),
              //const FooterWidget()
            ],
          ),
        ),
      ),
    );
  }
}
