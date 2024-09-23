import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/Model/order_model.dart';
import 'package:user_app/Widgets/return_product_widget.dart';

class ReturnProductPage extends StatefulWidget {
  final String userID;
  final String orderID;
  final OrdersList ordersList;

  const ReturnProductPage({
    super.key,
    required this.userID,
    required this.orderID,
    required this.ordersList,
  });

  @override
  State<ReturnProductPage> createState() => _ReturnProductPageState();
}

class _ReturnProductPageState extends State<ReturnProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width >= 1100 ? null : AppBar(),
      body: MediaQuery.of(context).size.width >= 1100
          ? Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Image.network(
                          'https://cdn.redstagfulfillment.com/wp-content/uploads/ecommerce-returns_header-1024x693.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          scale: 1,
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: SizedBox(
                              child: ReturnProductWidget(
                            userID: widget.userID,
                            orderID: widget.orderID,
                            ordersList: widget.ordersList,
                          )))
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      context.push('/');
                    },
                    child: Image.asset(
                      'assets/image/new logo.png',
                      scale: 17,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: ReturnProductWidget(
              userID: widget.userID,
              orderID: widget.orderID,
              ordersList: widget.ordersList,
            )),
    );
  }
}
