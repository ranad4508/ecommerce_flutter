import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:user_app/Model/constant.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/history.dart';
import 'package:user_app/Widgets/stripe_payment_sheet.dart';
//import 'package:user_app/Widgets/footer_widget.dart';
import 'package:user_app/Widgets/web_menu.dart';
// ignore: unused_import
import 'platforms/payment_element.dart'
    if (dart.library.js) 'platforms/payment_element_web.dart';

class StripeWebWidget extends StatefulWidget {
  const StripeWebWidget({super.key});

  @override
  State<StripeWebWidget> createState() => _StripeWebWidgetState();
}

class _StripeWebWidgetState extends State<StripeWebWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: const Color.fromARGB(255, 238, 237, 237),
        // appBar: AppBar(
        //     // title: const Text('Paystack'),
        //     ),
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
                            child: SingleChildScrollView(
                              child: StripeForm(),
                            ),
                          ))
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StripeForm(),
                ),
          const Gap(20),
          //const FooterWidget()
        ],
      ),
    ));
  }
}

class StripeForm extends StatefulWidget {
  const StripeForm({super.key});

  @override
  State<StripeForm> createState() => _StripeFormState();
}

class _StripeFormState extends State<StripeForm> {
  final emailController = TextEditingController();
  final amountController = TextEditingController();

  num wallet = 0;
  String fullname = '';
  String phone = '';
  bool isLoading = true;
  getUserDetail() {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoading = false;
        wallet = event['wallet'];
        fullname = event['fullname'];
        phone = event['phone'];
      });
      //  print('Fullname is $fullName');
    });
  }

  String currency = '';
  String currencyCode = '';
  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
        currencyCode = value['Currency code'];
      });
    });
  }

  @override
  void initState() {
    getUserDetail();
    getCurrency();

    amountController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String generateRef() {
    final randomCode = Random().nextInt(3234234);
    return 'ref-$randomCode';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(8),
        //   color: Colors.white,
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)),
                  const Gap(20),
                  Text(
                    'Stripe Payment',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email'.tr(),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Amount($currency)'.tr(),
              ),
            ),
            //   const Spacer(),
            const Gap(50),

            ElevatedButton(
              onPressed:
                  amountController.text.isEmpty || emailController.text.isEmpty
                      ? null
                      : () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PaymentSheetScreen(
                                fullname: fullname,
                                phone: phone,
                                email: emailController.text.toString(),
                                amount: amountController.text,
                                currency: currency,
                                currencyCode: currencyCode,
                                wallet: wallet);
                          }));
                        },
              style: ElevatedButton.styleFrom(
                shape: const BeveledRectangleBorder(),
                backgroundColor: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pay${amountController.text.isEmpty ? '' : ' $currency${Formatter().converter(double.parse(amountController.text))}'} with Stripe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StripeCard extends StatefulWidget {
  final String amount;
  final String currency;
  final String currencyCode;
  final num wallet;
  final String email;
  const StripeCard(
      {super.key,
      required this.amount,
      required this.currency,
      required this.currencyCode,
      required this.wallet,
      required this.email});

  @override
  State<StripeCard> createState() => _StripeCardState();
}

class _StripeCardState extends State<StripeCard> {
  String? clientSecret;
  Future<String> createPaymentIntent() async {
    final url = Uri.parse('$serverUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'currency': widget.currencyCode.toLowerCase(),
        'email': widget.email,
        'amount': num.parse(widget.amount),
        'payment_method_types': ['card'],
        'request_three_d_secure': 'any',
      }),
    );

    // // ignore: avoid_print
    // print('Status code is ${response.body}');
    return json.decode(response.body)['clientSecret'];
  }

  Future<void> getClientSecret() async {
    try {
      final client = await createPaymentIntent();
      setState(() {
        clientSecret = client;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error is ${e.toString()}');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    getClientSecret();
    super.initState();
  }

  updateWallet() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance.collection('users').doc(user!.uid).update(
        {'wallet': widget.wallet + num.parse(widget.amount)}).then((value) {
      // Get the current date and time
      DateTime now = DateTime.now();

      // Format the date to '24th January, 2024' format
      String formattedDate = DateFormat('d MMMM, y').format(now);
      history(HistoryModel(
          message: 'Credit Alert',
          amount: widget.amount,
          paymentSystem: 'Stripe',
          timeCreated: formattedDate));
      Fluttertoast.showToast(
              msg: "Wallet has been uploaded successfully".tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              fontSize: 14.0)
          .then((value) {});
    });
  }

  history(HistoryModel historyModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Transaction History')
        .add(historyModel.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              child: clientSecret != null
                  ? PlatformPaymentElement(
                      clientSecret,
                      amount: widget.amount,
                      wallet: widget.wallet,
                    )
                  : const Center(child: CircularProgressIndicator())),
          const Gap(20),
          ElevatedButton(
            onPressed: () {
              pay(widget.amount, widget.wallet, true);
            },
            style: ElevatedButton.styleFrom(
              shape: const BeveledRectangleBorder(),
              backgroundColor: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Pay${widget.amount.isEmpty ? '' : ' ${widget.currency}${Formatter().converter(double.parse(widget.amount))}'} with Stripe',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
