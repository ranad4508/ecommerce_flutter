import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/pcikup_address_datatable.dart';


class PickupAddressPage extends StatefulWidget {
  const PickupAddressPage({super.key});

  @override
  State<PickupAddressPage> createState() => _PickupAddressPageState();
}

class _PickupAddressPageState extends State<PickupAddressPage> {
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
    return const Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: PickupAddressDatatable(),
            ),
          ],
        ),
      ),
    );
  }
}
