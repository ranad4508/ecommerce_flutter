import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:admin_web_app/Widget/order_detail.dart';

import '../../Models/currency_formatter.dart';
import '../../Models/order_model.dart';

class AllOrders extends StatefulWidget {
  final String status;
  const AllOrders({super.key, required this.status});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
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
        getcurrencySymbol = value['Currency symbol'];
      });
    });
  }

  String deliveryBoyID = '';

  @override
  void initState() {
    fetAllOrders();
    getCurrencyDetails();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: PaginatedDataTable(
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
                          hintText: 'Search for Orders by Oder ID'.tr(),
                          hintStyle: const TextStyle(color: Colors.grey),
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
            showCheckboxColumn: false,
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
      ),
    );
  }

  Future<List<OrderModel2>> fetAllOrders() async {
    if (widget.status == 'All') {
      FirebaseFirestore.instance
          .collection('Orders')
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
    } else {
      FirebaseFirestore.instance
          .collection('Orders')
          .where('status', isEqualTo: widget.status)
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
  }
}

int numberOfdelivery = 0;

List<OrderModel2> orders = [];
List<int> deliveryBoyAmount = [];

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
