import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/history.dart';
import 'package:user_app/Widgets/flutterwave_web_widget.dart';
import 'package:user_app/Widgets/paystack_web_widget.dart';
import 'package:user_app/Widgets/stripe_web_widget.dart';
import 'package:user_app/Widgets/transaction_history_widget.dart';

import '../Model/constant.dart';
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
        .collection('users')
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
    getStripeStatus();
    getPaystackStatus();
    getCurrency();
    getFlutterwaveStatus();
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
        .collection('users')
        .doc(user!.uid)
        .collection('Transaction History')
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(20),
          Text(
            '$currency${Formatter().converter(wallet.toDouble())}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Helvetica',
              fontSize: 30,
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Payment Gateway',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Helvetica',
                    fontSize: 18,
                  ),
                ).tr(),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 220, 214, 214),
          ),
          if (enableStripe == true)
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const StripeWebWidget();
                }));
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return const PaymentSheetScreen();
                // }));
              },
              leading: Image.network(
                'https://cdn.dribbble.com/users/920/screenshots/3031540/untitled-3.gif',
                height: 50,
                width: 50,
              ),
              title: const Text(
                'Stripe',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Upload money with Stripe payment gateway'),
              trailing: const Icon(Icons.chevron_right),
            ),
          if (enableStripe == true)
            const Divider(
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
          if (enableFlutterwave == true)
            ListTile(
              onTap: () {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return const FlutterwaveWidget();
                // }));
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FlutterwaveWebWidget();
                }));
              },
              leading: Image.network(
                'https://asset.brandfetch.io/iddYbQIdlK/idN21BaY-U.jpeg',
                height: 50,
                width: 50,
              ),
              title: const Text(
                'Flutterwave',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  const Text('Upload money with Flutterwave payment gateway'),
              trailing: const Icon(Icons.chevron_right),
            ),
          if (enableFlutterwave == true)
            const Divider(
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
          if (enablePaystack == true)
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PaystackWebWidget();
                }));
              },
              leading: Image.network(
                'https://static-00.iconduck.com/assets.00/paystack-icon-512x504-w7v8l6as.png',
                height: 50,
                width: 50,
              ),
              title: const Text(
                'Paystack',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  const Text('Upload money with Paystack payment gateway'),
              trailing: const Icon(Icons.chevron_right),
            ),
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
                            color: appColor,
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
    );
  }
}
