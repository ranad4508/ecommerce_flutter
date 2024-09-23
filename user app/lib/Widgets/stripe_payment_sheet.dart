import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/Model/constant.dart';
import 'stripe_button.dart';
import 'stripe_scaffold.dart';

class PaymentSheetScreen extends StatefulWidget {
  final String amount;
  final String currency;
  final String currencyCode;
  final String fullname;
  final String phone;
  final num wallet;
  final String email;
  const PaymentSheetScreen(
      {super.key,
      required this.amount,
      required this.currency,
      required this.currencyCode,
      required this.wallet,
      required this.email,
      required this.fullname,
      required this.phone});

  @override
  State<PaymentSheetScreen> createState() => _PaymentSheetScreenState();
}

class _PaymentSheetScreenState extends State<PaymentSheetScreen> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Payment Sheet',
      tags: const ['Single Step'],
      children: [
        Stepper(
          //    controlsBuilder: emptyControlBuilder,
          currentStep: step,
          steps: [
            Step(
              title: const Text('Init payment'),
              content: LoadingButton(
                onPressed: initPaymentSheet,
                text: 'Init payment sheet',
              ),
            ),
            Step(
              title: const Text('Confirm payment'),
              content: LoadingButton(
                onPressed: confirmPayment,
                text: 'Pay now',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _createTestPaymentSheet() async {
    final url = Uri.parse('$serverUrl/payment-sheet');
    // final url = Uri.parse('http://10.0.2.2:3000/payment-sheet');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': widget.amount,
      }),
    );
    final body = json.decode(response.body);
    if (body['error'] != null) {
      throw Exception(body['error']);
    }
    return body;
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await _createTestPaymentSheet();

      // mocked data for tests

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data['paymentIntent'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          //  preferredNetworks: [CardBrand.Amex],
          // Customer params
          customerId: data['customer'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          returnURL: 'flutterstripe://redirect',

          // Extra params
          primaryButtonLabel: 'Pay now',
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'DE',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'DE',
            testEnv: true,
          ),
          style: ThemeMode.dark,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.lightBlue,
              primary: Colors.blue,
              componentBorder: Colors.red,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: Colors.red),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color.fromARGB(255, 231, 235, 30),
                  text: Color.fromARGB(255, 235, 92, 30),
                  border: Color.fromARGB(255, 235, 92, 30),
                ),
              ),
            ),
          ),
          billingDetails: BillingDetails(
            name: widget.fullname,
            email: widget.email,
            phone: widget.phone,
            address: const Address(
              city: 'Houston',
              country: 'US',
              line1: '1459  Circle Drive',
              line2: '',
              state: 'Texas',
              postalCode: '77063',
            ),
          ),
        ),
      );
      setState(() {
        step = 1;
      });
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
      Fluttertoast.showToast(
          msg: 'Error: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      rethrow;
    }
  }

  Future<void> confirmPayment() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      setState(() {
        step = 0;
      });
      DateTime now = DateTime.now();

      // Format the date to '24th January, 2024' format
      String formattedDate = DateFormat('d MMMM, y').format(now);
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'wallet': widget.wallet + int.parse(widget.amount)});
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('Transaction History')
          .add({
        'message': 'Credit Alert',
        'amount': widget.amount,
        'paymentSystem': 'Stripe',
        'timeCreated': formattedDate
      });
      Fluttertoast.showToast(
          msg: 'Payment succesfully completed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          fontSize: 14.0).then((value) {
            Future.delayed(const Duration(seconds: 2),(){
              context.pop();
            });
          });
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Unforeseen error: $e',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    }
  }
}
