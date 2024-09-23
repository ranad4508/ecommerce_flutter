import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../Model/products_model.dart';
import '../Widgets/add_product_from_page.dart';
import '../Widgets/edit_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool isLoaded = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int? _sortColumnIndex;
  final bool _sortAscending = true;
  Stream<QuerySnapshot>? yourStream;
  @override
  void initState() {
    getCurrencySymbol();
    getStatus();
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
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('Products')
        .where('vendorId', isEqualTo: user!.uid)
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

  bool approval = false;

  getStatus() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        approval = event['approval'];
      });
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

  @override
  Widget build(BuildContext context) {
    var vendorData = VendorDataSource(
        displayName == '' ? products : productsFilter, context, currencySymbol);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          if (approval == false) {
            Fluttertoast.showToast(
                msg: "Account is under review".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 14.0);
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
        child: const Icon(Icons.add),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoaded == true
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue))
              : ListView(
                  shrinkWrap: true,
                  children: [
                    PaginatedDataTable(
                      columnSpacing: 30,
                      showFirstLastButtons: true,
                      header: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: TextField(
                              onChanged: onSearchTextChanged,
                              style: const TextStyle(color: Colors.grey),
                              decoration: InputDecoration(
                                focusColor: Colors.grey,
                                hintText: 'Search for Products'.tr(),
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
                )),
    );
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
          DataCell(TextButton(
              // style: ButtonStyle(
              //   elevation: MaterialStateProperty.all(0),
              //   backgroundColor: MaterialStateProperty.all<Color>(
              //     Colors.blue.shade800,
              //   ),
              // ),
              onPressed: () {
                context.push('/product-detail/${result.uid}');
              },
              child: const Text('View Detail').tr())),
          DataCell(Row(
            children: [
              TextButton(
                  // style: ButtonStyle(
                  //   elevation: MaterialStateProperty.all(0),
                  //   backgroundColor: MaterialStateProperty.all<Color>(
                  //     Colors.blue.shade800,
                  //   ),
                  // ),
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
              TextButton(
                  // style: ButtonStyle(
                  //   elevation: MaterialStateProperty.all(0),
                  //   backgroundColor: MaterialStateProperty.all<Color>(
                  //     Colors.blue.shade800,
                  //   ),
                  // ),
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
