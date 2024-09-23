import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rider_app/Model/formatter.dart';
import 'package:rider_app/Model/order_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  List<OrderModel2> orders = [];
  List<OrderModel2> initOrders = [];
  String? selectedValue;
  String currency = '';
  bool isLoading = true;
  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    context.loaderOverlay.show();
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    FirebaseFirestore.instance
        .collection('Orders')
        .where('deliveryBoyID', isEqualTo: user!.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) {
      context.loaderOverlay.hide();
      setState(() {
        isLoading = false;
      });
      orders.clear();
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
            initOrders = orders;
          });
        }
      }
      orders.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
    });
  }

  @override
  initState() {
    super.initState();
    getCurrency();
    fetchOrders();
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

  getOrderStatus(String status) {
    if (status == 'All') {
      resetToInitialList();
    } else {
      resetToInitialList();
      setState(() {
        orders = orders.where((element) => element.status == status).toList();
      });
    }
  }

  void resetToInitialList() {
    setState(() {
      orders = List.from(initOrders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'Orders',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ).tr(),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                dropdownStyleData: const DropdownStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  // height: 40,
                  width: 140,
                ),
                isExpanded: true,
                customButton: const Icon(Icons.sort),
                items: [
                  'All'.tr(),
                  'Received'.tr(),
                  'Processing'.tr(),
                  'On the way'.tr(),
                  'Completed'.tr()
                ]
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                    getOrderStatus(value);
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading == true
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                height: 20,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 100,
                                height: 16,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : orders.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.list,
                              color: Colors.orange,
                              size: MediaQuery.of(context).size.width >= 1100
                                  ? MediaQuery.of(context).size.width / 5
                                  : MediaQuery.of(context).size.width / 1.5,
                            ),
                          ),
                          const Gap(10),
                          const Text('No order has been made').tr(),
                          const Gap(20),
                        ],
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: orders.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          OrderModel2 orderModel2 = orders[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214))),
                              child: ListTile(
                                subtitle: orderModel2.acceptDelivery == false
                                    ? const Text("New Delviery Request")
                                    : Text(timeago
                                        .format(orderModel2.timeCreated)),
                                leading: Text(
                                  '$currency${Formatter().converter(orderModel2.total.toDouble())}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                title: Text(
                                  'Order: ${orderModel2.orderID}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    context.push(
                                        '/order-detail/${orderModel2.uid}');
                                  },
                                  child: const Text(
                                    'SEE DETAILS',
                                    style: TextStyle(color: Colors.orange),
                                  ).tr(),
                                ),
                              ),
                            ),
                          );
                        }),
          ],
        ),
      ),
    );
  }
}
