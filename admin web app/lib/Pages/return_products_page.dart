import 'package:admin_web_app/Widget/returned_products_datatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ReturnProductsPage extends StatefulWidget {
  const ReturnProductsPage({super.key});

  @override
  State<ReturnProductsPage> createState() => _ReturnProductsPageState();
}

class _ReturnProductsPageState extends State<ReturnProductsPage> {
  @override
  void initState() {
    super.initState();
  }

  bool? loggedIn;

  getSelectedRoute() {
    Future.delayed(const Duration(seconds: 2), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? repeat = prefs.getBool('logged in');
      setState(() {
        loggedIn = repeat;
      });
      if (repeat == false || repeat == null) {
        // ignore: use_build_context_synchronously
        context.go('/login');
        // ignore: avoid_print
        print('Repeat is $repeat');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getSelectedRoute();
    return  const Scaffold(
     
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ReturnedProductsData(),
            ),
          ],
        ),
      ),
    );
  }
}
