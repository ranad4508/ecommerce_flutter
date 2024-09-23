import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../Models/currency_formatter.dart';
import '../Models/order_model.dart';

class OrdersDatatable extends StatefulWidget {
  final String getcurrencySymbol;
  const OrdersDatatable({
    super.key,
    required this.getcurrencySymbol,
  });
  @override
  State<OrdersDatatable> createState() => _OrdersDatatableState();
}

class _OrdersDatatableState extends State<OrdersDatatable> {
  List<OrderModel2> orders = [];

  Future<List<OrderModel2>> fetAllOrders() async {
    FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Received')
        .orderBy('timeCreated')
        .limit(8)
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
            orders.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
          });
        }
      }
    });
    return orders;
  }

  @override
  void initState() {
    fetAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: MediaQuery.of(context).size.width >= 1100
          ? Axis.vertical
          : Axis.horizontal,
      child: DataTable(
          dividerThickness: 2,
          columns: <DataColumn>[
            DataColumn(
              label: const Text('Order ID', style: TextStyle()).tr(),
            ),
            DataColumn(
              label: const Text('Amount', style: TextStyle()).tr(),
            ),
            DataColumn(
              label: const Text('Order time', style: TextStyle()).tr(),
            ),
            DataColumn(
              label: const Text('Status', style: TextStyle()).tr(),
            ),
          ],
          rows: orders.map((e) {
            return DataRow(
              cells: [
                DataCell(
                    Text('#${e.orderID.toString()}', style: const TextStyle())),
                DataCell(Text(
                    '${widget.getcurrencySymbol}${CurrencyFormatter().converter(e.total.toDouble())}',
                    style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(
                    Text(e.timeCreated.toString(), style: const TextStyle())),
                DataCell(Container(
                    height: 20,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: e.status == "Received"
                            ? const Text('Received', style: TextStyle()).tr()
                            : const Text('')))),
              ],
            );
          }).toList()),
    );
  }
}
