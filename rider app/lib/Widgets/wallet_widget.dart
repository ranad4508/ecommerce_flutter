import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rider_app/Model/formatter.dart';
import 'package:rider_app/Model/history.dart';
import 'package:rider_app/Widgets/request_withdrawal.dart';
import 'package:rider_app/Widgets/transaction_history_widget.dart';
// import 'stripe_payment_sheet.dart';
// import 'stripe_web_widget.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({super.key});

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  num wallet = 0;
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
      });
      //  print('Fullname is $fullName');
    });
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
  void initState() {
    getUserDetail();
    // getStripeStatus();
    // getPaystackStatus();
    getCurrency();
    // getFlutterwaveStatus();
    getTransactionHistory();
    super.initState();
  }

  bool isLoaded = true;
  List<HistoryModel> history = [];
  getTransactionHistory() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Transaction History')
        .orderBy('timeCreated')
        .limit(5)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      history.clear();
      for (var element in event.docs) {
        var prods = HistoryModel.fromMap(element.data(), element.id);
        setState(() {
          history.add(prods);
        });
      }
    });
  }

  getStripeStatus() {
    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Stripe')
        .get()
        .then((value) {
      setState(() {
        enableStripe = value['Stripe'];
      });
    });
  }

  getPaystackStatus() {
    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Paystack')
        .get()
        .then((value) {
      setState(() {
        enablePaystack = value['Paystack'];
      });
    });
  }

  getFlutterwaveStatus() {
    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Flutterwave')
        .get()
        .then((value) {
      setState(() {
        enableFlutterwave = value['Flutterwave'];
      });
    });
  }

  bool enableStripe = false;
  bool enablePaystack = false;
  bool enableFlutterwave = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.orange,
          onPressed: () {
            showBarModalBottomSheet(
              expand: true,
              bounce: true,
              // context: context,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text('Request Withdrawal Form').tr(),
                ),
                body: const RequestWithdrawalWidget(),
              ),
            );
          },
          label: const Text("Request Withdrawal").tr()),
      appBar: AppBar(
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(20),
            Text(
              '$currency${Formatter().converter(wallet.toDouble())}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica',
                fontSize: 40,
              ),
            ),
            const Gap(20),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Payment Gateway',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontFamily: 'Helvetica',
            //           fontSize: 18,
            //         ),
            //       ).tr(),
            //     ],
            //   ),
            // ),
            // const Divider(
            //   color: Color.fromARGB(255, 220, 214, 214),
            // ),

            const Gap(20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                    ),
                  ).tr(),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const TransactionHistoryWidget();
                        }));
                      },
                      child: const Icon(Icons.chevron_right))
                ],
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 220, 214, 214),
            ),
            const Gap(20),
            isLoaded == true
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListTile(
                          title: Container(
                            height: 20,
                            color: Colors.grey,
                          ),
                          subtitle: Container(
                            height: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  )
                : history.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.receipt,
                              color: Colors.orange,
                              size: MediaQuery.of(context).size.width >= 1100
                                  ? MediaQuery.of(context).size.width / 5
                                  : MediaQuery.of(context).size.width / 1.5,
                            ),
                          ),
                          const Gap(20),
                        ],
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          HistoryModel historyModel = history[index];
                          return ListTile(
                            title: Text(historyModel.message).tr(),
                            trailing: Text(historyModel.timeCreated),
                            subtitle: Text(
                                '$currency${Formatter().converter(double.parse(historyModel.amount))} with ${historyModel.paymentSystem}'),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            indent: 20,
                            endIndent: 20,
                            color: Color.fromARGB(255, 220, 214, 214),
                          );
                        },
                      ),
            const Gap(20)
          ],
        ),
      ),
    );
  }
}
