import 'package:animations/animations.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/history.dart';
import 'package:user_app/Model/order_model.dart';
import 'package:user_app/Pages/return_product_page.dart';
import 'package:user_app/Widgets/cat_image_widget.dart';

import '../Model/constant.dart';

class OrderDetailWidget extends StatefulWidget {
  final String uid;
  const OrderDetailWidget({super.key, required this.uid});

  @override
  State<OrderDetailWidget> createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  OrderModel2? orderDetail;
  num quantity = 0;
  num selectedPrice = 0;

  String currency = '';
  bool isLoading = true;
  Future<void> fetchOrderDetail() async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();

    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((doc) {
      context.loaderOverlay.hide();
      setState(() {
        isLoading = false;
        orderDetail = OrderModel2(
          orders: [
            ...(doc.data()!['orders']).map((items) {
              return OrdersList.fromMap(items);
            })
          ],
          pickupStorename: doc.data()!['pickupStorename'],
          pickupPhone: doc.data()!['pickupPhone'],
          pickupAddress: doc.data()!['pickupAddress'],
          instruction: doc.data()!['instruction'],
          couponPercentage: doc.data()!['couponPercentage'],
          couponTitle: doc.data()!['couponTitle'],
          useCoupon: doc.data()!['useCoupon'],
          confirmationStatus: doc.data()!['confirmationStatus'],
          uid: doc.data()!['uid'],
          marketID: doc.data()!['marketID'],
          vendorID: doc.data()!['vendorID'],
          userID: doc.data()!['userID'],
          deliveryAddress: doc.data()!['deliveryAddress'],
          houseNumber: doc.data()!['houseNumber'],
          closesBusStop: doc.data()!['closesBusStop'],
          deliveryBoyID: doc.data()!['deliveryBoyID'],
          status: doc.data()!['status'],
          accept: doc.data()!['accept'],
          orderID: doc.data()!['orderID'],
          timeCreated: doc.data()!['timeCreated'].toDate(),
          total: doc.data()!['total'],
          deliveryFee: doc.data()!['deliveryFee'],
          acceptDelivery: doc.data()!['acceptDelivery'],
          paymentType: doc.data()!['paymentType'],
        );
      });
      setState(() {
        // carts.remove(id);
        quantity = orderDetail!.orders
            .fold(0, (all, product) => all + product.quantity);
        selectedPrice = orderDetail!.orders.fold(
            0,
            (result, product) =>
                result + product.selectedPrice * product.quantity);
      });
    });
    //  for (var element in orderDetail!.orders) {

    //  }
  }

  @override
  initState() {
    super.initState();
    getCurrency();
    fetchOrderDetail();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (MediaQuery.of(context).size.width >= 1100) const Gap(10),
          // //  if (MediaQuery.of(context).size.width >= 1100)
          // Align(
          //   alignment: MediaQuery.of(context).size.width >= 1100
          //       ? Alignment.bottomLeft
          //       : Alignment.center,
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //         left: MediaQuery.of(context).size.width >= 1100 ? 20 : 0),
          //     child: Row(
          //       children: [
          //         InkWell(
          //             onTap: () {
          //               context.push('/orders');
          //             },
          //             child: const Icon(Icons.arrow_back)),
          //         const Gap(20),
          //         Text(
          //           'Order Details',
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: MediaQuery.of(context).size.width >= 1100
          //                   ? 15
          //                   : 15),
          //         ).tr(),
          //       ],
          //     ),
          //   ),
          // ),
          if (MediaQuery.of(context).size.width >= 1100)
            const Divider(
              color: Color.fromARGB(255, 237, 235, 235),
              thickness: 1,
            ),
          // const Gap(20),
          if (isLoading == true)
            MediaQuery.of(context).size.width >= 1100
                ? Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),
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
                        const Gap(20),
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
                  ),
          if (isLoading == false)
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 25, right: 25)
                  : const EdgeInsets.all(8.0),
              child: Result(
                selectedPrice: selectedPrice,
                orderModel2: orderDetail!,
                quantity: quantity,
                currency: currency,
              ),
            )
        ],
      ),
    );
  }
}

