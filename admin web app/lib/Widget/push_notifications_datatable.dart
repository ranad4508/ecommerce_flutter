import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../Models/push_notifications.dart';

class PushNotificationsData extends StatefulWidget {
  const PushNotificationsData({super.key});

  @override
  State<PushNotificationsData> createState() => _PushNotificationsDataState();
}

class _PushNotificationsDataState extends State<PushNotificationsData> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  final bool _sortAscending = true;

  Stream<QuerySnapshot>? yourStream;

  List<PushNotificationsModel> users = [];
  List<PushNotificationsModel> usersFilter = [];

  getUsersData() async {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance
        .collection('Push Notifications')
        .orderBy('timeCreated', descending: true)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      users.clear();
      for (var element in event.docs) {
        var prods = PushNotificationsModel(
            uid: element['uid'],
            category: element['category'],
            timeCreated: element['timeCreated'].toDate(),
            title: element['title'],
            detail: element['detail']);
        // ignore: avoid_print
        print('Users are $prods');
        setState(() {
          users.add(prods);
          // ignore: avoid_print
          print('User length is ${users.length}');
        });
      }
    });
  }

  String displayName = '';
  void onSearchTextChanged(String text) {
    setState(() {
      displayName = text;
      usersFilter = users
          .where((user) =>
              user.category.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    getUsersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoaded == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Push Notifications Messages').tr(),
                      ],
                    ),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (int? value) {
                      setState(() {
                        _rowsPerPage = value!;
                      });
                    },
                    source: VendorDataSource(
                        displayName == '' ? users : usersFilter, context),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      DataColumn(
                        label: const Text('Index').tr(),
                      ),
                      DataColumn(
                        label: const Text('Title').tr(),
                      ),
                      DataColumn(
                        label: const Text('Message').tr(),
                      ),
                      DataColumn(
                        label: const Text('Time Created').tr(),
                      ),
                      DataColumn(
                        label: const Text('Category').tr(),
                      ),
                      DataColumn(
                        label: const Text('Manage').tr(),
                      ),
                    ],
                  ),
                ],
              ));
  }
}

int numberOfdelivery = 0;

List<int> categoriesAmount = [];

class VendorDataSource extends DataTableSource {
  final List<PushNotificationsModel> vendor;
  final BuildContext context;
  VendorDataSource(this.vendor, this.context);

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= vendor.length) return null;
    final PushNotificationsModel result = vendor[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${index + 1}')),
      DataCell(Text(result.title)),
      DataCell(Text(result.detail)),
      DataCell(Text(result.timeCreated.toString())),
      DataCell(Text(result.category)),
      DataCell(Row(
        children: [
          OutlinedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Push Notifications')
                    .doc(result.uid)
                    .delete()
                    .then((value) {
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    title: "Notification",
                    message: "notification deleted successfully!!!",
                    duration: const Duration(seconds: 3),
                  ).show(context);
                });
              },
              child: const Text('Delete').tr()),
        ],
      )),
    ]);
  }

  @override
  int get rowCount => vendor.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
