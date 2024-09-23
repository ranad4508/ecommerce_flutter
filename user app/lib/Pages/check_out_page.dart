import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:isoweek/isoweek.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/cart_model.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/history.dart';
import 'package:user_app/Model/order_model.dart';
import 'package:user_app/Model/pickup_address_model.dart';
import 'package:user_app/Widgets/cat_image_widget.dart';
import 'package:uuid/uuid.dart';

import '../Model/constant.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<CartModel> products = [];
  // List<CartModel> productsFilter = [];
  bool isLoaded = false;
  num quantity = 0;
  String currency = '';
  num totalPrice = 0;
  num deliveryFee = 0;
  bool isCouponActive = false;
  String coupon = '';
  String selectedDelivery = 'Delivery';
  String deliveryAddress = '';
  String houseNumber = '';
  String closesBusStop = '';
  String pickupAddress = '';
  String pickupPhone = '';
  String pickupStorename = '';
  num total = 0;
  List<PickupAddressModel> pickupAddresses = [];
  String? selectedPayment;
  num wallet = 0;
  bool isLoading = true;
  bool cashOnDelivery = false;
  num couponPercentage = 0;
  String couponTitle = '';
  String userID = '';
  List<Map<String, dynamic>> orders = [];
  String uid = '';

  getWallet() {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        userID = user.uid;
        isLoading = false;
        wallet = event['wallet'];
      });
      //  print('Fullname is $fullName');
    });
  }

  getCashOnDelivery() {
    FirebaseFirestore.instance
        .collection('Payment System')
        .doc('Cash on delivery')
        .snapshots()
        .listen((event) {
      setState(() {
        cashOnDelivery = event['Cash on delivery'];
      });
    });
  }

  updateWallet() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'wallet': wallet - total}).then((value) {
      // Get the current date and time
      DateTime now = DateTime.now();

      // Format the date to '24th January, 2024' format
      String formattedDate = DateFormat('d MMMM, y').format(now);
      history(HistoryModel(
          message: 'Debit Alert',
          amount: total.toString(),
          paymentSystem: 'Wallet',
          timeCreated: formattedDate));
      // Fluttertoast.showToast(
      //         msg: "Wallet has been uploaded successfully".tr(),
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.TOP,
      //         timeInSecForIosWeb: 1,
      //         fontSize: 14.0)
      //     .then((value) {
      //   Navigator.pop(context);
      // });
    });
  }

  history(HistoryModel historyModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Transaction History')
        .add(historyModel.toMap());
  }

  getPickUpAddress() async {
    setState(() {
      isLoaded = true;
    });

    FirebaseFirestore.instance
        .collection('Pickup Address')
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      pickupAddresses.clear();
      for (var element in event.docs) {
        var prods = PickupAddressModel.fromMap(element.data(), element.id);
        setState(() {
          pickupAddresses.add(prods);
        });
      }
    });
  }

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
        .get()
        .then((event) {
      setState(() {
        userID = user.uid;
        isLoaded = false;
      });
      products.clear();
      orders.clear();

      for (var element in event.docs) {
        var prods = CartModel.fromMap(element, element.id);
        //  var orderVar = OrdersList(
        //     productName: element['name'],
        //     status: 'Received',
        //     id: element.id,
        //     returnDuration: element['returnDuration'],
        //     selected: element['selected'],
        //     productID: element['productID'],
        //     image: element['image1'],
        //     totalRating: element['totalRating'],
        //     totalNumberOfUserRating: element['totalNumberOfUserRating'],
        //     selectedPrice: element['selectedPrice'],
        //     category: element['category'],
        //     quantity: element['quantity']);
        orders.add({
          'receivedDate': null,
          'name': element['name'],
          'status': 'Received',
          'id': element.id,
          'returnDuration': element['returnDuration'],
          'selected': element['selected'],
          'productID': element['productID'],
          'image': element['image1'],
          'totalRating': element['totalRating'],
          'totalNumberOfUserRating': element['totalNumberOfUserRating'],
          'selectedPrice': element['selectedPrice'],
          'category': element['category'],
          'quantity': element['quantity']
        });
        // ignore: avoid_print
        print('Orders are $orders');
        setState(() {
          products.add(prods);
          quantity = products.fold(0, (s, product) => s + product.quantity);
          totalPrice = products.fold(0, (p, product) => p + product.price);
        });
      }
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

  getDeliveryDetails() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        deliveryAddress = event['DeliveryAddress'];
        houseNumber = event['HouseNumber'];
        closesBusStop = event['ClosestBustStop'];
      });
    });
  }

  @override
  void initState() {
    var uuid = const Uuid();

    uid = uuid.v1();
    getProducts();
    getWallet();
    getPickUpAddress();
    getCurrency();
    getDeliveryFee();
    getCashOnDelivery();
    getCouponStatus();
    getDeliveryDetails();
    // getCashOnDelivery();
    super.initState();
  }

  String couponCode = '';
  getCoupon(String couponCode) {
    context.loaderOverlay.show();
    setState(() {
      couponPercentage = 0;
      couponTitle = '';
    });
    FirebaseFirestore.instance
        .collection('Coupons')
        .where('coupon', isEqualTo: couponCode)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var item in value.docs) {
          setState(() {
            couponPercentage = item['percentage'];
            couponTitle = item['title'];
          });
          Fluttertoast.showToast(
                  msg: "Coupon reward added to your cart.".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  fontSize: 14.0)
              .then((value) {
            context.loaderOverlay.hide();
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

  final GlobalKey<ScaffoldState> _scaffoldHome = GlobalKey<ScaffoldState>();

  getPercentageOfCoupon() {
    if (couponPercentage != 0) {
      var result = (total * couponPercentage) / 100;
      return result;
    } else {
      return 0;
    }
  }

  addToOrder(OrderModel orderModel, String uid) {
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(uid)
        .set(orderModel.toMap())
        .then((value) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
              msg: "Your new order has been placed".tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              fontSize: 14.0)
          .then((value) {
        context.push('/orders');
      });
    });
  }

  Future deleteCartCollection() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    firestore
        .collection('users')
        .doc(user!.uid)
        .collection('Cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  enableButton() {
    if (selectedPayment == null) {
      return null;
    } else if (selectedPayment == 'Pay Now' && total > wallet) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    total = totalPrice +
        (selectedDelivery == 'Delivery' ? deliveryFee : 0) -
        getPercentageOfCoupon();
    return Scaffold(
      key: _scaffoldHome,
      endDrawerEnableOpenDragGesture: false,
      endDrawer: selectedDelivery != 'Pickup'
          ? null
          : Drawer(
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              width: MediaQuery.of(context).size.width >= 1100
                  ? MediaQuery.of(context).size.width / 3
                  : double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Pickup Addresses",
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ],
                      ),
                    ),
                    ListView.builder(
                        itemCount: pickupAddresses.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          PickupAddressModel pickupAddressModel =
                              pickupAddresses[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  pickupAddress = pickupAddressModel.address;
                                  pickupPhone = pickupAddressModel.phonenumber;
                                  pickupStorename =
                                      pickupAddressModel.storename;
                                });
                                context.pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: Column(
                                  children: [
                                    const Divider(
                                        color:
                                            Color.fromARGB(255, 236, 227, 227)),
                                    const Gap(10),
                                    ListTile(
                                      visualDensity:
                                          const VisualDensity(vertical: -4),
                                      title: Text(pickupAddressModel.storename),
                                      leading: const Icon(Icons.home),
                                    ),
                                    ListTile(
                                      visualDensity:
                                          const VisualDensity(vertical: -4),
                                      title: Text(pickupAddressModel.address),
                                      leading: const Icon(Icons.room),
                                    ),
                                    ListTile(
                                      visualDensity:
                                          const VisualDensity(vertical: -4),
                                      title:
                                          Text(pickupAddressModel.phonenumber),
                                      leading: const Icon(Icons.phone),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
      appBar: AppBar(
        actions: [Container()],
        // automaticallyImplyLeading: false,
        elevation: 5,
        leadingWidth: MediaQuery.of(context).size.width >= 1100 ? 400 : 100,
        // leading: InkWell(
        //     hoverColor: Colors.transparent,
        //     onTap: () {
        //       context.push('/');
        //     },
        //     child: Image.asset(
        //       'assets/image/new logo.png',
        //       color: AdaptiveTheme.of(context).mode.isDark == true
        //           ? Colors.white
        //           : null,
        //     )),
        title: const Text(
          'Checkout',
          style:
              TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Helvetica'),
        ),
        centerTitle: true,
      ),
      body: isLoaded == true
          ? MediaQuery.of(context).size.width >= 1100
              ? Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Column(
                    children: [
                      const Gap(50),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 200, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 300, // Set the width as needed
                                      height: 14, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 400, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 250, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 290, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 400, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 600, // Set the width as needed
                                      height: 14, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 700, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 500, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 290, // Set the width as needed
                                      height: 15, // Set the height as needed
                                      color: Colors
                                          .grey, // Set the color as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 600, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 700, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 500, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 290, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                )
          : MediaQuery.of(context).size.width >= 1100
              ? Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(20),
                              Card(
                                shape: const BeveledRectangleBorder(),
                                color: AdaptiveTheme.of(context).mode.isDark ==
                                        true
                                    ? Colors.black
                                    : Colors.white,
                                surfaceTintColor: Colors.white,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: appColor),
                                        child: const Center(
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      title: const Text(
                                        '1. CHOOSE DELIVERY OPTION',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                    ),
                                    Container(
                                      height: 250,
                                      color: selectedDelivery == 'Delivery'
                                          ? const Color.fromARGB(
                                              255, 241, 236, 236)
                                          : null,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RadioListTile(
                                                secondary: InkWell(
                                                    onTap: () {
                                                      context.push(
                                                          '/delivery-addresses');
                                                    },
                                                    child: Text(
                                                      'Change Delivery Address',
                                                      style: TextStyle(
                                                        color: selectedDelivery ==
                                                                    'Delivery' &&
                                                                AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                            ? Colors.black
                                                            : null,
                                                      ),
                                                    ).tr()),
                                                value: 'Delivery',
                                                groupValue: selectedDelivery,
                                                title: Text(
                                                  'Deliver to me',
                                                  style: TextStyle(
                                                      fontFamily: 'Helvetica',
                                                      color: selectedDelivery ==
                                                                  'Delivery' &&
                                                              AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                          ? Colors.black
                                                          : null,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).tr(),
                                                onChanged: (v) {
                                                  setState(() {
                                                    selectedDelivery = v!;
                                                    selectedPayment = null;
                                                  });
                                                }),
                                            const Gap(20),
                                            if (deliveryAddress != '')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      border: Border.all()),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.room),
                                                        title: Text(
                                                          deliveryAddress,
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Delivery' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.home),
                                                        title: Text(
                                                          houseNumber,
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Delivery' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.bus_alert),
                                                        title: Text(
                                                          closesBusStop,
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Delivery' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (deliveryAddress == '')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      border: Border.all()),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.room),
                                                        title: Text(
                                                          "Tap button to add a delivery address",
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Delivery' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      const Gap(20),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 25),
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                shape:
                                                                    const BeveledRectangleBorder(),
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange),
                                                            onPressed: () {
                                                              context.push(
                                                                  '/delivery-addresses');
                                                            },
                                                            child: const Text(
                                                              "Add a delivery address",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ).tr()),
                                                      ),
                                                      const Gap(20),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            const Gap(20),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Text(
                                                'Delivery Fee is $currency${Formatter().converter(deliveryFee.toDouble())}',
                                                style: TextStyle(
                                                  color: selectedDelivery ==
                                                              'Delivery' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            //  const Gap(20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Gap(20),
                                    Container(
                                      height: 250,
                                      color: selectedDelivery == 'Pickup'
                                          ? const Color.fromARGB(
                                              255, 241, 236, 236)
                                          : null,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RadioListTile(
                                                secondary: selectedDelivery ==
                                                            'Pickup' &&
                                                        pickupAddress != ''
                                                    ? InkWell(
                                                        onTap: () {
                                                          _scaffoldHome
                                                              .currentState!
                                                              .openEndDrawer();
                                                        },
                                                        child: Text(
                                                          "Change pickup address",
                                                          style: TextStyle(
                                                            color: selectedDelivery ==
                                                                        'Pickup' &&
                                                                    AdaptiveTheme.of(context)
                                                                            .mode
                                                                            .isDark ==
                                                                        true
                                                                ? Colors.black
                                                                : null,
                                                          ),
                                                        ).tr())
                                                    : null,
                                                value: 'Pickup',
                                                groupValue: selectedDelivery,
                                                title: Text(
                                                  'Pickup from a store',
                                                  style: TextStyle(
                                                      color: selectedDelivery ==
                                                                  'Pickup' &&
                                                              AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                          ? Colors.black
                                                          : null,
                                                      fontFamily: 'Helvetica',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).tr(),
                                                onChanged: (v) {
                                                  setState(() {
                                                    selectedDelivery = v!;
                                                    selectedPayment = null;
                                                  });
                                                }),
                                            const Gap(20),
                                            if (pickupAddress != '')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      border: Border.all()),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.home),
                                                        title: Text(
                                                          pickupStorename,
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Pickup' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.room),
                                                        title: Text(
                                                          pickupAddress,
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Pickup' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.phone),
                                                        title: Text(
                                                          pickupPhone,
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Pickup' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (pickupAddress == '')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      border: Border.all()),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ListTile(
                                                        visualDensity:
                                                            const VisualDensity(
                                                                vertical: -4),
                                                        leading: const Icon(
                                                            Icons.room),
                                                        title: Text(
                                                          "Tap button to select pickup address",
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Pickup' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      const Gap(20),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 25),
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                shape:
                                                                    const BeveledRectangleBorder(),
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange),
                                                            onPressed: () {
                                                              _scaffoldHome
                                                                  .currentState!
                                                                  .openEndDrawer();
                                                            },
                                                            child: const Text(
                                                              "Select pickup address",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ).tr()),
                                                      ),
                                                      const Gap(20),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Gap(20),
                              Card(
                                shape: const BeveledRectangleBorder(),
                                color: AdaptiveTheme.of(context).mode.isDark ==
                                        true
                                    ? Colors.black
                                    : Colors.white,
                                surfaceTintColor: Colors.white,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: appColor),
                                          child: const Center(
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        title: const Text(
                                          '2. CHOOSE A PAYMENT OPTION',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ).tr(),
                                      ),
                                      Container(
                                        height: selectedPayment == 'Pay Now'
                                            ? 250
                                            : null,
                                        color: selectedPayment == 'Pay Now'
                                            ? const Color.fromARGB(
                                                255, 241, 236, 236)
                                            : null,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RadioListTile(
                                                  // secondary: Text(
                                                  //     'Wallet Balance is $currency${Formatter().converter(wallet.toDouble())}'),
                                                  value: 'Pay Now',
                                                  groupValue: selectedPayment,
                                                  title: const Text(
                                                    'Pay Now',
                                                    style: TextStyle(
                                                        fontFamily: 'Helvetica',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ).tr(),
                                                  onChanged: (v) {
                                                    if (selectedDelivery ==
                                                        'Delivery') {
                                                      setState(() {
                                                        selectedPayment = v!;
                                                      });
                                                    } else {
                                                      if (pickupAddress
                                                          .isEmpty) {
                                                        Fluttertoast.showToast(
                                                            msg: "Please select a pickup address."
                                                                .tr(),
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .TOP,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            fontSize: 14.0);
                                                      } else {
                                                        setState(() {
                                                          selectedPayment = v!;
                                                        });
                                                      }
                                                    }
                                                  }),
                                              const Gap(20),
                                              if (selectedPayment == 'Pay Now')
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                        border: Border.all()),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ListTile(
                                                          visualDensity:
                                                              const VisualDensity(
                                                                  vertical: -4),
                                                          leading: const Icon(
                                                              Icons.wallet),
                                                          title: total <= wallet
                                                              ? const Text(
                                                                      'Continue to process payment')
                                                                  .tr()
                                                              : const Text(
                                                                  "Tap button to upload money to wallet",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ).tr(),
                                                        ),
                                                        const Gap(20),
                                                        if (total <= wallet)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 25),
                                                            child: Text(
                                                                'Wallet balance will be $currency${Formatter().converter(wallet.toDouble())}- $currency${Formatter().converter(total.toDouble())} = $currency${Formatter().converter((wallet - total).toDouble())}'),
                                                          ),
                                                        if (total > wallet)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 25),
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        shape:
                                                                            const BeveledRectangleBorder(),
                                                                        backgroundColor:
                                                                            Colors
                                                                                .orange),
                                                                    onPressed:
                                                                        () {
                                                                      context.push(
                                                                          '/wallet');
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Upload Money To Wallet",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ).tr()),
                                                          ),
                                                        const Gap(20),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Gap(20),
                                      if (cashOnDelivery == true)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50),
                                          child: RadioListTile(
                                              value: 'Cash On Delivery',
                                              groupValue: selectedPayment,
                                              title: const Text(
                                                'Cash On Delivery',
                                                style: TextStyle(
                                                    fontFamily: 'Helvetica',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ).tr(),
                                              onChanged: (v) {
                                                if (selectedDelivery ==
                                                    'Delivery') {
                                                  setState(() {
                                                    selectedPayment = v!;
                                                  });
                                                } else {
                                                  if (pickupAddress.isEmpty) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please select a pickup address."
                                                                .tr(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 1,
                                                        fontSize: 14.0);
                                                  } else {
                                                    setState(() {
                                                      selectedPayment = v!;
                                                    });
                                                  }
                                                }
                                              }),
                                        ),
                                      const Gap(20),
                                      if (isCouponActive == true)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50),
                                          child: const Text(
                                            'Add Voucher Code',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ).tr(),
                                        ),
                                      if (isCouponActive == true) const Gap(5),
                                      if (isCouponActive == true)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50),
                                          child: const Text(
                                            'Do you have a voucher? Enter the voucher code below',
                                            style: TextStyle(),
                                          ).tr(),
                                        ),
                                      if (isCouponActive == true)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50,
                                              right: 50,
                                              top: 20,
                                              bottom: 20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 7,
                                                child: TextField(
                                                  onChanged: (v) {
                                                    setState(() {
                                                      couponCode = v;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      border:
                                                          const OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .zero),
                                                      hintText:
                                                          'Add Voucher / Gift Card'
                                                              .tr()),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    height: 55,
                                                    // width: 70,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange,
                                                                shape:
                                                                    const BeveledRectangleBorder()),
                                                        onPressed: () {
                                                          getCoupon(couponCode);
                                                        },
                                                        child: const Text(
                                                          'Apply',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ).tr()),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      const Gap(30),
                                      // if ()
                                      Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: appColor,
                                                  shape:
                                                      const BeveledRectangleBorder()),
                                              onPressed: selectedPayment ==
                                                          null ||
                                                      (selectedPayment ==
                                                              'Pay Now' &&
                                                          total > wallet)
                                                  ? null
                                                  : () {
                                                      Random random = Random();
                                                      var result = '';

                                                      for (int i = 0;
                                                          i < 9;
                                                          i++) {
                                                        // Generate a random digit from 0 to 9
                                                        int digit =
                                                            random.nextInt(10);

                                                        // Append the digit to the result string
                                                        result +=
                                                            digit.toString();
                                                      }

                                                      Week currentWeek =
                                                          Week.current();

                                                      // Get the current date and time
                                                      var day = DateTime.now();
                                                      var dateDay =
                                                          DateTime.now().day;
                                                      var month =
                                                          DateTime.now();
                                                      // Format the date as a string
                                                      String formattedDate =
                                                          DateFormat('MMMM')
                                                              .format(month);
                                                      String dayFormatter =
                                                          DateFormat('EEEE')
                                                              .format(day);
                                                      deleteCartCollection();

                                                      if (selectedDelivery ==
                                                              'Delivery' &&
                                                          selectedPayment ==
                                                              'Pay Now') {
                                                        updateWallet();
                                                      }
                                                      addToOrder(
                                                          OrderModel(
                                                              confirmationStatus:
                                                                  false,
                                                              marketID: '',
                                                              couponTitle:
                                                                  couponTitle,
                                                              couponPercentage:
                                                                  couponPercentage,
                                                              useCoupon: couponTitle
                                                                      .isEmpty
                                                                  ? false
                                                                  : true,
                                                              day: dayFormatter,
                                                              instruction: '',
                                                              pickupAddress: selectedDelivery ==
                                                                      'Pickup'
                                                                  ? pickupAddress
                                                                  : '',
                                                              pickupPhone: selectedDelivery ==
                                                                      'Pickup'
                                                                  ? pickupPhone
                                                                  : '',
                                                              pickupStorename:
                                                                  selectedDelivery ==
                                                                          'Pickup'
                                                                      ? pickupStorename
                                                                      : '',
                                                              weekNumber:
                                                                  currentWeek
                                                                      .weekNumber,
                                                              date:
                                                                  '$dayFormatter, $formattedDate $dateDay',
                                                              orderID: result,
                                                              orders: orders,
                                                              uid: uid,
                                                              acceptDelivery:
                                                                  false,
                                                              deliveryFee: selectedDelivery ==
                                                                      'Pickup'
                                                                  ? 0
                                                                  : deliveryFee,
                                                              total: total,
                                                              vendorID: '',
                                                              paymentType:
                                                                  selectedPayment ==
                                                                          'Pay Now'
                                                                      ? 'Wallet'
                                                                      : 'Cash On Delivery',
                                                              userID: userID,
                                                              timeCreated:
                                                                  DateTime
                                                                      .now(),
                                                              deliveryAddress:
                                                                  selectedDelivery ==
                                                                          'Pickup'
                                                                      ? ''
                                                                      : deliveryAddress,
                                                              houseNumber:
                                                                  selectedDelivery ==
                                                                          'Pickup'
                                                                      ? ''
                                                                      : houseNumber,
                                                              closesBusStop:
                                                                  selectedDelivery ==
                                                                          'Pickup'
                                                                      ? ''
                                                                      : closesBusStop,
                                                              deliveryBoyID: '',
                                                              status:
                                                                  'Received',
                                                              accept: false),
                                                          uid);
                                                    },
                                              child: const Text(
                                                'Place Order',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ).tr()),
                                        ),
                                      ),
                                      const Gap(30)
                                    ]),
                              ),
                              const Gap(20),
                            ],
                          ),
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        flex: 2,
                        child: Card(
                          shape: const BeveledRectangleBorder(),
                          color: AdaptiveTheme.of(context).mode.isDark == true
                              ? Colors.black
                              : Colors.white,
                          surfaceTintColor: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Gap(10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Order Detail",
                                        style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                    ],
                                  ),
                                ),
                                const Divider(
                                    color: Color.fromARGB(255, 236, 227, 227)),
                                const Gap(10),
                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    CartModel cartModel = products[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width >=
                                                    1100
                                                ? 90
                                                : 110,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 2,
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
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      cartModel.name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w200),
                                                    ),
                                                    const Gap(10),
                                                    Text(
                                                      '$currency${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const Gap(10),
                                                    Text(
                                                      'Quantity: ${cartModel.quantity}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w200),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider(
                                        color:
                                            Color.fromARGB(255, 236, 227, 227));
                                  },
                                ),
                                const Gap(20),
                                if (selectedDelivery == 'Delivery')
                                  Padding(
                                    padding:
                                        MediaQuery.of(context).size.width >=
                                                1100
                                            ? const EdgeInsets.all(8)
                                            : const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Delivery Fee',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ).tr(),
                                        Text(
                                          '$currency${Formatter().converter(deliveryFee.toDouble())}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding:
                                      MediaQuery.of(context).size.width >= 1100
                                          ? const EdgeInsets.all(8)
                                          : const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Sub Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                      Text(
                                        '$currency${Formatter().converter(totalPrice.toDouble())}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      MediaQuery.of(context).size.width >= 1100
                                          ? const EdgeInsets.all(8)
                                          : const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                      Text(
                                        '$currency${Formatter().converter(total.toDouble())}',
                                        // '$currency${Formatter().converter((totalPrice + (selectedDelivery == 'Delivery' ? deliveryFee : 0)).toDouble())}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              //////////////////////////////// Mobile View /////////////////////////////////////////////
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(20),
                          Card(
                            shape: const BeveledRectangleBorder(),
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black
                                : Colors.white,
                            // surfaceTintColor: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: appColor),
                                    child: const Center(
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  title: const Text(
                                    '1. CHOOSE DELIVERY OPTION',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ).tr(),
                                ),
                                Container(
                                  height: 300,
                                  color: selectedDelivery == 'Delivery'
                                      ? const Color.fromARGB(255, 241, 236, 236)
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RadioListTile(
                                            secondary: InkWell(
                                                onTap: () {
                                                  context.push(
                                                      '/delivery-addresses');
                                                },
                                                child: Text(
                                                  'Change Delivery Address',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: selectedDelivery ==
                                                                'Delivery' &&
                                                            AdaptiveTheme.of(
                                                                        context)
                                                                    .mode
                                                                    .isDark ==
                                                                true
                                                        ? Colors.black
                                                        : null,
                                                  ),
                                                ).tr()),
                                            value: 'Delivery',
                                            groupValue: selectedDelivery,
                                            title: Text(
                                              'Deliver to me',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold,
                                                color: selectedDelivery ==
                                                            'Delivery' &&
                                                        AdaptiveTheme.of(
                                                                    context)
                                                                .mode
                                                                .isDark ==
                                                            true
                                                    ? Colors.black
                                                    : null,
                                              ),
                                            ).tr(),
                                            onChanged: (v) {
                                              setState(() {
                                                selectedDelivery = v!;
                                                selectedPayment = null;
                                              });
                                            }),
                                        const Gap(20),
                                        if (deliveryAddress != '')
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all()),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading:
                                                        const Icon(Icons.room),
                                                    title: Text(
                                                      deliveryAddress,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: selectedDelivery ==
                                                                    'Delivery' &&
                                                                AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                            ? Colors.black
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading: Icon(
                                                      Icons.home,
                                                      color: selectedDelivery ==
                                                                  'Delivery' &&
                                                              AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                          ? Colors.black
                                                          : null,
                                                    ),
                                                    title: Text(
                                                      houseNumber,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: selectedDelivery ==
                                                                    'Delivery' &&
                                                                AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                            ? Colors.black
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading: Icon(
                                                      Icons.bus_alert,
                                                      color: selectedDelivery ==
                                                                  'Delivery' &&
                                                              AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark ==
                                                                  true
                                                          ? Colors.black
                                                          : null,
                                                    ),
                                                    title: Text(
                                                      closesBusStop,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: selectedDelivery ==
                                                                    'Delivery' &&
                                                                AdaptiveTheme.of(
                                                                            context)
                                                                        .mode
                                                                        .isDark ==
                                                                    true
                                                            ? Colors.black
                                                            : null,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (deliveryAddress == '')
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all()),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading:
                                                        const Icon(Icons.room),
                                                    title: Text(
                                                      "Tap button to add a delivery address",
                                                      style: TextStyle(
                                                          color: selectedDelivery ==
                                                                      'Delivery' &&
                                                                  AdaptiveTheme.of(
                                                                              context)
                                                                          .mode
                                                                          .isDark ==
                                                                      true
                                                              ? Colors.black
                                                              : null,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  const Gap(20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    const BeveledRectangleBorder(),
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange),
                                                        onPressed: () {
                                                          context.push(
                                                              '/delivery-addresses');
                                                        },
                                                        child: const Text(
                                                          "Add a delivery address",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ).tr()),
                                                  ),
                                                  const Gap(20),
                                                ],
                                              ),
                                            ),
                                          ),
                                        const Gap(20),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            'Delivery Fee is $currency${Formatter().converter(deliveryFee.toDouble())}',
                                            style: TextStyle(
                                              color: selectedDelivery ==
                                                          'Delivery' &&
                                                      AdaptiveTheme.of(context)
                                                              .mode
                                                              .isDark ==
                                                          true
                                                  ? Colors.black
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        //  const Gap(20),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(20),
                                Container(
                                  height: 300,
                                  color: selectedDelivery == 'Pickup'
                                      ? const Color.fromARGB(255, 241, 236, 236)
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RadioListTile(
                                            secondary:
                                                selectedDelivery == 'Pickup' &&
                                                        pickupAddress != ''
                                                    ? InkWell(
                                                        onTap: () {
                                                          _scaffoldHome
                                                              .currentState!
                                                              .openEndDrawer();
                                                        },
                                                        child: Text(
                                                          "Change pickup address",
                                                          style: TextStyle(
                                                              color: selectedDelivery ==
                                                                          'Pickup' &&
                                                                      AdaptiveTheme.of(context)
                                                                              .mode
                                                                              .isDark ==
                                                                          true
                                                                  ? Colors.black
                                                                  : null,
                                                              fontSize: 10),
                                                        ).tr())
                                                    : null,
                                            value: 'Pickup',
                                            groupValue: selectedDelivery,
                                            title: Text(
                                              'Pickup from a store',
                                              style: TextStyle(
                                                  color: selectedDelivery ==
                                                              'Pickup' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,
                                                  fontSize: 12,
                                                  fontFamily: 'Helvetica',
                                                  fontWeight: FontWeight.bold),
                                            ).tr(),
                                            onChanged: (v) {
                                              setState(() {
                                                selectedDelivery = v!;
                                                selectedPayment = null;
                                              });
                                            }),
                                        const Gap(20),
                                        if (pickupAddress != '')
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all()),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading:
                                                        Icon(Icons.home,  color: selectedDelivery ==
                                                              'Pickup' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,),
                                                    title: Text(
                                                      pickupStorename,
                                                      maxLines: 2,
                                                      style:TextStyle(
                                                          color: selectedDelivery ==
                                                              'Pickup' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading:
                                                       Icon(Icons.room,  color: selectedDelivery ==
                                                              'Pickup' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,),
                                                    title: Text(
                                                      pickupAddress,
                                                      maxLines: 2,
                                                      style:  TextStyle(
                                                          color: selectedDelivery ==
                                                              'Pickup' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading:
                                                        const Icon(Icons.phone),
                                                    title: Text(
                                                      pickupPhone,
                                                      maxLines: 2,
                                                      style:  TextStyle(
                                                          color: selectedDelivery ==
                                                              'Pickup' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (pickupAddress == '')
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all()),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                 ListTile(
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                    leading: const Icon(Icons.room),
                                                    title: Text(
                                                      "Tap button to select pickup address",
                                                      style: TextStyle(
                                                          color: selectedDelivery ==
                                                              'Pickup' &&
                                                          AdaptiveTheme.of(
                                                                      context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                      ? Colors.black
                                                      : null,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  const Gap(20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shape:
                                                                    const BeveledRectangleBorder(),
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange),
                                                        onPressed: () {
                                                          _scaffoldHome
                                                              .currentState!
                                                              .openEndDrawer();
                                                        },
                                                        child: const Text(
                                                          "Select pickup address",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ).tr()),
                                                  ),
                                                  const Gap(20),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(20),
                          Card(
                            shape: const BeveledRectangleBorder(),
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.black
                                : Colors.white,
                            surfaceTintColor: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: appColor),
                                      child: const Center(
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    title: const Text(
                                      '2. CHOOSE A PAYMENT OPTION',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ).tr(),
                                  ),
                                  Container(
                                    height: selectedPayment == 'Pay Now'
                                        ? 250
                                        : null,
                                    color: selectedPayment == 'Pay Now'
                                        ? const Color.fromARGB(
                                            255, 241, 236, 236)
                                        : null,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RadioListTile(
                                              // secondary: Text(
                                              //     'Wallet Balance is $currency${Formatter().converter(wallet.toDouble())}'),
                                              value: 'Pay Now',
                                              groupValue: selectedPayment,
                                              title: const Text(
                                                'Pay Now',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Helvetica',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ).tr(),
                                              onChanged: (v) {
                                                if (selectedDelivery ==
                                                    'Delivery') {
                                                  setState(() {
                                                    selectedPayment = v!;
                                                  });
                                                } else {
                                                  if (pickupAddress.isEmpty) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please select a pickup address."
                                                                .tr(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 1,
                                                        fontSize: 14.0);
                                                  } else {
                                                    setState(() {
                                                      selectedPayment = v!;
                                                    });
                                                  }
                                                }
                                              }),
                                          const Gap(20),
                                          if (selectedPayment == 'Pay Now')
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all()),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4),
                                                      leading: const Icon(
                                                          Icons.wallet),
                                                      title: total <= wallet
                                                          ? const Text(
                                                              'Continue to process payment',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ).tr()
                                                          : const Text(
                                                              "Tap button to upload money to wallet",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ).tr(),
                                                    ),
                                                    const Gap(20),
                                                    if (total <= wallet)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 25),
                                                        child: Text(
                                                          'Wallet balance will be $currency${Formatter().converter(wallet.toDouble())}- $currency${Formatter().converter(total.toDouble())} = $currency${Formatter().converter((wallet - total).toDouble())}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        ),
                                                      ),
                                                    if (total > wallet)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 25),
                                                        child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                shape:
                                                                    const BeveledRectangleBorder(),
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange),
                                                            onPressed: () {
                                                              context.push(
                                                                  '/wallet');
                                                            },
                                                            child: const Text(
                                                              "Upload Money To Wallet",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ).tr()),
                                                      ),
                                                    const Gap(20),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //  const Gap(20),
                                  if (cashOnDelivery == true)
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: RadioListTile(
                                          value: 'Cash On Delivery',
                                          groupValue: selectedPayment,
                                          title: const Text(
                                            'Cash On Delivery',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold),
                                          ).tr(),
                                          onChanged: (v) {
                                            if (selectedDelivery ==
                                                'Delivery') {
                                              setState(() {
                                                selectedPayment = v!;
                                              });
                                            } else {
                                              if (pickupAddress.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please select a pickup address."
                                                            .tr(),
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    fontSize: 14.0);
                                              } else {
                                                setState(() {
                                                  selectedPayment = v!;
                                                });
                                              }
                                            }
                                          }),
                                    ),
                                  const Gap(20),
                                  if (isCouponActive == true)
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'Add Voucher Code',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                    ),
                                  if (isCouponActive == true) const Gap(5),
                                  if (isCouponActive == true)
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'Do you have a voucher? Enter the voucher code below',
                                        style: TextStyle(),
                                      ).tr(),
                                    ),
                                  if (isCouponActive == true)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: SizedBox(
                                              height: 40,
                                              child: TextField(
                                                onChanged: (v) {
                                                  setState(() {
                                                    couponCode = v;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    hintStyle: const TextStyle(
                                                        fontSize: 13),
                                                    border:
                                                        const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .zero),
                                                    hintText:
                                                        'Add Voucher / Gift Card'
                                                            .tr()),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 3,
                                              child: SizedBox(
                                                height: 40,
                                                // width: 70,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            appColor,
                                                        shape:
                                                            const BeveledRectangleBorder()),
                                                    onPressed: () {
                                                      getCoupon(couponCode);
                                                    },
                                                    child: const Text(
                                                      'Apply',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ).tr()),
                                              ))
                                        ],
                                      ),
                                    ),
                                  const Gap(30),
                                ]),
                          ),
                          // const Gap(20),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Order Detail",
                              style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ],
                        ),
                      ),
                      const Divider(color: Color.fromARGB(255, 236, 227, 227)),
                      const Gap(10),
                      ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          CartModel cartModel = products[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width >= 1100
                                  ? 90
                                  : 90,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
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
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cartModel.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          const Gap(10),
                                          Text(
                                            '$currency${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Gap(10),
                                          Text(
                                            'Quantity: ${cartModel.quantity}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w200),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                              color: Color.fromARGB(255, 236, 227, 227));
                        },
                      ),
                      const Gap(20),
                      if (selectedDelivery == 'Delivery')
                        Padding(
                          padding: MediaQuery.of(context).size.width >= 1100
                              ? const EdgeInsets.all(8)
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      Padding(
                        padding: MediaQuery.of(context).size.width >= 1100
                            ? const EdgeInsets.all(8)
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: MediaQuery.of(context).size.width >= 1100
                            ? const EdgeInsets.all(8)
                            : const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ).tr(),
                            Text(
                              '$currency${Formatter().converter(total.toDouble())}',
                              // '$currency${Formatter().converter((totalPrice + (selectedDelivery == 'Delivery' ? deliveryFee : 0)).toDouble())}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      // if ()
                      const Gap(30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: appColor,
                                  shape: const BeveledRectangleBorder()),
                              onPressed: selectedPayment == null ||
                                      (selectedPayment == 'Pay Now' &&
                                          total > wallet)
                                  ? null
                                  : () {
                                      Random random = Random();
                                      var result = '';

                                      for (int i = 0; i < 9; i++) {
                                        // Generate a random digit from 0 to 9
                                        int digit = random.nextInt(10);

                                        // Append the digit to the result string
                                        result += digit.toString();
                                      }

                                      Week currentWeek = Week.current();

                                      // Get the current date and time
                                      var day = DateTime.now();
                                      var dateDay = DateTime.now().day;
                                      var month = DateTime.now();
                                      // Format the date as a string
                                      String formattedDate =
                                          DateFormat('MMMM').format(month);
                                      String dayFormatter =
                                          DateFormat('EEEE').format(day);
                                      deleteCartCollection();

                                      if (selectedDelivery == 'Delivery' &&
                                          selectedPayment == 'Pay Now') {
                                        updateWallet();
                                      }
                                      addToOrder(
                                          OrderModel(
                                              confirmationStatus: false,
                                              marketID: '',
                                              couponTitle: couponTitle,
                                              couponPercentage:
                                                  couponPercentage,
                                              useCoupon: couponTitle.isEmpty
                                                  ? false
                                                  : true,
                                              day: dayFormatter,
                                              instruction: '',
                                              pickupAddress:
                                                  selectedDelivery == 'Pickup'
                                                      ? pickupAddress
                                                      : '',
                                              pickupPhone:
                                                  selectedDelivery == 'Pickup'
                                                      ? pickupPhone
                                                      : '',
                                              pickupStorename:
                                                  selectedDelivery == 'Pickup'
                                                      ? pickupStorename
                                                      : '',
                                              weekNumber:
                                                  currentWeek.weekNumber,
                                              date:
                                                  '$dayFormatter, $formattedDate $dateDay',
                                              orderID: result,
                                              orders: orders,
                                              uid: uid,
                                              acceptDelivery: false,
                                              deliveryFee:
                                                  selectedDelivery == 'Pickup'
                                                      ? 0
                                                      : deliveryFee,
                                              total: total,
                                              vendorID: '',
                                              paymentType:
                                                  selectedPayment == 'Pay Now'
                                                      ? 'Wallet'
                                                      : 'Cash On Delivery',
                                              userID: userID,
                                              timeCreated: DateTime.now(),
                                              deliveryAddress:
                                                  selectedDelivery == 'Pickup'
                                                      ? ''
                                                      : deliveryAddress,
                                              houseNumber:
                                                  selectedDelivery == 'Pickup'
                                                      ? ''
                                                      : houseNumber,
                                              closesBusStop:
                                                  selectedDelivery == 'Pickup'
                                                      ? ''
                                                      : closesBusStop,
                                              deliveryBoyID: '',
                                              status: 'Received',
                                              accept: false),
                                          uid);
                                    },
                              child: const Text(
                                'Place Order',
                                style: TextStyle(color: Colors.white),
                              ).tr()),
                        ),
                      ),
                      const Gap(30)
                    ],
                  ),
                ),
    );
  }
}
