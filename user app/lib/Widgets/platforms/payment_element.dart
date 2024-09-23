import 'package:flutter/widgets.dart';

Future<void> pay(String amount, num wallet, bool show) async {
  // ignore: avoid_print
  print('errrrrrrrrrrrrrr');
  throw UnimplementedError();
}

class PlatformPaymentElement extends StatelessWidget {
  const PlatformPaymentElement(this.clientSecret,
      {super.key, required this.amount, required this.wallet});
  final String amount;
  final String? clientSecret;
  final num wallet;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