class Result extends StatefulWidget {
  final OrderModel2 orderModel2;
  final num quantity;
  final num selectedPrice;
  final String currency;
  const Result(
      {super.key,
      required this.orderModel2,
      required this.quantity,
      required this.currency,
      required this.selectedPrice});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool isLoading = false;
  num wallet = 0;
  DateTime? completedTimeCreated;
  String userID = '';
  String reviewProduct = '';
  num ratingValProduct = 0;
  String name = '';
  getCompletedTimeCreated() {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel2.uid)
        .snapshots()
        .listen((event) {
      if (event['completedTimeCreated'] != null) {
        setState(() {
          completedTimeCreated = event['completedTimeCreated'].toDate();
        });
        // ignore: avoid_print
        print(completedTimeCreated);
        // getExpiryForReturnPolicy(50);
      }
    });
  }

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
        //  userID = user.uid;

        isLoading = false;
        wallet = event['wallet'];
        name = event['fullname'];
      });
      //  print('Fullname is $fullName');
    });
  }

  getExpiryForReturnPolicy(int returnPolicy) {
    if (completedTimeCreated != null) {}
    DateTime fixedDate = DateTime(completedTimeCreated!.year,
        completedTimeCreated!.month, completedTimeCreated!.day);
    var result = fixedDate.add(Duration(days: returnPolicy));
    // ignore: avoid_print
    print('Result is $result');
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Check if the current date is greater than the new date
    bool dateExceeded = currentDate.isAfter(result);
    if (dateExceeded) {
      // ignore: avoid_print
      print('Date has been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
    } else {
      // ignore: avoid_print
      print('Date has not been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
    }
    return result;
  }

  getExpiry(int returnPolicy) {
    if (completedTimeCreated != null) {
      DateTime fixedDate = DateTime(completedTimeCreated!.year,
          completedTimeCreated!.month, completedTimeCreated!.day);
      var result = fixedDate.add(Duration(days: returnPolicy));
      // Parse the string into a DateTime object
      DateTime dateTime = DateTime.parse(result.toString());

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat('MMMM d, y').format(dateTime);

      return formattedDate;
    } else {
      return '';
    }
  }

  getExpiryBool(int returnPolicy) {
    if (completedTimeCreated != null) {}
    DateTime fixedDate = DateTime(completedTimeCreated!.year,
        completedTimeCreated!.month, completedTimeCreated!.day);
    var result = fixedDate.add(Duration(days: returnPolicy));
    // ignore: avoid_print
    print('Result is $result');
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Check if the current date is greater than the new date
    bool dateExceeded = currentDate.isAfter(result);
    if (dateExceeded) {
      // ignore: avoid_print
      print('Date has been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
      return true;
    } else {
      // ignore: avoid_print
      print('Date has not been exceeded');
      // ignore: avoid_print
      print('Date bool is $dateExceeded');
      return false;
    }
    //return result;
  }

  @override
  void initState() {
    getCompletedTimeCreated();
    getWallet();
    getRiderDetail();
    super.initState();
  }

  deleteOrder() {
    showModal(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:
                const Text('Are you sure you want delete this order?').tr(),
            actions: [
              TextButton(
                  onPressed: () {
                    if (widget.orderModel2.paymentType == 'Wallet') {
                      updateWallet();
                    }
                    FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(widget.orderModel2.uid)
                        .delete()
                        .then((value) {
                      context.push('/orders');
                      context.pop();
                      Fluttertoast.showToast(
                          msg: "Your order has been deleted".tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          fontSize: 14.0);
                    });
                  },
                  child: const Text('Yes').tr()),
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('No').tr())
            ],
          );
        });
  }

  getPercentageOfCoupon() {
    if (widget.orderModel2.couponPercentage != 0) {
      var result =
          (widget.orderModel2.total * widget.orderModel2.couponPercentage) /
              100;
      return result;
    } else {
      return 0;
    }
  }

  updateWallet() {
    var total = widget.orderModel2.total + getPercentageOfCoupon();
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'wallet': wallet + total}).then((value) {
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

  ratingAndReviewProduct(
    String productID,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Review Product').tr(),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Column(children: [
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingValProduct = rating;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,

                    border: InputBorder.none,
                    fillColor: const Color.fromARGB(255, 236, 234, 234),
                    hintText: 'Review Product'.tr(),
                    //border: OutlineInputBorder()
                  ),
                  onChanged: (val) {
                    setState(() {
                      reviewProduct = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: appColor),
                    onPressed: () {
                      context.loaderOverlay.show();
                      FirebaseFirestore.instance
                          .collection('Products')
                          .doc(productID)
                          .get()
                          .then((value) {
                        context.loaderOverlay.hide();
                        FirebaseFirestore.instance
                            .collection('Products')
                            .doc(productID)
                            .update({
                          'totalRating':
                              value['totalRating'] + ratingValProduct,
                          'totalNumberOfUserRating':
                              value['totalNumberOfUserRating'] + 1
                        });
                      });

                      FirebaseFirestore.instance
                          .collection('Products')
                          .doc(productID)
                          .collection('Ratings')
                          .add({
                        'rating': ratingValProduct,
                        'review': reviewProduct,
                        'fullname': name,
                        'profilePicture': '',
                        'timeCreated': DateFormat.yMMMMEEEEd()
                            .format(DateTime.now())
                            .toString()
                      }).then((value) => Navigator.of(context).pop());
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ).tr())
              ]),
            ),
          );
        });
  }

  String riderName = '';
  String riderPhone = '';
  getRiderDetail() {
    if (widget.orderModel2.acceptDelivery == true) {
      FirebaseFirestore.instance
          .collection('riders')
          .doc(widget.orderModel2.deliveryBoyID)
          .get()
          .then((value) {
        setState(() {
          riderName = value['fullname'];
          riderPhone = value['phone'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse the string into a DateTime object
    DateTime dateTime =
        DateTime.parse(widget.orderModel2.timeCreated.toString());

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('MMMM d, y').format(dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Order n° ${widget.orderModel2.orderID}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Gap(5),
            IconButton(
                onPressed: () {
                  FlutterClipboard.copy(widget.orderModel2.orderID)
                      // ignore: avoid_print
                      .then((value) => print('copied'));
                  Fluttertoast.showToast(
                      msg: "Order id has been copied".tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 2,
                      fontSize: 14.0);
                },
                icon: const Icon(
                  Icons.copy,
                  size: 14,
                ))
          ],
        ),
        const Gap(5),
        Text('${widget.quantity} items'),
        const Gap(5),
        Text('Placed on $formattedDate'),
        const Gap(5),
        Text(
            'Total ${widget.currency}${Formatter().converter(widget.orderModel2.total.toDouble())}'),
        const Gap(10),
        const Divider(
          color: Color.fromARGB(255, 237, 235, 235),
          thickness: 1,
        ),
        const Gap(10),
        const Text(
          'ITEMS IN YOUR ORDER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        const Gap(10),
        // const Divider(
        //   color: Color.fromARGB(255, 237, 235, 235),
        //   thickness: 1,
        // ),
        // const Gap(10),
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.orderModel2.orders.length,
          itemBuilder: (context, index) {
            OrdersList cartModel = widget.orderModel2.orders[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    border: Border.all(
                        color: const Color.fromARGB(255, 237, 235, 235))),
                height: widget.orderModel2.status == 'Completed' ? 230 : 180,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: CatImageWidget(
                            url: cartModel.image,
                            boxFit: 'cover',
                          )),
                      const Gap(20),
                      Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cartModel.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              ),
                              const Gap(10),
                              Text(
                                '${widget.currency}${Formatter().converter(cartModel.selectedPrice.toDouble())}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const Gap(10),
                              Text(
                                'Selected Product: ${cartModel.selected}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              ).tr(),
                              const Gap(10),
                              Text(
                                'Quantity: ${cartModel.quantity}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              ).tr(),
                              const Gap(10),
                              if (cartModel.returnDuration == 0)
                                const Text(
                                  'No return policy on this product',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200),
                                ).tr(),
                              if (cartModel.returnDuration != 0 &&
                                  completedTimeCreated != null &&
                                  getExpiryBool(cartModel.returnDuration) ==
                                      false)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ReturnProductPage(
                                            userID: userID,
                                            orderID: widget.orderModel2.orderID,
                                            ordersList: cartModel,
                                          );
                                        }));
                                      },
                                      child: Text(
                                        'Return policy expires on  ${getExpiry(cartModel.returnDuration)}, Tap to request for a return',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: appColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w200),
                                      ).tr(),
                                    ),
                                  ),
                                ),
                              if (cartModel.returnDuration != 0 &&
                                  completedTimeCreated != null &&
                                  getExpiryBool(cartModel.returnDuration) ==
                                      true)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Return policy on this product has expired',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ).tr(),
                                  ),
                                ),
                              if (cartModel.returnDuration != 0 &&
                                  completedTimeCreated == null)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Return policy of ${cartModel.returnDuration} days',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w200),
                                    ).tr(),
                                  ),
                                ),
                              if (widget.orderModel2.status == 'Completed')
                                const Gap(10),
                              if (widget.orderModel2.status == 'Completed')
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        ratingAndReviewProduct(
                                          cartModel.productID,
                                        );
                                      },
                                      child: const Text('Review & Rate Product')
                                          .tr()),
                                )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
          // separatorBuilder:
          //     (BuildContext context, int index) {
          //   return const Divider(
          //       color:
          //           Color.fromARGB(255, 236, 227, 227));
          // },
        ),
        const Gap(20),
        const Text(
          'PAYMENT INFORMATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ).tr(),
        const Gap(5),
        const Divider(
          color: Color.fromARGB(255, 237, 235, 235),
          thickness: 1,
        ),
        const Gap(10),

        Text('Payment Method: ${widget.orderModel2.paymentType}'),

        const Gap(5),
        Text(
            'Items Total: ${widget.currency}${Formatter().converter(widget.selectedPrice.toDouble())}'),
        if (widget.orderModel2.deliveryFee != 0) const Gap(5),
        if (widget.orderModel2.deliveryFee != 0)
          Text(
              'Delivery Fee: ${widget.currency}${Formatter().converter(widget.orderModel2.deliveryFee.toDouble())}'),
        if (widget.orderModel2.useCoupon == true) const Gap(5),
        if (widget.orderModel2.useCoupon == true)
          Text(
              'Discount: ${widget.currency}${Formatter().converter(((widget.selectedPrice + widget.orderModel2.deliveryFee) * widget.orderModel2.couponPercentage / 100).toDouble())} at ${widget.orderModel2.couponPercentage}% Discount'),
        const Gap(5),
        Text(
            'Total: ${widget.currency}${Formatter().converter(widget.orderModel2.total.toDouble())}'),
        const Gap(20),
        if (widget.orderModel2.deliveryAddress.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DELIVERY INFORMATION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ).tr(),
              const Gap(5),
              const Divider(
                color: Color.fromARGB(255, 237, 235, 235),
                thickness: 1,
              ),
              const Gap(10),
              Text('House Number: ${widget.orderModel2.houseNumber}'),
              const Gap(5),
              Text('Closest Bus Stop: ${widget.orderModel2.closesBusStop}'),
              const Gap(5),
              Text('Closest Bus Stop: ${widget.orderModel2.closesBusStop}'),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true) const Gap(5),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true)
                  Text('Rider name: $riderName'),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true) const Gap(5),
              if (riderName.isNotEmpty)
                if (widget.orderModel2.acceptDelivery == true)
                  Text('Rider name: $riderPhone'),
            ],
          ),
        if (widget.orderModel2.deliveryAddress.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PICKUP INFORMATION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ).tr(),
              const Gap(5),
              const Divider(
                color: Color.fromARGB(255, 237, 235, 235),
                thickness: 1,
              ),
              const Gap(10),
              Text('Pickup Store: ${widget.orderModel2.pickupStorename}'),
              const Gap(5),
              Text('Pickup Address: ${widget.orderModel2.pickupAddress}'),
              const Gap(5),
              Text('Pickup Phone: ${widget.orderModel2.pickupPhone}'),
            ],
          ),
        if (widget.orderModel2.status == 'Received') const Gap(20),
        if (widget.orderModel2.status == 'Received')
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appColor),
                onPressed: () {
                  deleteOrder();
                },
                child: const Text(
                  'Delete Order',
                  style: TextStyle(color: Colors.white),
                ).tr()),
          ),
        const Gap(20)
      ],
    );
  }
}
