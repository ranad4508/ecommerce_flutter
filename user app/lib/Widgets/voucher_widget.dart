import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/coupon.dart';

import '../Model/constant.dart';

class VoucherWidget extends StatefulWidget {
  const VoucherWidget({super.key});

  @override
  State<VoucherWidget> createState() => _VoucherWidgetState();
}

class _VoucherWidgetState extends State<VoucherWidget> {
  List<CouponModel> products = [];
  // List<CouponModel> productsFilter = [];
  bool isLoaded = false;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });

    FirebaseFirestore.instance
        .collection('Coupons')
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      products.clear();
      for (var element in event.docs) {
        var prods = CouponModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
        });
      }
    });
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xfff1e3d3);
    const Color secondaryColor = Color(0xffd88c9a);
    return SingleChildScrollView(
      child: Column(children: [
        isLoaded == true
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Card(
                      elevation: 2.0,
                      margin: MediaQuery.of(context).size.width >= 1100
                          ? const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0)
                          : const EdgeInsets.all(8),
                      child: Container(
                        height: 150.0,
                        // Customize your shimmering content here
                        // For simplicity, a Container with a solid color is used.
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              )
            : products.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          Icons.card_giftcard_rounded,
                          color: appColor,
                          size: MediaQuery.of(context).size.width >= 1100
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 1.5,
                        ),
                      ),
                      const Gap(20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const BeveledRectangleBorder(),
                              backgroundColor: appColor),
                          onPressed: () {
                            if (products.isEmpty) {
                              context.push('/');
                              //  context.pop();
                            } else {
                              context.push('/login');
                            }
                          },
                          child: Text(
                            products.isEmpty
                                ? 'Continue Shopping'
                                : 'Login to continue',
                            style: const TextStyle(color: Colors.white),
                          ).tr())
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      CouponModel cartModel = products[index];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CouponCard(
                            height: MediaQuery.of(context).size.width >= 1100
                                ? 200
                                : 150,
                            backgroundColor: primaryColor,
                            clockwise: true,
                            curvePosition: 135,
                            curveRadius: 30,
                            curveAxis: Axis.vertical,
                            borderRadius: 10,
                            firstChild: Container(
                              decoration: const BoxDecoration(
                                color: secondaryColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${cartModel.percentage}%',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'OFF',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ).tr(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                      color: Colors.white54, height: 0),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        cartModel.title!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            secondChild: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Coupon Code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ).tr(),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () {
                                      FlutterClipboard.copy(cartModel.coupon)
                                          // ignore: avoid_print
                                          .then((value) =>
                                              // ignore: avoid_print
                                              print('copied'));
                                      Fluttertoast.showToast(
                                          msg: "Coupon code has been copied"
                                              .tr(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 14.0);
                                    },
                                    child: Text(
                                      cartModel.coupon,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    cartModel.timeCreated,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
      ]),
    );
  }
}
