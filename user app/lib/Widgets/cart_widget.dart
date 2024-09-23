import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/cart_model.dart';
import 'package:user_app/Model/constant.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Widgets/cat_image_widget.dart';
import 'package:user_app/Widgets/quantity_button.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  List<CartModel> products = [];
  // List<CartModel> productsFilter = [];
  bool isLoaded = false;
  num quantity = 0;
  String currency = '';
  num totalPrice = 0;
  num deliveryFee = 0;
  bool isCouponActive = false;
  String coupon = '';

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Cart')
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      products.clear();
      for (var element in event.docs) {
        var prods = CartModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
          quantity = products.fold(0, (all, product) => all + product.quantity);
          totalPrice =
              products.fold(0, (result, product) => result + product.price);
        });
      }
    });
  }

  bool isLogged = false;
  getAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
        });
      } else {
        setState(() {
          isLogged = true;
        });
        getProducts();
      }
    });
  }

  @override
  void initState() {
    getCouponStatus();
    getProducts();
    getAuth();
    getDeliveryFee();
    getCurrency();
    super.initState();
  }

  Future<void> deleteCart(
      String id, String productname, String selectedUnit) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    firestore
        .collection('users')
        .doc(user!.uid)
        .collection('Cart')
        .doc('$productname$selectedUnit')
        .delete()
        .then((value) {
      setState(() {
        // carts.remove(id);
        quantity =
            products.fold(0, (result, product) => result + product.quantity);
      });

      const SnackBar(
        content: Text('Product has been removed'),
      );
    });
  }

  getCurrency() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currency = value['Currency symbol'];
      });
    });
  }

  getDeliveryFee() {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc('Admin')
        .snapshots()
        .listen((event) {
      setState(() {
        deliveryFee = event['Delivery Fee'];
      });
    });
  }

  getCouponStatus() {
    FirebaseFirestore.instance
        .collection('Coupons')
        .snapshots()
        .listen((event) {
      if (event.docs.isEmpty) {
        setState(() {
          isCouponActive = false;
        });
      } else {
        setState(() {
          isCouponActive = true;
        });
      }
    });
  }

  getCoupon(String couponCode) {
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('Coupons')
        .where('coupon', isEqualTo: couponCode)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var item in value.docs) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          User? user = auth.currentUser;
          FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .update({'Coupon Reward': item['percentage']});
          Fluttertoast.showToast(
                  msg: "Coupon reward added to your cart.".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  fontSize: 14.0)
              .then((value) {
            context.loaderOverlay.hide();
            context.push('/checkout');
            context.pop();
          });
        }
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "Wrong coupon number.".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLogged == false
            ? Text(
                'Cart',
                style: TextStyle(
                    fontSize: 15, color: appColor, fontWeight: FontWeight.bold),
              ).tr()
            : Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 20,
                    color: appColor,
                  ),
                  Text(
                    '$quantity items',
                    style: TextStyle(
                        fontSize: 15,
                        color: appColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
        actions: [
          IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.close,
                color: appColor,
              ))
        ],
      ),
      body: isLogged == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.remove_shopping_cart_outlined,
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
                        context.pop();
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
          : SingleChildScrollView(
              child: Column(
                children: [
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
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
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
                                    Icons.remove_shopping_cart_outlined,
                                    color: appColor,
                                    size: MediaQuery.of(context).size.width >=
                                            1100
                                        ? MediaQuery.of(context).size.width / 5
                                        : MediaQuery.of(context).size.width /
                                            1.5,
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
                                        context.pop();
                                      } else {
                                        context.push('/login');
                                      }
                                    },
                                    child: Text(
                                      products.isEmpty
                                          ? 'Continue Shopping'
                                          : 'Login to continue',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ).tr())
                              ],
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                CartModel cartModel = products[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.width >=
                                            1100
                                        ? 120
                                        : 135,
                                    width: double.infinity,
                                    child: InkWell(
                                      onTap: () {
                                        context.push(
                                            '/product-detail/${cartModel.productID}');
                                        context.pop();
                                      },
                                      child: Card(
                                        elevation: 0,
                                        surfaceTintColor: Colors.white,
                                        color: AdaptiveTheme.of(context)
                                                    .mode
                                                    .isDark ==
                                                true
                                            ? Colors.black
                                            : Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 3,
                                                  child: CatImageWidget(
                                                    url: cartModel.image1,
                                                    boxFit: 'cover',
                                                  )),
                                              const Gap(20),
                                              Expanded(
                                                flex: 5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      cartModel.name,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const Gap(5),
                                                    Text(
                                                      '$currency${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const Gap(8),
                                                    QuantityButton(
                                                      selectedPrice: cartModel
                                                          .selectedPrice,
                                                      productID:
                                                          cartModel.productID,
                                                      cartID:
                                                          '${cartModel.name}${cartModel.selected}',
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Gap(20),
                                              Expanded(
                                                  flex: 2,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        deleteCart(
                                                            cartModel.productID,
                                                            cartModel.name,
                                                            cartModel.selected);
                                                      },
                                                      icon: const Icon(
                                                          Icons.close)))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  color: Color.fromARGB(255, 225, 224, 224),
                                  indent: 20,
                                  endIndent: 20,
                                );
                              },
                            ),
                  if (MediaQuery.of(context).size.width >= 1100) const Gap(150),
                  if (MediaQuery.of(context).size.width <= 1100) const Gap(200),
                  if (isCouponActive == true) const Gap(50),
                ],
              ),
            ),
      bottomSheet: isLogged == false || products.isEmpty
          ? null
          : Container(
              height: (MediaQuery.of(context).size.width >= 1100 ? 150 : 200),
              //  +
              //     (isCouponActive == true ? 50 : 0),
              width: double.infinity,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.black
                      : Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Gap(10),
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 20, right: 20)
                        : const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Fee',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        Text(
                          '$currency${Formatter().converter(deliveryFee.toDouble())}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 20, right: 20)
                        : const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sub Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        Text(
                          '$currency${Formatter().converter(totalPrice.toDouble())}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 20, right: 20)
                        : const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        Text(
                          '$currency${Formatter().converter((totalPrice + deliveryFee).toDouble())}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  // if (isCouponActive == true)
                  //   Padding(
                  //     padding: MediaQuery.of(context).size.width >= 1100
                  //         ? const EdgeInsets.only(left: 20, right: 20)
                  //         : const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Expanded(
                  //           flex: 2,
                  //           child: const Text(
                  //             'Coupon Code',
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //           ).tr(),
                  //         ),
                  //         Expanded(
                  //             flex: 5,
                  //             child: SizedBox(
                  //               height: 40,
                  //               child: TextField(
                  //                 onChanged: (v) {
                  //                   setState(() {
                  //                     coupon = v;
                  //                   });
                  //                 },
                  //                 decoration: const InputDecoration(
                  //                     border: OutlineInputBorder()),
                  //               ),
                  //             ))
                  //       ],
                  //     ),
                  //   ),
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 20, right: 20)
                        : const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appColor,
                              shape: const BeveledRectangleBorder()),
                          onPressed: () {
                            if (coupon.isEmpty) {
                              context.push('/checkout');
                              context.pop();
                            } else {
                              getCoupon(coupon);
                            }
                          },
                          child: const Text(
                            'Check Out',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  if (MediaQuery.of(context).size.width <= 1100) const Gap(10)
                ],
              ),
            ),
    );
  }
}
