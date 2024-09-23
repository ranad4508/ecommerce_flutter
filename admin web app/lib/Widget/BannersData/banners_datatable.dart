import 'package:admin_web_app/Widget/BannersData/view_banner.dart';
import 'package:another_flushbar/flushbar.dart';
//import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_web_app/Models/feeds.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'add_banner.dart';

class BannersDatatable extends StatefulWidget {
  const BannersDatatable({super.key});

  @override
  State<BannersDatatable> createState() => _BannersDatatableState();
}

class _BannersDatatableState extends State<BannersDatatable> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  final bool _sortAscending = true;

  Stream<QuerySnapshot>? yourStream;
  @override
  void initState() {
    getFeeds();
    super.initState();
  }

  List<FeedsModel> feeds = [];
  List<FeedsModel> feedsFilter = [];
  getFeeds() {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance.collection('Banners').snapshots().listen((v) {
      setState(() {
        isLoaded = false;
      });
      feeds.clear();
      for (var e in v.docs) {
        var c = FeedsModel.fromMap(e.data(), e.id);
        setState(() {
          feeds.add(c);
        });
        // ignore: avoid_print
        print(isLoaded = false);
      }
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
                  PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Banners',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ).tr(),
                        ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue.shade800,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return const AddBanner();
                                  });
                            },
                            child: const Text(
                              'Add new banner',
                              style: TextStyle(color: Colors.white),
                            ).tr())
                      ],
                    ),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (int? value) {
                      setState(() {
                        _rowsPerPage = value!;
                      });
                    },
                    source: VendorDataSource(feeds, context),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      DataColumn(
                        label: const Text(
                          'Index',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Banner',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Category',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Slider',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Manage',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
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
  final List<FeedsModel> vendor;
  final BuildContext context;
  VendorDataSource(this.vendor, this.context);

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= vendor.length) return null;
    final FeedsModel result = vendor[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${index + 1}')),
      DataCell(Text(result.title)),
      DataCell(result.image == ''
          ? Container()
          : Image.network(result.image, width: 50, height: 50)),
      DataCell(Text(result.category)),
      DataCell(Text(result.slider.toString())),
      DataCell(Row(
        children: [
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue.shade800,
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return ViewBanner(
                        categoriesModel: result,
                      );
                    });
              },
              child: const Text('View details').tr()),
          const SizedBox(
            width: 5,
          ),
          ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue.shade800,
                ),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Banners')
                    .doc(result.uid)
                    .delete()
                    .then((value) {
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    title: "Notification",
                    message: "Deleted successfully!!!",
                    duration: const Duration(seconds: 3),
                  ).show(context);
                 });
                // Fluttertoast.showToast(
                //     msg: "You can't delete this because its a test mode".tr(),
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.TOP,
                //     timeInSecForIosWeb: 1,
                //     backgroundColor: Theme.of(context).primaryColor,
                //     textColor: Colors.white,
                //     fontSize: 14.0);
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
