import 'package:admin_web_app/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';

import '../Models/currency_formatter.dart';
import '../Models/order_model.dart';
import '../Widget/order_detail.dart';

class RiderDetail extends StatefulWidget {
  final UserModel userModel;
  const RiderDetail({super.key, required this.userModel});

  @override
  State<RiderDetail> createState() => _RiderDetailState();
}

class _RiderDetailState extends State<RiderDetail> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  String deliveryBoyID = '';
  Stream<QuerySnapshot>? yourStream;
  @override
  void initState() {
    getCurrencySymbol();
    getCurrencyDetails();
    getApprovalStatus();
    fetAllOrders();
    // yourStream = FirebaseFirestore.instance.collection('Products').snapshots();
    super.initState();
  }

  Future<List<OrderModel2>> fetAllOrders() async {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('deliveryBoyID', isEqualTo: widget.userModel.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((data) {
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
          });
        }
      }
      orders.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
    });
    return orders;
  }

  int numberOfdelivery = 0;

  List<OrderModel2> orders = [];
  List<int> deliveryBoyAmount = [];
  String currencySymbol = '';

  getCurrencySymbol() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        currencySymbol = value['Currency symbol'];
      });
    });
  }

  List<OrderModel2> ordersFilter = [];
  String displayName = '';
  void onSearchTextChanged(String text) {
    setState(() {
      displayName = text;
      ordersFilter = orders
          .where((user) => user.orderID
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    });
  }

  // List<ProductsModel> allProducts = [
  //   ProductsModel(
  //     uid: '78',
  //     productID: '78',
  //     name: 'Wooden Desk Pen Holder',
  //     category: 'Office',
  //     collection: 'Office Accessories',
  //     subCollection: 'Pen Holders',
  //     description:
  //         'Stylish wooden desk pen holder, perfect for organizing your desk.',
  //     vendorId: '',
  //     vendorName: '',
  //     endFlash: null,
  //     totalRating: 0,
  //     totalNumberOfUserRating: 0,
  //     quantity: 20,
  //     returnDuration: 30,
  //     brand: '', // Empty brand
  //     unitname1: 'Wooden Desk Pen Holder',
  //     unitname2: '',
  //     unitname3: '',
  //     unitname4: '',
  //     unitname5: '',
  //     unitname6: '',
  //     unitname7: '',
  //     unitPrice1: 12,
  //     unitPrice2: 0,
  //     unitPrice3: 0,
  //     unitPrice4: 0,
  //     unitPrice5: 0,
  //     unitPrice6: 0,
  //     unitPrice7: 0,
  //     unitOldPrice1: 12,
  //     unitOldPrice2: 0,
  //     unitOldPrice3: 0,
  //     unitOldPrice4: 0,
  //     unitOldPrice5: 0,
  //     unitOldPrice6: 0,
  //     unitOldPrice7: 0,
  //     percantageDiscount: 0,
  //     image1: 'https://m.media-amazon.com/images/I/616fqIBrtuS._AC_SL1000_.jpg',
  //     image2: 'https://m.media-amazon.com/images/I/616fqIBrtuS._AC_SL1000_.jpg',
  //     image3: 'https://m.media-amazon.com/images/I/616fqIBrtuS._AC_SL1000_.jpg',
  //   ),
  //   ProductsModel(
  //     uid: '79',
  //     productID: '79',
  //     name: 'Metal Mesh Pen Organizer',
  //     category: 'Office',
  //     collection: 'Office Accessories',
  //     subCollection: 'Pen Holders',
  //     description:
  //         'Durable metal mesh pen organizer, keeps your pens and pencils neatly stored.',
  //     vendorId: '',
  //     vendorName: '',
  //     endFlash: null,
  //     totalRating: 0,
  //     totalNumberOfUserRating: 0,
  //     quantity: 18,
  //     returnDuration: 30,
  //     brand: '', // Empty brand
  //     unitname1: 'Metal Mesh Pen Organizer',
  //     unitname2: '',
  //     unitname3: '',
  //     unitname4: '',
  //     unitname5: '',
  //     unitname6: '',
  //     unitname7: '',
  //     unitPrice1: 8,
  //     unitPrice2: 0,
  //     unitPrice3: 0,
  //     unitPrice4: 0,
  //     unitPrice5: 0,
  //     unitPrice6: 0,
  //     unitPrice7: 0,
  //     unitOldPrice1: 8,
  //     unitOldPrice2: 0,
  //     unitOldPrice3: 0,
  //     unitOldPrice4: 0,
  //     unitOldPrice5: 0,
  //     unitOldPrice6: 0,
  //     unitOldPrice7: 0,
  //     percantageDiscount: 0,
  //     image1: 'm',
  //     image2: '',
  //     image3: '',
  //   ),
  // ];
  // post() {
  //   for (var element in allProducts) {
  //     FirebaseFirestore.instance.collection('Products').doc(element.uid).set({
  //       'returnDuration': element.returnDuration,
  //       'endFlash': element.endFlash,
  //       'totalRating': element.totalRating,
  //       'totalNumberOfUserRating': element.totalNumberOfUserRating,
  //       'vendorName': element.vendorName,
  //       //  'marketID':element. marketID,
  //       'quantity': element.quantity,
  //       'name': element.name,
  //       'description': element.description,
  //       'category': element.category,
  //       'collection': element.collection,
  //       'subCollection': element.subCollection,
  //       'image1': element.image1,
  //       'image2': element.image2,
  //       'image3': element.image3,
  //       'unitname1': element.unitname1,
  //       'unitname2': element.unitname2,
  //       'unitname3': element.unitname3,
  //       'unitname4': element.unitname4,
  //       'unitname5': element.unitname5,
  //       'unitname6': element.unitname6,
  //       'unitname7': element.unitname7,
  //       'unitPrice1': element.unitPrice1,
  //       'unitPrice2': element.unitPrice2,
  //       'unitPrice3': element.unitPrice3,
  //       'unitPrice4': element.unitPrice4,
  //       'unitPrice5': element.unitPrice5,
  //       'unitPrice6': element.unitPrice6,
  //       'unitPrice7': element.unitPrice7,
  //       'unitOldPrice1': element.unitOldPrice1,
  //       'unitOldPrice2': element.unitOldPrice2,
  //       'unitOldPrice3': element.unitOldPrice3,
  //       'unitOldPrice4': element.unitOldPrice4,
  //       'unitOldPrice5': element.unitOldPrice5,
  //       'unitOldPrice6': element.unitOldPrice6,
  //       'unitOldPrice7': element.unitOldPrice7,
  //       'percantageDiscount': element.percantageDiscount,
  //       'vendorId': element.vendorId,
  //       'brand': element.brand,
  //       'productID': element.productID
  //     }).then((value) {
  //       // ignore: avoid_print
  //       print('Worked');
  //     });
  //   }
  // }
  bool approval = false;
  getApprovalStatus() {
    FirebaseFirestore.instance
        .collection('riders')
        .doc(widget.userModel.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        approval = event['approval'];
      });
    });
  }

  String getcurrencySymbol = '';

  getCurrencyDetails() {
    FirebaseFirestore.instance
        .collection('Currency Settings')
        .doc('Currency Settings')
        .get()
        .then((value) {
      setState(() {
        // getcurrencyName = value['Currency name'];
        // getcurrencyCode = value['Currency code'];
        getcurrencySymbol = value['Currency symbol'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoaded == true
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : ListView(
                shrinkWrap: true,
                children: [
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  const Gap(10),
                  Text('Name: ${widget.userModel.displayName}'),
                  const Gap(10),
                  Text('Phone: ${widget.userModel.phonenumber}'),
                  const Gap(10),
                  Text('Email Address: ${widget.userModel.email}'),
                  const Gap(10),
                  Text('Address: ${widget.userModel.address}'),
                  const Gap(10),
                  CheckboxListTile(
                      title: const Text(
                        'Approval Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: approval,
                      onChanged: (v) {
                        setState(() {
                          approval = !approval;

                          FirebaseFirestore.instance
                              .collection('riders')
                              .doc(widget.userModel.uid)
                              .update({'approval': approval});
                        });
                      }),
                  Text(
                    '${widget.userModel.displayName} Orders',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ).tr(),
                  const Gap(10),
                  PaginatedDataTable(
                      showCheckboxColumn: false,
                      header: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width >= 1100
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width / 1.5,
                              child: TextField(
                                  onChanged: onSearchTextChanged,
                                  style: const TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    focusColor: Colors.grey,
                                    hintText:
                                        'Search for Orders by Oder ID'.tr(),
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 25,
                                      color: Colors.blue.shade800,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white10,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      // header: const Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Orders'),
                      //   ],
                      // ),
                      rowsPerPage: _rowsPerPage,
                      onRowsPerPageChanged: (int? value) {
                        setState(() {
                          _rowsPerPage = value!;
                        });
                      },
                      sortColumnIndex: _sortColumnIndex,
                      columns: <DataColumn>[
                        DataColumn(
                          label: const Text('Order ID',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              .tr(),
                        ),
                        DataColumn(
                          label: const Text('Order status',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              .tr(),
                        ),
                        DataColumn(
                          label: const Text('Time created',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              .tr(),
                        ),
                        // DataColumn(
                        //   label: const Text('User name'),
                        // ),
                        DataColumn(
                          label: const Text(
                            'Total price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).tr(),
                          numeric: true,
                        ),
                        DataColumn(
                          label: const Text('Address',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              .tr(),
                          numeric: true,
                        ),
                        DataColumn(
                          label: const Text('View Orders',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              .tr(),
                          numeric: true,
                        ),
                      ],
                      source: ResultsDataSource(
                          displayName.isEmpty ? orders : ordersFilter,
                          getcurrencySymbol,
                          context)),
                ],
              ));
  }
}

class ResultsDataSource extends DataTableSource {
  final List<OrderModel2> orders;
  final String getcurrencySymbol;
  final BuildContext context;
  ResultsDataSource(this.orders, this.getcurrencySymbol, this.context);

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= orders.length) return null;
    final OrderModel2 result = orders[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('#${result.orderID}')),
      DataCell(Text(result.status)),
      DataCell(Text('${result.timeCreated}')),
      // DataCell(Text('${result.userID}')),
      DataCell(Text(
        '$getcurrencySymbol${CurrencyFormatter().converter(result.total.toDouble())}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      )),
      DataCell(result.deliveryAddress == ''
          ? Align(
              alignment: Alignment.center,
              child: const Text(
                'Pick Up',
                textAlign: TextAlign.center,
              ).tr(),
            )
          : SizedBox(
              width: 150,
              child: Text(
                result.deliveryAddress,
                overflow: TextOverflow.ellipsis,
              ))),
      DataCell(ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.blue.shade800,
            ),
          ),
          onPressed: () {
            if (MediaQuery.of(context).size.width >= 1100) {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                        content: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: OrderDetail(orderModel: result)));
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return Material(child: OrderDetail(orderModel: result));
                  });
            }
          },
          child: const Text('View Detail').tr())),
    ]);
  }

  @override
  int get rowCount => orders.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
