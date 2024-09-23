import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../Widget/Reports Widgets/orders_report_widget.dart';
//import '../Widgets/verification_page.dart';

class OrdersReportPage extends StatefulWidget {
  const OrdersReportPage({super.key});

  @override
  State<OrdersReportPage> createState() => _OrdersReportPageState();
}

class _OrdersReportPageState extends State<OrdersReportPage> {
  bool isLogged = false;

  getIsLogged() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
        });
      } else {
        setState(() {
          isLogged = true;
        });
      }
    });
  }

  @override
  void initState() {
    getIsLogged();
    super.initState();
  }

  bool verification = true;

  verificationStatus() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (isLogged == false) {
      return null;
    } else {
      return user!.reload().then((value) {
        setState(() {
          verification = user.emailVerified;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // verificationStatus();
    return const Scaffold(
      body: SafeArea(
        child: Center(child: OrdersReportWidget()),
      ),
    );
  }
}
