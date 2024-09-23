import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rider_app/Model/bank_model.dart';
import 'package:rider_app/Model/formatter.dart';

class WithdrawalHistoryPage extends StatefulWidget {
  const WithdrawalHistoryPage({super.key});

  @override
  State<WithdrawalHistoryPage> createState() => _WithdrawalHistoryPageState();
}

class _WithdrawalHistoryPageState extends State<WithdrawalHistoryPage> {
  List<BankModel> banks = [];
  bool isLoaded = false;
  getBanks() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('Withdrawal Request')
        .where('vendorID', isEqualTo: user!.uid)
        // .orderBy('paymentStatus', descending: false)
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
  void initState() {
    getBanks();
    getCurrency();
    super.initState();
  }

  String currency = '';
  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal History').tr(),
      ),
      body: banks.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.account_balance,
                    color: Colors.orange,
                    size: MediaQuery.of(context).size.width >= 1100
                        ? MediaQuery.of(context).size.width / 5
                        : MediaQuery.of(context).size.width / 1.5,
                  ),
                ),
                const Gap(20),
              ],
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: banks.length,
              itemBuilder: (context, index) {
                BankModel bankModel = banks[index];
                return ListTile(
                  trailing: Text(
                      '$currency${Formatter().converter(bankModel.amount!.toDouble())}'),
                  title: Text(bankModel.bankName),
                  subtitle: Text(
                      bankModel.paymentStatus == true ? 'Paid' : "Not Paid"),
                );
              }),
    );
  }
}
