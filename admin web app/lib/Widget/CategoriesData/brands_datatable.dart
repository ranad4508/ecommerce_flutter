import 'package:admin_web_app/Models/brand_model.dart';
import 'package:admin_web_app/Widget/CategoriesData/add_brand.dart';
import 'package:another_flushbar/flushbar.dart';
// import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class BrandsData extends StatefulWidget {
  const BrandsData({super.key});

  @override
  State<BrandsData> createState() => _BrandsDataState();
}

class _BrandsDataState extends State<BrandsData> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  final bool _sortAscending = true;

  @override
  void initState() {
    getBrands();
    super.initState();
  }

  List<BrandModel> brands = [];
  List<BrandModel> brandsFilter = [];
  getBrands() {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance.collection('Brands').snapshots().listen((event) {
      setState(() {
        isLoaded = false;
      });
      brands.clear();
      for (var e in event.docs) {
        var c = BrandModel.fromMap(e.data(), e.id);
        setState(() {
          brands.add(c);
        });
      }
    });
  }

  String displayName = '';
  void onSearchTextChanged(String text) {
    setState(() {
      displayName = text;
      brandsFilter = brands
          .where((user) =>
              user.collection.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MediaQuery.of(context).size.width >= 1100
          ? null
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return const AddBrand();
                    });
              },
              backgroundColor: Colors.blue.shade800,
              child: const Icon(
                Icons.add,
              ),
            ),
      body: isLoaded == true
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  PaginatedDataTable(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Brands',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ).tr(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width >= 1100
                                ? MediaQuery.of(context).size.width / 2
                                : MediaQuery.of(context).size.width / 2,
                            child: TextField(
                                onChanged: onSearchTextChanged,
                                style: const TextStyle(color: Colors.grey),
                                decoration: InputDecoration(
                                  focusColor: Colors.grey,
                                  hintText: 'Search'.tr(),
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
                        if (MediaQuery.of(context).size.width >= 1100)
                          ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.blue.shade800,
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return const AddBrand();
                                    });
                              },
                              child: const Text(
                                'Add a new brand',
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
                    source: VendorDataSource(
                        displayName == '' ? brands : brandsFilter, context),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      DataColumn(
                        label: const Text(
                          'Index',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Logo Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Background Image',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Category',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Manage',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                    ],
                  ),
                ],
              )),
    );
  }
}

int numberOfdelivery = 0;

List<int> categoriesAmount = [];

class VendorDataSource extends DataTableSource {
  final List<BrandModel> vendor;
  final BuildContext context;
  VendorDataSource(this.vendor, this.context);

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= vendor.length) return null;
    final BrandModel result = vendor[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text('${index + 1}')),
      DataCell(result.image == ''
          ? Container()
          : Image.network(result.image, width: 50, height: 50)),
      DataCell(result.backgroundImage == ''
          ? Container()
          : Image.network(result.backgroundImage, width: 50, height: 50)),
      DataCell(Text(result.collection)),
      DataCell(Text(result.category)),
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
                    builder: (context) {
                      return AlertDialog(
                        content:
                            const Text('Are you sure you want to delete this?')
                                .tr(),
                        actions: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel").tr()),
                          // const Gap(10),
                          InkWell(
                              onTap: () {
                                // Fluttertoast.showToast(
                                //     msg:
                                //         "You can't delete this because its a test mode"
                                //             .tr(),
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.TOP,
                                //     timeInSecForIosWeb: 1,
                                //     backgroundColor:
                                //         Theme.of(context).primaryColor,
                                //     textColor: Colors.white,
                                //     fontSize: 14.0);
                                FirebaseFirestore.instance
                                    .collection('Brands')
                                    .doc(result.uid)
                                    .delete()
                                    .then((value) {
                                  Navigator.pop(context);
                                  Flushbar(
                                    flushbarPosition: FlushbarPosition.TOP,
                                    title: "Notification",
                                    message: "Brand deleted successfully!!!",
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                  });
                              },
                              child: const Text('Yes').tr())
                        ],
                      );
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
