import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../pdf_generator_orders.dart';

class OrdersReportWidget extends StatefulWidget {
  const OrdersReportWidget({super.key});

  @override
  State<OrdersReportWidget> createState() => _OrdersReportWidgetState();
}

class _OrdersReportWidgetState extends State<OrdersReportWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.blue.shade800,
              ),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const Dialog(
                      child: PdfGeneratorOrders(),
                    );
                  });
            },
            child: const Text(
              'Download Orders Report',
              style: TextStyle(color: Colors.white),
            ).tr())
      ],
    );
  }
}
