import 'package:admin_web_app/Models/notifications.dart';
import 'package:admin_web_app/Models/user.dart';
import 'package:admin_web_app/Utils/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';
import '../Models/currency_formatter.dart';
import '../Models/order_model.dart';
import 'pdf_generator_order_receipt.dart';

class OrderDetail extends StatefulWidget {
  final OrderModel2 orderModel;
  const OrderDetail({
    super.key,
    required this.orderModel,
  });
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  String userEmail = '';
  String userphone = '';
  String vendorsEmail = '';
  String vendorsphone = '';
  String vendorsName = '';
  String userToken = '';

  getUserDetails() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.orderModel.userID)
        .snapshots()
        .listen((value) {
      setState(() {
        fullName = value['fullname'];
        userEmail = value['email'];
        userphone = value['phone'];
        userToken = value['tokenID'];
      });
    });
  }

  String currencyName = '';
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
        currencySymbol = value['Currency symbol'];
      });
    });
  }

  int _index = 0;
  String marketName = '';
  String marketAddress = '';
  String marketPhone = '';
  String riderName = '';
  String riderAddress = '';
  String riderPhone = '';
  num wallet = 0;
  DocumentReference? userDetails;
  num quantity = 0;
  num selectedPrice = 0;
  OrderModel2? orderDetail;
  String notificationID = '';
  String fullName = '';
  num commission = 0;
  getAdminCommission() {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc('Admin')
        .snapshots()
        .listen((event) {
      setState(() {
        commission = event['commission'];
      });
    });
  }

  num riderCharge = 0;
  getRiderCharge() {
    FirebaseFirestore.instance
        .collection('Rider Charge')
        .doc('Rider Charge')
        .snapshots()
        .listen((event) {
      setState(() {
        riderCharge = event['Rider Charge'];
      });
    });
  }

  @override
  void initState() {
    var uuid = const Uuid();
    notificationID = uuid.v1();
    getUserDetails();
    getRiders();
    getRiderDetail();
    getRiderCharge();
    getCurrencyDetails();
    getEnableRiderStatusDetails();
    getAdminCommission();
    fetchOrderDetail();
    super.initState();
  }

  bool isLoading = true;
  Future<void> fetchOrderDetail() async {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((doc) {
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
            .fold(0, (amount, product) => amount + product.quantity);
        selectedPrice = orderDetail!.orders.fold(
            0,
            (price, product) =>
                price + product.selectedPrice * product.quantity);
      });
    });
    //  for (var element in orderDetail!.orders) {

    //  }
  }

  String? orderStatus;
  bool loading = false;
  updateStatus(String orderStatus) async {
    setState(() {
      loading = true;
    });
    if (orderStatus == 'Accept') {
      acceptedTimeCreatedFunc();
      PushNotificationFunction.sendPushNotification(
          'Order notification', 'Your order has been accepted', userToken);
      PushNotificationFunction().sendFirebaseNotification(
          NotificationsModel(
              uid: notificationID,
              heading: 'Order notification',
              content: 'Your order has been accepted'),
          widget.orderModel.userID,
          notificationID);
      FirebaseFirestore.instance
          .collection('Orders')
          .doc(widget.orderModel.uid)
          .update({'accept': true}).then((value) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Status has been updated".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.pop(context);
      });
    } else if (orderStatus == 'Processing' || orderStatus == 'On the way') {
      if (orderStatus == 'Processing') {
        processingTimeCreatedFunc();
        PushNotificationFunction.sendPushNotification(
            'Order notification', 'Your order is Processing', userToken);
        PushNotificationFunction().sendFirebaseNotification(
            NotificationsModel(
                uid: notificationID,
                heading: 'Order notification',
                content: 'Your order is Processing'),
            widget.orderModel.userID,
            notificationID);
      } else {
        onthewayTimeCreatedFunc();
        PushNotificationFunction.sendPushNotification(
            'Order notification', 'Your order is on the way', userToken);
        PushNotificationFunction().sendFirebaseNotification(
            NotificationsModel(
                uid: notificationID,
                heading: 'Order notification',
                content: 'Your order is on the way'),
            widget.orderModel.userID,
            notificationID);
      }
      FirebaseFirestore.instance
          .collection('Orders')
          .doc(widget.orderModel.uid)
          .update({'status': orderStatus, 'acceptDelivery': true}).then(
              (value) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Status has been updated".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.pop(context);
      });
    } else {
      if (orderStatus == 'Received') {
        receivedTimeCreatedFunc();
        PushNotificationFunction.sendPushNotification(
            'Order notification', 'Your order has been received', userToken);
        PushNotificationFunction().sendFirebaseNotification(
            NotificationsModel(
                uid: notificationID,
                heading: 'Order notification',
                content: 'Your order has been received'),
            widget.orderModel.userID,
            notificationID);
      } else {
        completedTimeCreatedFunc();
        PushNotificationFunction.sendPushNotification(
            'Order notification', 'Your order has been completed', userToken);
        PushNotificationFunction().sendFirebaseNotification(
            NotificationsModel(
                uid: notificationID,
                heading: 'Order notification',
                content: 'Your order has been completed'),
            widget.orderModel.userID,
            notificationID);
      }
      FirebaseFirestore.instance
          .collection('Orders')
          .doc(widget.orderModel.uid)
          .update({
        'status': orderStatus == 'Received'
            ? 'Received'
            : orderStatus == 'Completed'
                ? 'Completed'
                : 'Cancelled'
      }).then((value) {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Status has been updated".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.pop(context);
      });
    }
  }

  completedTimeCreatedFunc() {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel.uid)
        .update({'completedTimeCreated': DateTime.now()});
    if (widget.orderModel.deliveryBoyID.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('riders')
          .doc(widget.orderModel.deliveryBoyID)
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('riders')
            .doc(widget.orderModel.deliveryBoyID)
            .update({
          'isActive': false,
          'wallet': value['wallet'] +
              ((widget.orderModel.deliveryFee) -
                  ((widget.orderModel.deliveryFee * riderCharge) / 100))
        });
        FirebaseFirestore.instance.collection('Admin').doc('Admin').update({
          'commission':
              commission + ((widget.orderModel.deliveryFee * riderCharge) / 100)
        });
      });
    }
  }

  receivedTimeCreatedFunc() {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel.uid)
        .update({'receivedTimeCreated': DateTime.now()});
  }

  acceptedTimeCreatedFunc() {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel.uid)
        .update({'acceptedTimeCreated': DateTime.now()});
  }

  onthewayTimeCreatedFunc() {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel.uid)
        .update({'onthewayTimeCreated': DateTime.now()});
  }

  processingTimeCreatedFunc() {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel.uid)
        .update({'processingTimeCreated': DateTime.now()});
  }

  List<UserModel> riders = [];
  getRiders() {
    if (widget.orderModel.deliveryAddress.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('riders')
          .where('isActive', isEqualTo: false)
          .where('approval', isEqualTo: true)
          .snapshots()
          .listen((event) {
        for (var element in event.docs) {
          var user = UserModel.fromMap(element.data(), element.id);
          setState(() {
            riders.add(user);
            // ignore: avoid_print
            print('Riders are $riders');
          });
        }
      });
    }
  }

  assignRider(String rider) {
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderModel.uid)
        .update({'deliveryBoyID': rider}).then((value) {
      FirebaseFirestore.instance
          .collection('riders')
          .doc(rider)
          .get()
          .then((value) {
        PushNotificationFunction.sendPushNotification('New Delivery Request',
            'You have a new delivery request', value['tokenID']);
      });
      Fluttertoast.showToast(
          msg: "Delivery has been assigned".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 14.0);
      Navigator.pop(context);
    });
  }

  getRiderDetail() {
    if (widget.orderModel.deliveryBoyID.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('riders')
          .doc(widget.orderModel.deliveryBoyID)
          .get()
          .then((value) {
        setState(() {
          riderPhone = value['phone'];
          riderName = value['fullname'];
        });
      });
    }
  }

  bool enableRiderSystem = false;

  getEnableRiderStatusDetails() {
    FirebaseFirestore.instance
        .collection('Enable Rider System')
        .doc('Enable Rider System')
        .snapshots()
        .listen((value) {
      setState(() {
        if (mounted) {
          // referralAmount = value['Referral Amount'];
          enableRiderSystem = value['Status'];
          // ignore: avoid_print
          print('$enableRiderSystem this is enable rider systme');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parse the string into a DateTime object
    DateTime dateTime =
        DateTime.parse(widget.orderModel.timeCreated.toString());

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('MMMM d, y').format(dateTime);
    return isLoading == true
        ? Center(
            child: const Text('Loading...').tr(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Tracking Update',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon:
                                const Icon(Icons.cancel, color: Colors.black)),
                      )
                    ],
                  ),
                ),
                Stepper(
                  physics: const BouncingScrollPhysics(),
                  onStepTapped: (step) {
                    if (step > _index) {
                      setState(() {
                        _index = step;
                      });
                    }
                  },
                  type: StepperType.vertical,
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return const SizedBox();
                  },
                  currentStep: _index,
                  steps: <Step>[
                    Step(
                      isActive: widget.orderModel.status == 'Received'
                          ? true
                          : widget.orderModel.status == 'Cancelled'
                              ? false
                              : true,
                      title: widget.orderModel.status == 'Cancelled'
                          ? const Text('Cancelled')
                          : const Text('Received'),
                      content: Container(),
                    ),
                    Step(
                      isActive: widget.orderModel.accept == true ? true : false,
                      title: const Text('Accepted'),
                      content: Container(),
                    ),
                    Step(
                      isActive: widget.orderModel.acceptDelivery == true
                          ? true
                          : false,
                      title: const Text('Processing'),
                      content: Container(),
                    ),
                    Step(
                      isActive: widget.orderModel.status == 'Completed'
                          ? true
                          : false,
                      title: const Text('Completed'),
                      content: Container(),
                    )
                  ],
                ),
                const Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order n° ${widget.orderModel.orderID}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Gap(5),
                    Text('$quantity items'),
                    const Gap(5),
                    Text('Placed on $formattedDate'),
                    const Gap(5),
                    Text(
                        'Total $currencySymbol${CurrencyFormatter().converter(widget.orderModel.total.toDouble())}'),
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
                      itemCount: widget.orderModel.orders.length,
                      itemBuilder: (context, index) {
                        OrdersList cartModel = widget.orderModel.orders[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(2)),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 237, 235, 235))),
                            height: MediaQuery.of(context).size.width >= 1100
                                ? 150
                                : 170,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Image.network(
                                        cartModel.image,
                                        fit: BoxFit.cover,
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
                                            cartModel.productName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          const Gap(10),
                                          Text(
                                            '$currencySymbol${CurrencyFormatter().converter(cartModel.selectedPrice.toDouble())}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Gap(10),
                                          Text(
                                            'Selected Product: ${cartModel.selected}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          const Gap(10),
                                          Text(
                                            'Quantity: ${cartModel.quantity}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w200),
                                          ),
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
                                          if (cartModel.returnDuration != 0)
                                            Text(
                                              'Product can be returned within ${cartModel.returnDuration} days',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w200),
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

                    Text('Payment Method: ${widget.orderModel.paymentType}'),

                    const Gap(5),
                    Text(
                        'Items Total: $currencySymbol${CurrencyFormatter().converter(selectedPrice.toDouble())}'),
                    if (widget.orderModel.deliveryFee != 0) const Gap(5),
                    if (widget.orderModel.deliveryFee != 0)
                      Text(
                          'Delivery Fee: $currencySymbol${CurrencyFormatter().converter(widget.orderModel.deliveryFee.toDouble())}'),
                    if (widget.orderModel.useCoupon == true) const Gap(5),
                    if (widget.orderModel.useCoupon == true)
                      Text(
                          'Discount: $currencySymbol${CurrencyFormatter().converter(((selectedPrice + widget.orderModel.deliveryFee) * widget.orderModel.couponPercentage / 100).toDouble())} at ${widget.orderModel.couponPercentage}% Discount'),
                    const Gap(5),
                    Text(
                        'Total: $currencySymbol${CurrencyFormatter().converter(widget.orderModel.total.toDouble())}'),
                    const Gap(20),
                    if (widget.orderModel.deliveryAddress.isNotEmpty)
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
                          Text("Customer's Name: $fullName"),
                          const Gap(5),
                          Text("Email: $userEmail"),
                          const Gap(5),
                          Text("Customer's Phone: $userphone"),
                          const Gap(5),
                          Text(
                              'House Number: ${widget.orderModel.houseNumber}'),
                          const Gap(5),
                          Text(
                              'Closest Bus Stop: ${widget.orderModel.closesBusStop}'),
                          const Gap(5),
                          Text(
                              'Closest Bus Stop: ${widget.orderModel.closesBusStop}'),
                          if (widget.orderModel.acceptDelivery == true ||
                              widget.orderModel.deliveryBoyID.isNotEmpty)
                            const Gap(5),
                          if (enableRiderSystem == true)
                            if (widget.orderModel.acceptDelivery == true ||
                                widget.orderModel.deliveryBoyID.isNotEmpty)
                              Text('Rider name: $riderName'),
                          if (enableRiderSystem == true)
                            if (widget.orderModel.acceptDelivery == true ||
                                widget.orderModel.deliveryBoyID.isNotEmpty)
                              const Gap(5),
                          if (enableRiderSystem == true)
                            if (widget.orderModel.acceptDelivery == true ||
                                widget.orderModel.deliveryBoyID.isNotEmpty)
                              Text('Rider name: $riderPhone'),
                          const Gap(5),
                          if (enableRiderSystem == true)
                            if (widget.orderModel.acceptDelivery == false &&
                                widget.orderModel.accept == true)
                              // if (riders.isNotEmpty)
                              DropdownSearch<UserModel>(
                                popupProps: const PopupProps.menu(
                                    // showSelectedItems: true,
                                    // showSearchBox: true
                                    ),
                                items: riders,
                                itemAsString: (item) {
                                  return item.displayName!;
                                },
                                // validator: (v) => v == null ? "Required field".tr() : null,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                  hintText: 'Select An Available Rider'.tr(),
                                )),
                                onChanged: (value) {
                                  setState(() {
                                    assignRider(value!.uid!);
                                  });
                                },
                              ),
                        ],
                      ),
                    if (widget.orderModel.deliveryAddress.isEmpty)
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
                          Text("Customer's Name: $fullName"),
                          const Gap(5),
                          Text("Email: $userEmail"),
                          const Gap(5),
                          Text("Customer's Phone: $userphone"),
                          const Gap(5),
                          Text(
                              'Pickup Store: ${widget.orderModel.pickupStorename}'),
                          const Gap(5),
                          Text(
                              'Pickup Address: ${widget.orderModel.pickupAddress}'),
                          const Gap(5),
                          Text(
                              'Pickup Phone: ${widget.orderModel.pickupPhone}'),
                        ],
                      ),

                    const SizedBox(height: 20),
                    Row(children: [
                      const Text('Update Order Status:').tr(),
                    ]),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 45,
                      child: DropdownSearch<String>(
                        enabled:
                            orderDetail!.status == 'Completed' ? false : true,
                        selectedItem: widget.orderModel.status,
                        popupProps: const PopupProps.menu(
                          showSelectedItems: true,
                        ),
                        items: [
                          // 'Cancel',
                          // if (widget.orderModel.status == 'Received')
                          //   'Received',
                          if (widget.orderModel.accept == false) 'Accept',
                          if (widget.orderModel.accept == true) 'Processing',
                          if (widget.orderModel.accept == true) 'On the way',
                          if (widget.orderModel.accept == true) 'Completed',
                        ],
                        validator: (v) =>
                            v == null ? "Required field".tr() : null,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          hintText: 'Status',
                        )),
                        onChanged: (value) {
                          if (enableRiderSystem == true) {
                            if (widget.orderModel.deliveryAddress.isNotEmpty) {
                              if (widget.orderModel.accept == false &&
                                  widget.orderModel.status == 'Received') {
                                setState(() {
                                  orderStatus = value!;
                                });
                              } else if (widget.orderModel.accept == true &&
                                  widget.orderModel.status == 'Received' &&
                                  widget.orderModel.acceptDelivery == false) {
                                Fluttertoast.showToast(
                                    msg: "Select a delivery person to continue"
                                        .tr(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              } else {
                                setState(() {
                                  orderStatus = value!;
                                });
                              }
                            } else {
                              setState(() {
                                orderStatus = value!;
                              });
                            }
                          } else {
                            if (widget.orderModel.deliveryAddress.isNotEmpty) {
                              if (widget.orderModel.accept == false &&
                                  widget.orderModel.status == 'Received') {
                                setState(() {
                                  orderStatus = value!;
                                });
                              } else {
                                setState(() {
                                  orderStatus = value!;
                                });
                              }
                            } else {
                              setState(() {
                                orderStatus = value!;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    loading == true
                        ? const ElevatedButton(
                            onPressed: null, child: Text('Please wait...'))
                        : ElevatedButton(
                            onPressed: () {
                              updateStatus(orderStatus!);
                            },
                            child: const Text('Update Status')),
                    //  if (orderDetail!.status == "Completed")
                    const SizedBox(
                      height: 20,
                    ),
                    //  if (orderDetail!.status == 'Completed')
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: PdfGeneratorOrderReceipt(
                                    orderModel2: orderDetail!,
                                    fullName: fullName,
                                  ),
                                );
                              });
                        },
                        child: const Text('Print Receipt').tr()),
                    const SizedBox(height: 50),
                  ],
                )
              ],
            )));
  }
}
