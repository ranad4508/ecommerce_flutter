import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:rider_app/Model/constant.dart';

class QuantityButton extends StatefulWidget {
  final String cartID;
  final String productID;
  final num selectedPrice;
  const QuantityButton(
      {super.key,
      required this.cartID,
      required this.productID,
      required this.selectedPrice});

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  bool isLoaded = false;
  num quantity = 0;
  num productQuantity = 0;
  getProductQuantity() {
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productID)
        .snapshots()
        .listen((event) {
      setState(() {
        productQuantity = event['quantity'];
      });
    });
  }

  getQuantity() {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Cart')
        .doc(widget.cartID)
        .snapshots()
        .listen((event) {
      setState(() {
        quantity = event['quantity'];
      });
    });
  }

  addQuantity() {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Cart')
        .doc(widget.cartID)
        .update({
      'quantity': quantity + 1,
      'price': widget.selectedPrice * (quantity + 1)
    });
  }

  removeQuantity() {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Cart')
        .doc(widget.cartID)
        .update({
      'quantity': quantity - 1,
      'price': widget.selectedPrice * (quantity - 1)
    });
  }

  @override
  void initState() {
    getQuantity();
    getProductQuantity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                if (quantity <= 1) {
                  Fluttertoast.showToast(
                      msg: "You can't go below this quantity".tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {
                  removeQuantity();
                }
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
                child: const Center(
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
        const Gap(5),
        Expanded(
            flex: 5,
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(
                width: 1,
              )),
              child: Center(
                child: Text(quantity.toString()),
              ),
            )),
        const Gap(5),
        Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                if (quantity >= productQuantity) {
                  Fluttertoast.showToast(
                      msg: 'This is the available quantity'.tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      fontSize: 14.0);
                } else {
                  addQuantity();
                }
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
