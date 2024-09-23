// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rider_app/Model/cart_model.dart';
import 'package:rider_app/Model/formatter.dart';
import 'package:rider_app/Model/products_model.dart';
import 'package:rider_app/Widgets/cat_image_widget.dart';
//import 'package:rider_app/Widgets/footer_widget.dart';
import 'package:rider_app/Widgets/review_widget.dart';

class ProductDetailMobileViewWidget extends StatefulWidget {
  final String productID;
  const ProductDetailMobileViewWidget({super.key, required this.productID});

  @override
  State<ProductDetailMobileViewWidget> createState() =>
      _ProductDetailMobileViewWidgetState();
}

class _ProductDetailMobileViewWidgetState
    extends State<ProductDetailMobileViewWidget> {
  ProductsModel? productsModel;
  int current = 0;
  num quantity = 1;
  String currency = '';
  List<String> images = [];
  bool isFavorite = false;
  int selectedValue = 1;
  num selectedPrice = 0;
  num price = 0;
  String selectedProduct = '';
  final CarouselController _controller = CarouselController();

  bool isLoading = true;
  getProductDetail() {
    context.loaderOverlay.show();
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productID)
        .get()
        .then((event) {
      if (event.exists) {
        context.loaderOverlay.hide();
        setState(() {
          isLoading = false;
          var prod = ProductsModel.fromMap(event.data(), event.id);
          productsModel = prod;
        });
      } else {
        FirebaseFirestore.instance
            .collection('Flash Sales')
            .doc(widget.productID)
            .get()
            .then((event) {
          if (event.exists) {
            context.loaderOverlay.hide();
            setState(() {
              isLoading = false;
              var prod = ProductsModel.fromMap(event.data(), event.id);
              productsModel = prod;
            });
          } else {
            FirebaseFirestore.instance
                .collection('Hot Deals')
                .doc(widget.productID)
                .get()
                .then((event) {
              if (event.exists) {
                context.loaderOverlay.hide();
                setState(() {
                  isLoading = false;
                  var prod = ProductsModel.fromMap(event.data(), event.id);
                  productsModel = prod;
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    getProductDetail();
    //  getFavorite();
    getAuth();
    getCurrency();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProductDetailMobileViewWidget oldWidget) {
    getProductDetail();
    //  getFavorite();
    getAuth();
    getCurrency();
    getCurrency();
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    super.didUpdateWidget(oldWidget);
  }

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

  addToFavorite(ProductsModel productsModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Favorites')
        .doc(productsModel.productID)
        .set(productsModel.toMap())
        .then((val) {
      Fluttertoast.showToast(
          msg: "Product has been added to your favorites".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    });
  }

  removeFromFavorite() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Favorites')
        .doc(productsModel!.productID)
        .delete()
        .then((val) {
      Fluttertoast.showToast(
          msg: "Product has been removed from your favorites".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    });
  }

  List<String> favorites = [];
  List<String> initFavorite = [];
  getFavorite() {
    List<String> cartsMain = [];
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Favorites')
        .snapshots()
        .listen((event) {
      favorites.clear();
      for (var element in event.docs) {
        cartsMain.add(element['productID']);
        setState(() {
          favorites = cartsMain;
          initFavorite = favorites;
        });
      }
    });
  }

  bool isLogged = false;
  getAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
        });
      } else {
        setState(() {
          isLogged = true;
        });
        // getCart();
        // getFullName();
        getFavorite();
      }
    });
  }

  addToCart(CartModel productsModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .collection('Cart')
        .doc('${productsModel.name}${getSelectedProduct()}')
        .set(productsModel.toMap())
        .then((val) {
      Fluttertoast.showToast(
          msg: "Product has been added to your cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 14.0);
    });
  }

  getSelectedProduct() {
    if (selectedProduct == '') {
      return productsModel!.unitname1;
    } else {
      return selectedProduct;
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (isLoading == false) {
      List<String> imagesValue = [
        productsModel!.image1,
        productsModel!.image2 == ''
            ? productsModel!.image1
            : productsModel!.image2,
        productsModel!.image3 == ''
            ? productsModel!.image1
            : productsModel!.image3,
      ];
      images = imagesValue;
    }
    return Scaffold(
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              if (isLoading == true) const Gap(10),
              isLoading == true
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity, // Set the width as needed
                              height: MediaQuery.of(context).size.height /
                                  2.5, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 200, // Set the width as needed
                              height: 15, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 300, // Set the width as needed
                              height: 14, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 400, // Set the width as needed
                              height: 15, // Set the height as needed
                              color: Colors.grey, // Set the color as needed
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Gap(30),
                          SizedBox(
                            width: double.infinity,
                            //  height: 500,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(10),
                                Column(
                                  children: [
                                    const Gap(10),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CarouselSlider.builder(
                                              carouselController: _controller,
                                              itemCount: images.length,
                                              itemBuilder: (_, index,
                                                  int pageViewIndex) {
                                                return CatImageWidget(
                                                    url: images[index],
                                                    boxFit: 'cover');
                                              },
                                              options: CarouselOptions(
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      current = index;
                                                    });
                                                  },
                                                  enlargeCenterPage: true,
                                                  aspectRatio: 0.8,
                                                  autoPlay: true,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.5)),
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: IconButton(
                                              iconSize: 40,
                                              onPressed: () {
                                                _controller.previousPage();
                                              },
                                              icon: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                      child: Icon(
                                                          Icons.chevron_left))),
                                              color: Colors.white,
                                            )),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              iconSize: 40,
                                              onPressed: () {
                                                _controller.nextPage();
                                              },
                                              icon: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                      child: Icon(Icons
                                                          .chevron_right))),
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Gap(20),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Gap(20),
                                      Text(
                                        productsModel!.name,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          Text(
                                            '$currency${Formatter().converter(productsModel!.unitPrice1.toDouble())}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Gap(5),
                                          Text(
                                            '$currency${Formatter().converter(productsModel!.unitOldPrice1.toDouble())}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                          const Gap(5),
                                          productsModel!.percantageDiscount == 0
                                              ? const SizedBox.shrink()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Container(
                                                      color: Colors.orange,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Text(
                                                          '-${productsModel!.percantageDiscount}%',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      )),
                                                )
                                        ],
                                      ),
                                      const Gap(5),
                                      Text(
                                        'Unit: ${productsModel!.unitname1}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const Gap(5),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: productsModel!
                                                        .totalRating ==
                                                    0
                                                ? 0
                                                : productsModel!.totalRating
                                                        .toDouble() /
                                                    productsModel!
                                                        .totalNumberOfUserRating
                                                        .toDouble(),
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            direction: Axis.horizontal,
                                          ),
                                          Text(
                                            '(${productsModel!.totalNumberOfUserRating})',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                      const Gap(10),
                                      const Text(
                                        'Variants:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ).tr(),
                                      const Gap(10),
                                      RadioListTile(
                                          title: Text(productsModel!.unitname1),
                                          secondary: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '$currency${Formatter().converter(productsModel!.unitPrice1.toDouble())} ',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel!.unitOldPrice1.toDouble())}',
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough))
                                              ],
                                            ),
                                          ),
                                          value: 1,
                                          groupValue: selectedValue,
                                          onChanged: (v) {
                                            setState(() {
                                              selectedValue = v!;
                                              selectedPrice =
                                                  productsModel!.unitPrice1;
                                              selectedProduct =
                                                  productsModel!.unitname1;
                                            });
                                          }),
                                      if (productsModel!.unitname2.isNotEmpty)
                                        RadioListTile(
                                            title:
                                                Text(productsModel!.unitname2),
                                            secondary: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel!.unitPrice2.toDouble())} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel!.unitOldPrice2.toDouble())}',
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                ],
                                              ),
                                            ),
                                            value: 2,
                                            groupValue: selectedValue,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedValue = v!;
                                                selectedPrice =
                                                    productsModel!.unitPrice2;
                                                selectedProduct =
                                                    productsModel!.unitname2;
                                              });
                                            }),
                                      if (productsModel!.unitname3.isNotEmpty)
                                        RadioListTile(
                                            title:
                                                Text(productsModel!.unitname3),
                                            secondary: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel!.unitPrice3.toDouble())} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel!.unitOldPrice3.toDouble())}',
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                ],
                                              ),
                                            ),
                                            value: 3,
                                            groupValue: selectedValue,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedValue = v!;
                                                selectedPrice =
                                                    productsModel!.unitPrice3;
                                                selectedProduct =
                                                    productsModel!.unitname3;
                                              });
                                            }),
                                      if (productsModel!.unitname4.isNotEmpty)
                                        RadioListTile(
                                            title:
                                                Text(productsModel!.unitname4),
                                            secondary: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel!.unitPrice4.toDouble())} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel!.unitOldPrice4.toDouble())}',
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                ],
                                              ),
                                            ),
                                            value: 4,
                                            groupValue: selectedValue,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedValue = v!;
                                                selectedPrice =
                                                    productsModel!.unitPrice4;
                                                selectedProduct =
                                                    productsModel!.unitname4;
                                              });
                                            }),
                                      if (productsModel!.unitname5.isNotEmpty)
                                        RadioListTile(
                                            title:
                                                Text(productsModel!.unitname5),
                                            secondary: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel!.unitPrice5.toDouble())} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel!.unitOldPrice5.toDouble())}',
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                ],
                                              ),
                                            ),
                                            value: 5,
                                            groupValue: selectedValue,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedValue = v!;
                                                selectedPrice =
                                                    productsModel!.unitPrice5;
                                                selectedProduct =
                                                    productsModel!.unitname5;
                                              });
                                            }),
                                      if (productsModel!.unitname6.isNotEmpty)
                                        RadioListTile(
                                            title:
                                                Text(productsModel!.unitname6),
                                            secondary: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel!.unitPrice6.toDouble())} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel!.unitOldPrice6.toDouble())}',
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                ],
                                              ),
                                            ),
                                            value: 6,
                                            groupValue: selectedValue,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedValue = v!;
                                                selectedPrice =
                                                    productsModel!.unitPrice6;
                                                selectedProduct =
                                                    productsModel!.unitname6;
                                              });
                                            }),
                                      if (productsModel!.unitname7.isNotEmpty)
                                        RadioListTile(
                                            title:
                                                Text(productsModel!.unitname7),
                                            secondary: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '$currency${Formatter().converter(productsModel!.unitPrice7.toDouble())} ',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          '$currency${Formatter().converter(productsModel!.unitOldPrice7.toDouble())}',
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                ],
                                              ),
                                            ),
                                            value: 7,
                                            groupValue: selectedValue,
                                            onChanged: (v) {
                                              setState(() {
                                                selectedValue = v!;
                                                selectedPrice =
                                                    productsModel!.unitPrice7;
                                                selectedProduct =
                                                    productsModel!.unitname7;
                                              });
                                            }),
                                      const Gap(20),
                                      // const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          const Text(
                                            'Quantity:',
                                            style: TextStyle(fontSize: 12),
                                          ).tr(),
                                          const Gap(10),
                                          SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)
                                                          // border: Border(
                                                          //     top: BorderSide(
                                                          //         color: Colors
                                                          //             .grey),
                                                          //     bottom: BorderSide(
                                                          //         color: Colors
                                                          //             .grey),
                                                          //     right:
                                                          //         BorderSide
                                                          //             .none,
                                                          //     left: BorderSide
                                                          //         .none)
                                                          ),
                                                      child: Center(
                                                          child: Text(
                                                              productsModel!
                                                                  .quantity
                                                                  .toString())),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      const Gap(20),
                                      Row(
                                        children: [
                                          const Text(
                                            'Brand:',
                                            style: TextStyle(fontSize: 12),
                                          ).tr(),
                                          const Gap(10),
                                          SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)
                                                          // border: Border(
                                                          //     top: BorderSide(
                                                          //         color: Colors
                                                          //             .grey),
                                                          //     bottom: BorderSide(
                                                          //         color: Colors
                                                          //             .grey),
                                                          //     right:
                                                          //         BorderSide
                                                          //             .none,
                                                          //     left: BorderSide
                                                          //         .none)
                                                          ),
                                                      child: Center(
                                                          child: Text(
                                                              productsModel!
                                                                  .brand
                                                                  .toString())),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      const Gap(10),
                                      const Divider(
                                          color: Color.fromARGB(
                                              255, 243, 236, 236)),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              //  const Gap(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Product Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Helvetica',
                      ),
                    ).tr(),
                  ],
                ),
              ),
              if (isLoading == true) const Gap(10),
              if (isLoading == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isLoading == false)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(productsModel!.description),
                      )),
                ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Return Policy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Helvetica',
                      ),
                    ).tr(),
                  ],
                ),
              ),
              if (isLoading == true) const Gap(10),
              if (isLoading == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isLoading == false)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(productsModel!.returnDuration == 0
                            ? 'No return policy'
                            : '${productsModel!.returnDuration} Day Return Guarantee'),
                      )),
                ),
              const Gap(20),
              // const Gap(20),
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 120, right: 100)
                    : const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Text(
                      'Reviews & Ratings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Helvetica',
                      ),
                    ).tr(),
                  ],
                ),
              ),
              if (isLoading == true) const Gap(10),
              if (isLoading == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300, // Set the width as needed
                            height: 14, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 400, // Set the width as needed
                            height: 15, // Set the height as needed
                            color: Colors.grey, // Set the color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isLoading == false)
                ReviewWidget(
                  productUID: productsModel!.productID,
                ),
              const Gap(20),

              //const FooterWidget()
            ],
          )),
    );
  }
}
