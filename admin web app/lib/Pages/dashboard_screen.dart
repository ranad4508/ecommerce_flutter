import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:admin_web_app/Widget/orders_datatable.dart';
import 'package:gap/gap.dart';
import 'package:isoweek/isoweek.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;

import '../Models/currency_formatter.dart';
import '../Models/order_model.dart';
import '../Widget/chart.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  responsiveness() {
    if (MediaQuery.of(context).size.width >= 1100) {
      return 4;
    } else if (MediaQuery.of(context).size.width < 1100 &&
        MediaQuery.of(context).size.width >= 850) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    allOrdersFunc();
    fetchOrders();
    getNumberofProducts();
    fetchOrdersDelivered();
    fetchOrdersReceived();
    getNairaBalance();
    fetchOrdersPreparing();
    fetchOrdersReady();
    fetchOrdersOntheway();
    getTotalSales();
    getCurrencyDetails();
    getNumberofUsers();
    getOrdersByMondayToday();
    getOrdersByTuesdayToday();
    getOrdersByWednessdayToday();
    getOrdersByThursdayToday();
    getOrdersByFridayToday();
    getOrdersBySaturdayToday();
    getOrdersBySundayToday();
    getOrdersByMonday();
    getOrdersByTuesday();
    getOrdersByWednessday();
    getOrdersByThursday();
    getOrdersByFriday();
    getOrdersBySaturday();
    getOrdersBySunday();
    super.initState();
  }

  int mondayToday = 0;
  getOrdersByMondayToday() {
    Week currentWeek = Week.current();
    //ignore: avoid_print
    print('Current week: ${currentWeek.weekNumber}');
    FirebaseFirestore.instance
        .collection('Orders')
        .where('weekNumber', isEqualTo: currentWeek.weekNumber)
        .where('day', isEqualTo: "Monday")
        .get()
        .then((value) {
      setState(() {
        mondayToday = value.docs.length;
      });
    });
  }

  int tuesdayToday = 0;
  getOrdersByTuesdayToday() {
    Week currentWeek = Week.current();
    //ignore: avoid_print
    print('Current week: ${currentWeek.weekNumber}');

    FirebaseFirestore.instance
        .collection('Orders')
        .where('weekNumber', isEqualTo: currentWeek.weekNumber)
        .where('day', isEqualTo: "Tuesday")
        .get()
        .then((value) {
      setState(() {
        tuesdayToday = value.docs.length;
      });
    });
  }

  int wednessdayToday = 0;
  getOrdersByWednessdayToday() {
    Week currentWeek = Week.current();
    //ignore: avoid_print
    print('Current week: ${currentWeek.weekNumber}');

    FirebaseFirestore.instance
        .collection('Orders')
        .where('weekNumber', isEqualTo: currentWeek.weekNumber)
        .where('day', isEqualTo: "Wednessday")
        .get()
        .then((value) {
      setState(() {
        wednessdayToday = value.docs.length;
      });
    });
  }

  int thursdayToday = 0;
  getOrdersByThursdayToday() {
    Week currentWeek = Week.current();
    //ignore: avoid_print
    print('Current week: ${currentWeek.weekNumber}');

    FirebaseFirestore.instance
        .collection('Orders')
        .where('weekNumber', isEqualTo: currentWeek.weekNumber)
        .where('day', isEqualTo: "Thursday")
        .get()
        .then((value) {
      setState(() {
        thursdayToday = value.docs.length;
      });
    });
  }

  int fridayToday = 0;
  getOrdersByFridayToday() {
    Week currentWeek = Week.current();
    //ignore: avoid_print
    print('Current week: ${currentWeek.weekNumber}');

    FirebaseFirestore.instance
        .collection('Orders')
        .where('weekNumber', isEqualTo: currentWeek.weekNumber)
        .where('day', isEqualTo: "Friday")
        .get()
        .then((value) {
      setState(() {
        fridayToday = value.docs.length;
      });
    });
  }

  int saturdayToday = 0;
  getOrdersBySaturdayToday() {
    Week currentWeek = Week.current();
    //ignore: avoid_print
    print('Current week: ${currentWeek.weekNumber}');

    FirebaseFirestore.instance
        .collection('Orders')
        .where('weekNumber', isEqualTo: currentWeek.weekNumber)
        .where('day', isEqualTo: "Saturday")
        .get()
        .then((value) {
      setState(() {
        saturdayToday = value.docs.length;
      });
    });
  }

  int sundayToday = 0;
  getOrdersBySundayToday() {
    Week currentWeek = Week.current();
    //ignore: avoid_print
    print('Current week: ${currentWeek.weekNumber}');

    FirebaseFirestore.instance
        .collection('Orders')
        .where('weekNumber', isEqualTo: currentWeek.weekNumber)
        .where('day', isEqualTo: "Sunday")
        .get()
        .then((value) {
      setState(() {
        sundayToday = value.docs.length;
      });
    });
  }

  int monday = 0;
  bool loading = true;
  getOrdersByMonday() {
    setState(() {
      loading = true;
    });
    FirebaseFirestore.instance
        .collection('Orders')
        .where('day', isEqualTo: "Monday")
        .get()
        .then((value) {
      setState(() {
        monday = value.docs.length;

        loading = false;
      });
      // ignore: avoid_print
      print('Monday is $monday');
    });
  }

  int tuesday = 0;
  getOrdersByTuesday() {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('day', isEqualTo: "Tuesday")
        .get()
        .then((value) {
      setState(() {
        tuesday = value.docs.length;
      });
    });
  }

  int wednessday = 0;
  getOrdersByWednessday() {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('day', isEqualTo: "Wednessday")
        .get()
        .then((value) {
      setState(() {
        wednessday = value.docs.length;
      });
    });
  }

  int thursday = 0;
  getOrdersByThursday() {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('day', isEqualTo: "Thursday")
        .get()
        .then((value) {
      setState(() {
        thursday = value.docs.length;
      });
    });
  }

  int friday = 0;
  getOrdersByFriday() {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('day', isEqualTo: "Friday")
        .get()
        .then((value) {
      setState(() {
        friday = value.docs.length;
      });
    });
  }

  int saturday = 0;
  getOrdersBySaturday() {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('day', isEqualTo: "Saturday")
        .get()
        .then((value) {
      setState(() {
        saturday = value.docs.length;
      });
    });
  }

  int sunday = 0;
  getOrdersBySunday() {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('day', isEqualTo: "Sunday")
        .get()
        .then((value) {
      setState(() {
        sunday = value.docs.length;
      });
    });
  }

  DateFormat dateFormat = DateFormat('EEE, M-d-y');
  String vendorsID = '';
  DocumentReference? userRef;
  int totalQuantity = 0;
  num grossSales = 0;
  List<int> quantity = [];
  List<int> selectedPrice = [];
  List<OrderModel2> ordersReceived = [];
  List<OrderModel2> ordersPreparing = [];
  List<OrderModel2> ordersReady = [];
  List<OrderModel2> ordersOntheway = [];
  List<OrderModel2> ordersDelivered = [];
  int allOrders = 0;

  allOrdersFunc() {
    FirebaseFirestore.instance.collection('Orders').snapshots().listen((v) {
      setState(() {
        allOrders = v.docs.length;
      });
    });
  }

  List<OrderModel2> orders = [];
  Future fetchOrders() async {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('acceptDelivery', isEqualTo: true)
        .snapshots()
        .listen((data) {
      orders.clear();
      quantity.clear();
      selectedPrice.clear();
      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            orders.add(OrderModel2(
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              marketID: doc.data()['marketID'],
              vendorID: doc.data()['vendorID'],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ));
          });
        }
      }
    });
  }

  Future fetchOrdersReceived() async {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Received')
        .snapshots()
        .listen((data) {
      // ordersReceived.clear();

      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            ordersReceived.add(OrderModel2(
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              marketID: doc.data()['marketID'],
              vendorID: doc.data()['vendorID'],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ));
          });
        }
      }
    });
  }

  Future fetchOrdersPreparing() async {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Preparing')
        .snapshots()
        .listen((data) {
      // ordersPreparing.clear();

      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            ordersPreparing.add(OrderModel2(
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              marketID: doc.data()['marketID'],
              vendorID: doc.data()['vendorID'],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ));
          });
        }
      }
    });
  }

  Future fetchOrdersReady() async {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Ready')
        .snapshots()
        .listen((data) {
      // ordersReady.clear();

      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            orders.add(OrderModel2(
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              marketID: doc.data()['marketID'],
              vendorID: doc.data()['vendorID'],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ));
          });
        }
      }
    });
  }

  Future fetchOrdersOntheway() async {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'On the way')
        .snapshots()
        .listen((data) {
      // ordersOntheway.clear();
      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            ordersOntheway.add(OrderModel2(
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              marketID: doc.data()['marketID'],
              vendorID: doc.data()['vendorID'],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ));
          });
        }
      }
    });
  }

  Future fetchOrdersDelivered() async {
    return FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Completed')
        .snapshots()
        .listen((data) {
      // ordersDelivered.clear();
      for (var doc in data.docs) {
        if (mounted) {
          setState(() {
            ordersDelivered.add(OrderModel2(
              orders: [
                ...(doc.data()['orders']).map((items) {
                  return OrdersList.fromMap(items);
                })
              ],
              pickupStorename: doc.data()['pickupStorename'],
              pickupPhone: doc.data()['pickupPhone'],
              pickupAddress: doc.data()['pickupAddress'],
              instruction: doc.data()['instruction'],
              couponPercentage: doc.data()['couponPercentage'],
              couponTitle: doc.data()['couponTitle'],
              useCoupon: doc.data()['useCoupon'],
              confirmationStatus: doc.data()['confirmationStatus'],
              uid: doc.data()['uid'],
              marketID: doc.data()['marketID'],
              vendorID: doc.data()['vendorID'],
              userID: doc.data()['userID'],
              deliveryAddress: doc.data()['deliveryAddress'],
              houseNumber: doc.data()['houseNumber'],
              closesBusStop: doc.data()['closesBusStop'],
              deliveryBoyID: doc.data()['deliveryBoyID'],
              status: doc.data()['status'],
              accept: doc.data()['accept'],
              orderID: doc.data()['orderID'],
              timeCreated: doc.data()['timeCreated'].toDate(),
              total: doc.data()['total'],
              deliveryFee: doc.data()['deliveryFee'],
              acceptDelivery: doc.data()['acceptDelivery'],
              paymentType: doc.data()['paymentType'],
            ));
          });
        }
      }
    });
  }

  List<Color> colorList = [
    // Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.deepOrange
  ];

  String currencyCode = '';
  String currencySymbol = '';
  String getcurrencyName = '';
  String getcurrencyCode = '';
  String getcurrencySymbol = '';

  getCurrencyDetails() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        getcurrencyName = value['Currency name'];
        getcurrencyCode = value['Currency code'];
        getcurrencySymbol = value['Currency symbol'];
      });
    });
  }

  int userLength = 0;
  getNumberofUsers() {
    FirebaseFirestore.instance.collection('users').get().then((event) {
      //print('User length is ${event.docs.length}');
      setState(() {
        userLength = event.docs.length;
      });
    });
  }

  int productsLength = 0;
  getNumberofProducts() {
    FirebaseFirestore.instance.collection('Products').get().then((event) {
      //print('Order length is ${event.docs.length}');
      setState(() {
        productsLength = event.docs.length;
      });
    });
  }

  num ngnWalletBalance = 0;
  num usdWalletBalance = 0;
  num gbpWalletBalance = 0;
  num eurWalletBalance = 0;
  num ngnWalletLedgerBalance = 0;
  num usdWalletLedgerBalance = 0;
  num gbpWalletLedgerBalance = 0;
  num eurWalletLedgerBalance = 0;
  getNairaBalance() async {
    var url = Uri.parse(
      'https://zeerospay.onrender.com/get-naira-balance',
    );

    await http
        .post(url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              "currency": "NGN",
            }))
        .then((value) {
      // print(json.decode(value.body)['data']['ledger_balance']);

      setState(() {
        ngnWalletLedgerBalance =
            json.decode(value.body)['data']['ledger_balance'];
        ngnWalletBalance = json.decode(value.body)['data']['available_balance'];
      });
    });
  }

  getNairaValue() {
    MoneyFormatter fmf = MoneyFormatter(amount: ngnWalletBalance.toDouble());
    return fmf.output.nonSymbol;
  }

  getNairaLedgerValue() {
    MoneyFormatter fmf =
        MoneyFormatter(amount: ngnWalletLedgerBalance.toDouble());
    return fmf.output.nonSymbol;
  }

  num totalSales = 0;
  getTotalSales() {
    FirebaseFirestore.instance.collection('Orders').snapshots().listen((event) {
      num tempTotal =
          event.docs.fold(0, (tot, doc) => tot + doc.data()['total']);

      setState(() {
        totalSales = tempTotal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: const Text(
            'Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ).tr(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MediaQuery.of(context).size.width >= 1100
              ? Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).cardColor,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(10),
                                const Icon(
                                  Icons.monetization_on,
                                  color: Colors.orange,
                                  size: 50,
                                ),
                                const Gap(10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Sales',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ).tr(),
                                    Text(
                                      '$getcurrencySymbol${CurrencyFormatter().converter(totalSales.toDouble())}',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Flexible(
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).cardColor,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(10),
                                const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.orange,
                                  size: 50,
                                ),
                                const Gap(10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Orders',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ).tr(),
                                    Text(
                                      '$allOrders',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Flexible(
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).cardColor,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Gap(10),
                                const Icon(
                                  Icons.shopping_bag,
                                  color: Colors.blue,
                                  size: 50,
                                ),
                                const Gap(10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Products',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ).tr(),
                                    Text(
                                      productsLength.toString(),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Gap(10),
                              const Flexible(
                                flex: 5,
                                child: Icon(
                                  Icons.monetization_on,
                                  color: Colors.orange,
                                  size: 70,
                                ),
                              ),
                              const Gap(10),
                              Flexible(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Sales',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ).tr(),
                                    const Gap(10),
                                    Text(
                                      '$getcurrencySymbol${CurrencyFormatter().converter(totalSales.toDouble())}',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Gap(10),
                              const Flexible(
                                flex: 5,
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.orange,
                                  size: 70,
                                ),
                              ),
                              const Gap(10),
                              Flexible(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Orders',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ).tr(),
                                    const Gap(10),
                                    Text(
                                      '$allOrders',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).cardColor,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Gap(10),
                              const Flexible(
                                flex: 5,
                                child: Icon(
                                  Icons.shopping_bag,
                                  color: Colors.blue,
                                  size: 70,
                                ),
                              ),
                              const Gap(10),
                              Flexible(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Products',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ).tr(),
                                    const Gap(10),
                                    Text(
                                      productsLength.toString(),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 20),
// Start
        MediaQuery.of(context).size.width >= 1100
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 5,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        // width: MediaQuery.of(context).size.width / 2.3,
                        child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Gap(20),
                                  const Text(
                                    'Weekly report',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ).tr(),
                                ],
                              ),
                              loading == true
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.blue),
                                    )
                                  : BarChartSample2(
                                      monday: monday,
                                      tuesday: tuesday,
                                      wednessday: wednessday,
                                      thursday: thursday,
                                      friday: friday,
                                      saturday: saturday,
                                      sunday: sunday,
                                      mondayToday: mondayToday,
                                      tuesdayToday: tuesdayToday,
                                      wednessdayToday: wednessdayToday,
                                      thursdayToday: thursdayToday,
                                      fridayToday: fridayToday,
                                      saturdayToday: saturdayToday,
                                      sundayToday: sundayToday,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        // width: MediaQuery.of(context).size.width / 2,
                        child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Gap(20),
                                  const Text(
                                    'Order summary',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ).tr(),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: PieChart(
                                  dataMap: {
                                    'Received'.tr():
                                        ordersReceived.length.toDouble(),
                                    'Preparing'.tr():
                                        ordersPreparing.length.toDouble(),
                                    'Ready'.tr(): ordersReady.length.toDouble(),
                                    'On the way'.tr():
                                        ordersOntheway.length.toDouble(),
                                    'Delivered'.tr():
                                        ordersDelivered.length.toDouble()
                                  },
                                  animationDuration:
                                      const Duration(milliseconds: 800),
                                  chartLegendSpacing: 32,
                                  chartRadius:
                                      MediaQuery.of(context).size.width / 1.7,
                                  colorList: colorList,
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.disc,
                                  ringStrokeWidth: 32,
                                  centerText:
                                      ('Order Statistics'.tr()).toString(),
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: true,
                                    legendShape: BoxShape.circle,
                                    legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValues: true,
                                    showChartValuesInPercentage: false,
                                    showChartValuesOutside: false,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Gap(20),
                                const Text(
                                  'Weekly report',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ).tr(),
                              ],
                            ),
                            loading == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.blue),
                                  )
                                : BarChartSample2(
                                    monday: monday,
                                    tuesday: tuesday,
                                    wednessday: wednessday,
                                    thursday: thursday,
                                    friday: friday,
                                    saturday: saturday,
                                    sunday: sunday,
                                    mondayToday: mondayToday,
                                    tuesdayToday: tuesdayToday,
                                    wednessdayToday: wednessdayToday,
                                    thursdayToday: thursdayToday,
                                    fridayToday: fridayToday,
                                    saturdayToday: saturdayToday,
                                    sundayToday: sundayToday,
                                  )
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Gap(20),
                                const Text('Order summary,',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                    .tr(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: PieChart(
                                dataMap: {
                                  'Received'.tr():
                                      ordersReceived.length.toDouble(),
                                  'Preparing'.tr():
                                      ordersPreparing.length.toDouble(),
                                  'Ready'.tr(): ordersReady.length.toDouble(),
                                  'On the way'.tr():
                                      ordersOntheway.length.toDouble(),
                                  'Delivered'.tr():
                                      ordersDelivered.length.toDouble()
                                },
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 1.7,
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.disc,
                                ringStrokeWidth: 32,
                                centerText:
                                    ('Order Statistics'.tr()).toString(),
                                legendOptions: const LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
        const Gap(20),
        Card(
          color: Theme.of(context).cardColor,
          elevation: 0,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const Gap(20),
                  const Text(
                    'New Orders',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).tr(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: OrdersDatatable(
                              getcurrencySymbol: getcurrencySymbol)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const Gap(50),
      ],
    );
  }
}
