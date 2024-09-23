import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../pdf_generator.dart';

class UsersReportWidget extends StatefulWidget {
  const UsersReportWidget({super.key});

  @override
  State<UsersReportWidget> createState() => _UsersReportWidgetState();
}

class _UsersReportWidgetState extends State<UsersReportWidget> {
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
                        collection: 'users',
                      ),
                    );
                  });
            },
            child: const Text(
              'Download Users Report',
              style: TextStyle(color: Colors.white),
            ).tr())
      ],
    );
  }
}
