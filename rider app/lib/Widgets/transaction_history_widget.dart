import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rider_app/Model/formatter.dart';
import 'package:rider_app/Model/history.dart';
//import 'package:rider_app/Widgets/footer_widget.dart';
import 'package:rider_app/Widgets/web_menu.dart';

class TransactionHistoryWidget extends StatefulWidget {
  const TransactionHistoryWidget({super.key});

  @override
  State<TransactionHistoryWidget> createState() =>
      _TransactionHistoryWidgetState();
}

class _TransactionHistoryWidgetState extends State<TransactionHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      // appBar: AppBar(
      // //   // title: const Text('Paystack'),
      // //   centerTitle: true,
      // //   title: const Text(
      // //     'Transaction History',
      // //     // style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      // //     //       color: Colors.black,
      // //     //       fontWeight: FontWeight.w800,
      // //     //     ),
      // //   ).tr(),
      // // ),
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MediaQuery.of(context).size.width >= 1100
                ? const Padding(
                    padding: EdgeInsets.only(left: 100, right: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Card(
                              shape: BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: WebMenu(path: '/wallet')),
                        ),
                        Gap(20),
                        Expanded(
                            flex: 6,
                            child: Card(
                              shape: BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: Transactions(),
                            ))
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Transactions(),
                  ),
            const Gap(20),
            //const FooterWidget()
          ],
        ),
      ),
    );
  }
}

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
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
    // getUserDetail();
    getCurrency();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (MediaQuery.of(context).size.width >= 1100)
            const Divider(
              color: Color.fromARGB(255, 237, 235, 235),
              thickness: 1,
            ),
          const Gap(20),
          isLoaded == true
              ? Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.only(left: 100, right: 100)
                      : const EdgeInsets.all(8.0),
                  child: ListView.builder(
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
                  ),
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
                  : Padding(
                      padding: MediaQuery.of(context).size.width >= 1100
                          ? const EdgeInsets.only(left: 100, right: 100)
                          : const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
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
                    ),
          const Gap(20)
        ],
      ),
    );
  }
}
