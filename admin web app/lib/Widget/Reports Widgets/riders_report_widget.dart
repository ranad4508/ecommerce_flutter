import 'package:flutter/material.dart';

import '../pdf_generator.dart';

class RidersReportWidget extends StatefulWidget {
  const RidersReportWidget({super.key});

  @override
  State<RidersReportWidget> createState() => _RidersReportWidgetState();
}

class _RidersReportWidgetState extends State<RidersReportWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
                      child: PdfGenerator(
                        collection: 'drivers',
                      ),
                    );
                  });
            },
            child: const Text('Download Riders Report'))
      ],
    );
  }
}
