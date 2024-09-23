// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/Email_Management/bulk_email.dart';


class BulkEmailPage extends StatefulWidget {
  const BulkEmailPage({super.key});

  @override
  State<BulkEmailPage> createState() => _BulkEmailPageState();
}

class _BulkEmailPageState extends State<BulkEmailPage> {
  @override
  void initState() {
   
    super.initState();
  }

  bool? loggedIn;
 

  getSelectedRoute() {
    SharedPreferences.getInstance().then((prefs) {
      var log = prefs.getBool('logged in');
      setState(() {
        loggedIn = log!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getSelectedRoute();
    return const Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: BulkEmailDataTable(),
            ),
          ],
        ),
      ),
    );
  }
}
