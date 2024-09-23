//import 'package:another_flushbar/flushbar.dart';
// import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_web_app/Models/products_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:admin_web_app/Widget/product_detail_widget.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

import 'add_product_from_page.dart';
import 'edit_product.dart';

class ProductsDatatable extends StatefulWidget {
  const ProductsDatatable({super.key});

  @override
  State<ProductsDatatable> createState() => _ProductsDatatableState();
}

class _ProductsDatatableState extends State<ProductsDatatable> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  final bool _sortAscending = true;
  String deliveryBoyID = '';
  Stream<QuerySnapshot>? yourStream;
  @override
  void initState() {
    getCurrencySymbol();
    getProducts();
    yourStream = FirebaseFirestore.instance.collection('Products').snapshots();
    super.initState();
  }

  List<ProductsModel> products = [];
  List<ProductsModel> productsFilter = [];

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance
        .collection('Products')
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      products.clear();
      for (var element in event.docs) {
        var prods = ProductsModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
        });
      }
    });
  }

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

  String displayName = '';
  void onSearchTextChanged(String text) {
    setState(() {
      displayName = text;
      productsFilter = products
          .where((user) => user.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    var vendorData = VendorDataSource(
        displayName == '' ? products : productsFilter, context, currencySymbol);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoaded == true
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : ListView(
                shrinkWrap: true,
                children: [
                  PaginatedDataTable(
                    columnSpacing: 30,
                    showFirstLastButtons: true,
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Products',
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
                                  hintText: 'Search for Products'.tr(),
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
                        MediaQuery.of(context).size.width >= 1100
                            ? ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.blue.shade800,
                                  ),
                                ),
                                onPressed: () {
                                  if (MediaQuery.of(context).size.width >=
                                      1100) {
                                    showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child:
                                                  const AddProductsFromPage(),
                                            ),
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return const Material(
                                            child: AddProductsFromPage(),
                                          );
                                        });
                                  }
                                },
                                child: const Text(
                                  'Add a new product',
                                  style: TextStyle(color: Colors.white),
                                ).tr())
                            : const SizedBox(),
                      ],
                    ),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (int? value) {
                      setState(() {
                        _rowsPerPage = value!;
                      });
                    },
                    source: vendorData,
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
                          'Product Picture',
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
                          'Collection',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Sub Collection',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'Brand',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      DataColumn(
                        label: const Text(
                          'View Detail',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                      ),
                      const DataColumn(
                        label: Text(
                          'Manage',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
  }
}

int numberOfdelivery = 0;

List<int> deliveryBoyAmount = [];

class VendorDataSource extends DataTableSource {
  final List<ProductsModel> vendor;
  final String currencySymbol;
  final BuildContext context;
  VendorDataSource(this.vendor, this.context, this.currencySymbol);

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= vendor.length) return null;
    final ProductsModel result = vendor[index];
    return DataRow.byIndex(
        index: index,
        //  selected: result.selected,
        cells: <DataCell>[
          DataCell(Text('${index + 1}')),
          DataCell(result.image1 == ''
              ? Container()
              : Image.network(result.image1, width: 50, height: 50)),
          DataCell(SizedBox(
            width: 100,
            child: Text(
              result.name,
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Text(
            result.category,
          )),
          DataCell(Text(
            result.collection,
          )),
          DataCell(Text(
            result.subCollection,
          )),
          DataCell(Text(
            result.brand,
          )),
          DataCell(ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue.shade800,
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => MediaQuery.of(context).size.width >=
                            1100
                        ? AlertDialog(
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: ProductDetails(
                                currency: currencySymbol,
                                productsModel: result,
                              ),
                            ),
                          )
                        : ProductDetails(
                            currency: currencySymbol,
                            productsModel: result,
                          ));
              },
              child: const Text('View Detail').tr())),
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
                        builder: (context) =>
                            MediaQuery.of(context).size.width >= 1100
                                ? AlertDialog(
                                    content: EditProduct(
                                      productsModel: result,
                                    ),
                                    // title: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment
                                    //             .spaceBetween,
                                    //     children: [
                                    //       const Text(
                                    //           'Edit Product'),
                                    //       IconButton(
                                    //           onPressed: () {
                                    //             Modular.to
                                    //                 .pop();
                                    //           },
                                    //           icon: const Icon(
                                    //               Icons.cancel))
                                    //     ]),
                                  )
                                : Material(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: double.infinity,
                                      child: EditProduct(
                                        productsModel: result,
                                      ),
                                    ),
                                  ),
                        context: context);
                  },
                  child: const Text('Edit').tr()),
              const SizedBox(width: 10),
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
                          return AlertDialog(
                            title: Text(result.name),
                            content: const Text(
                                    'Are you sure you want to delete this product?')
                                .tr(),
                            actions: [
                              InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('Products')
                                        .doc(result.uid)
                                        .delete()
                                        .then((value) {
                                      context.pop();
                                      Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        title: "Notification".tr(),
                                        message: "Deleted successfully!!!".tr(),
                                        duration: const Duration(seconds: 3),
                                      ).show(context);
                                    });
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
                                  },
                                  child: const Text('Yes').tr()),
                              const SizedBox(width: 50),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No').tr())
                            ],
                          );
                        });
                  },
                  child: const Text('Delete').tr())
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
