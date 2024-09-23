import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'all_orders.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    getIsLogged();
    super.initState();
  }

  bool isLogged = false;

  getIsLogged() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
        });

        //print('isLogged is $isLogged');
      } else {
        setState(() {
          isLogged = true;
        });

        //print('isLogged is $isLogged');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          centerTitle: true,
          title: Row(
            children: [
              Text(
                'Orders',
                style: TextStyle(
                    color: Theme.of(context).indicatorColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ).tr(),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: 'All'.tr(),
              ),
              Tab(text: 'Received'.tr()),
              Tab(text: 'Processing'.tr()),
              Tab(text: 'Completed'.tr()),
              // Tab(text: 'Cancelled'.tr()),
            ],
            // unselectedLabelColor: Colors.black,
            // labelColor: Colors.black,
            // indicator: DotIndicator(
            //   // color: Colors.black,
            //   distanceFromCenter: 16,
            //   radius: 3,
            //   paintingStyle: PaintingStyle.fill,
            // ),
          ),
        ),
        body: const TabBarView(
          children: [
            AllOrders(
              status: 'All',
            ),
            AllOrders(
              status: 'Received',
            ),
            AllOrders(
              status: 'Processing',
            ),
            AllOrders(
              status: 'Completed',
            ),
          ],
        ),
      ),
    );
  }
}
