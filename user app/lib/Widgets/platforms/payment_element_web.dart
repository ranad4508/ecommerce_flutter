// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/Model/history.dart';
import '../../Model/stripe_checkout_web.dart';

Future<void> pay(String amount, num wallet, bool showToast) async {
  try {
    // print('worrrrrk');
    await WebStripe.instance.confirmPaymentElement(
      ConfirmPaymentElementOptions(
        confirmParams: ConfirmPaymentParams(return_url: getReturnUrl()),
      ),
    );

    // success
    // other process
  }
  //  on StripeException catch (e) {
  //   print('StripeException ======= ${e.error}');
  // } on StripeError catch (e) {
  //   print('The error is ${e.message}');
  // }
  catch (e) {
    print('e.runtimeType==== ${e.runtimeType}');
    print('THe ERROR IS $e');
    if (showToast == true) {
      Fluttertoast.showToast(
          msg: 'Please check your card and try again'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 5,
          fontSize: 14.0);
    }
    // ignore: unnecessary_null_comparison
    if (e == null) {
    } else {
      DateTime now = DateTime.now();

      // Format the date to '24th January, 2024' format
      String formattedDate = DateFormat('d MMMM, y').format(now);
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'wallet': wallet + num.parse(amount)});
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('Transaction History')
          .add({
        'message': 'Credit Alert',
        'amount': amount,
        'paymentSystem': 'Stripe',
        'timeCreated': formattedDate
      });
    }
  }
}
//}

class PlatformPaymentElement extends StatefulWidget {
  const PlatformPaymentElement(
    this.clientSecret, {
    super.key,
    required this.amount,
    required this.wallet,
  });

  final String? clientSecret;
  final String amount;
  final num wallet;

  @override
  State<PlatformPaymentElement> createState() => _PlatformPaymentElementState();
}

class _PlatformPaymentElementState extends State<PlatformPaymentElement> {
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
          .then((value) {
        //  Navigator.pop(context);
      });
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
  void initState() {
    pay(widget.amount, widget.wallet, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaymentElement(
      autofocus: true,
      enablePostalCode: true,
      onCardChanged: (_) {
        // updateWallet();
        // if(clientSecret.)
      },
      clientSecret: widget.clientSecret ?? '',
    );
  }
}
