import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/order_model.dart';

class TrackOrderDetailPage extends StatefulWidget {
  final String orderID;
  const TrackOrderDetailPage({super.key, required this.orderID});

  @override
  State<TrackOrderDetailPage> createState() => _TrackOrderDetailPageState();
}

class _TrackOrderDetailPageState extends State<TrackOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width >= 1100
          ? null
          : AppBar(
              title: const Text('Order Tracking Update',
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      // fontSize: 18,
                      )),
            ),
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
                          'https://static.vecteezy.com/system/resources/previews/015/541/158/non_2x/man-hand-holds-smartphone-with-city-map-gps-navigator-on-smartphone-screen-mobile-navigation-concept-modern-simple-flat-design-for-web-banners-web-infographics-flat-cartoon-illustration-vector.jpg',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          scale: 1,
                        ),
                      ),
                      Expanded(
                          flex: 7,
                          child: SizedBox(
                              child: Track(
                            orderID: widget.orderID,
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
          : Track(
              orderID: widget.orderID,
            ),
    );
  }
}

class Track extends StatefulWidget {
  final String orderID;
  const Track({super.key, required this.orderID});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  OrderModel2? orderModel;
  int _index = 0;
  bool isLoading = true;
  num quantity = 0;
  Future<void> fetchOrderDetail() async {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderID)
        .snapshots()
        .listen((doc) {
      setState(() {
        isLoading = false;
        orderModel = OrderModel2(
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
        quantity = orderModel!.orders
            .fold(0, (result, product) => result + product.quantity);
      });
    });
    //  for (var element in orderDetail!.orders) {

    //  }
  }

  @override
  void initState() {
    fetchOrderDetail();
    getCurrency();
    super.initState();
  }

  String currency = '';
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

  String date = '';
  @override
  Widget build(BuildContext context) {
    if (isLoading == false) {
      // Parse the string into a DateTime object
      DateTime dateTime = DateTime.parse(orderModel!.timeCreated.toString());

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat('MMMM d, y').format(dateTime);
      setState(() {
        date = formattedDate;
      });
    }
    return isLoading == true
        ? Center(
            child: const Text('Loading...').tr(),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: IconButton(
                    //           onPressed: () {
                    //             context.push('/track-order');
                    //           },
                    //           icon: const Icon(Icons.arrow_back,
                    //               color: Colors.black)),
                    //     ),
                    //     const Text('Order Tracking Update',
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 18,
                    //         )),
                    //     const SizedBox(),
                    //   ],
                    // ),
                    Text(
                      'Order n° ${orderModel!.orderID}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Gap(5),
                    Text('$quantity items'),
                    const Gap(5),
                    Text('Placed on $date'),
                    const Gap(5),
                    Text(
                        'Total $currency${Formatter().converter(orderModel!.total.toDouble())}'),
                    const Gap(10),
                    const Divider(
                      color: Color.fromARGB(255, 237, 235, 235),
                      thickness: 1,
                    ),
                    const Gap(10),
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
                          isActive: orderModel!.status == 'Received'
                              ? true
                              : orderModel!.status == 'Cancelled'
                                  ? false
                                  : true,
                          title: orderModel!.status == 'Cancelled'
                              ? const Text('Cancelled')
                              : const Text('Received'),
                          content: Container(),
                        ),
                        Step(
                          isActive: orderModel!.accept == true ? true : false,
                          title: const Text('Accepted'),
                          content: Container(),
                        ),
                        Step(
                          isActive:
                              orderModel!.acceptDelivery == true ? true : false,
                          title: const Text('Processing'),
                          content: Container(),
                        ),
                        Step(
                          isActive:
                              orderModel!.status == 'Completed' ? true : false,
                          title: const Text('Completed'),
                          content: Container(),
                        )
                      ],
                    ),
                  ]),
            ),
          );
  }
}
