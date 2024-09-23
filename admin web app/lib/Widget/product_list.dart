import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import '../Models/products_model.dart';
import 'edit_product.dart';
import 'product_detail_widget.dart';

class ProductList extends StatefulWidget {
  final String marketID;
  const ProductList({super.key, required this.marketID});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Stream<List<ProductsModel>> getMyProducts() {
    return FirebaseFirestore.instance
        .collection('Products')
        .where('marketID', isEqualTo: widget.marketID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductsModel.fromMap(doc.data(), doc.id))
          .toList();
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

  @override
  void initState() {
    getCurrencySymbol();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductsModel>>(
        stream: getMyProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext buildContext, int index) {
                ProductsModel productModel = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => ProductDetails(
                                currency: currencySymbol,
                                productsModel: productModel,
                              ));
                    },
                    child: SizedBox(
                        height: 220,
                        child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      productModel.image1 == ''
                                          ? 'https://pixsector.com/cache/517d8be6/av5c8336583e291842624.png'
                                          : productModel.image1,
                                      height: 110,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Text(productModel.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                            flex: 5,
                                            child: Text(
                                              productModel.description,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '$currencySymbol${productModel.unitPrice1.toString()}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 20),
                                          Text(
                                              '$currencySymbol${productModel.unitOldPrice1.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontWeight: FontWeight.bold)),
                                        ])
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (builder) {
                                                return AlertDialog(
                                                  title:
                                                      Text(productModel.name),
                                                  content: const Text(
                                                          'Are you sure you want to delete this product?')
                                                      .tr(),
                                                  actions: [
                                                    InkWell(
                                                        onTap: () {
                                                          // FirebaseFirestore
                                                          //     .instance
                                                          //     .collection(
                                                          //         'Products')
                                                          //     .doc(productModel
                                                          //         .uid)
                                                          //     .delete()
                                                          //     .then((value) {
                                                          //   Navigator.pop(context);
                                                          //   Fluttertoast.showToast(
                                                          //       msg:
                                                          //           "Product has been deleted Successfully"
                                                          //               .tr(),
                                                          //       toastLength: Toast
                                                          //           .LENGTH_SHORT,
                                                          //       gravity:
                                                          //           ToastGravity
                                                          //               .TOP,
                                                          //       timeInSecForIosWeb:
                                                          //           1,
                                                          //       backgroundColor:
                                                          //           Theme.of(
                                                          //                   context)
                                                          //               .primaryColor,
                                                          //       textColor:
                                                          //           Colors
                                                          //               .white,
                                                          //       fontSize: 14.0);
                                                          // });
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "You can't delete this because its a test mode"
                                                                      .tr(),
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor: Theme
                                                                      .of(
                                                                          context)
                                                                  .primaryColor,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 14.0);
                                                        },
                                                        child: const Text('Yes')
                                                            .tr()),
                                                    const SizedBox(width: 50),
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('No')
                                                            .tr())
                                                  ],
                                                );
                                              });
                                        },
                                        child: const Icon(Icons.delete)),
                                    InkWell(
                                        onTap: () {
                                          if (MediaQuery.of(context)
                                                  .size
                                                  .width >=
                                              1100) {
                                            showDialog(
                                                builder: (context) =>
                                                    AlertDialog(
                                                      // title: Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .spaceBetween,
                                                      //   children: [
                                                      //     const Text(
                                                      //         'Add a new product'),
                                                      //     InkWell(
                                                      //         onTap: () {
                                                      //           Navigator.pop(
                                                      //               context);
                                                      //         },
                                                      //         child: const Icon(
                                                      //             Icons.clear))
                                                      //   ],
                                                      // ),
                                                      content: EditProduct(
                                                        productsModel:
                                                            productModel,
                                                      ),
                                                    ),
                                                context: context);
                                          } else {
                                            showDialog(
                                                builder: (context) => Material(
                                                      child: EditProduct(
                                                        productsModel:
                                                            productModel,
                                                      ),
                                                    ),
                                                context: context);
                                          }
                                        },
                                        child: const Icon(Icons.edit))
                                  ],
                                ),
                              )
                            ]))),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: MediaQuery.of(context).size.width >= 1100
                    ? 3
                    : MediaQuery.of(context).size.width > 600 &&
                            MediaQuery.of(context).size.width < 1200
                        ? 2
                        : 2,
                childAspectRatio:
                    MediaQuery.of(context).size.width >= 1100 ? 1.1 : 0.76,
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: GridView.builder(
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: 190,
                              width: double.infinity,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              )),
                        ),
                        itemCount: 10,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: MediaQuery.of(context).size.width >=
                                  1100
                              ? 3
                              : MediaQuery.of(context).size.width > 600 &&
                                      MediaQuery.of(context).size.width < 1200
                                  ? 2
                                  : 2,
                          childAspectRatio:
                              MediaQuery.of(context).size.width >= 1100
                                  ? 1.1
                                  : 0.76,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
