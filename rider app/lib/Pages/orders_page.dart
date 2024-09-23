import 'package:flutter/material.dart';
//import 'package:rider_app/Widgets/footer_widget.dart';
import 'package:rider_app/Widgets/orders_widget.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return const OrdersWidget();
  }
}
