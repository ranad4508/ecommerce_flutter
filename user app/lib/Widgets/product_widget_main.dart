import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/Model/cart_model.dart';
import 'package:user_app/Model/formatter.dart';
import 'package:user_app/Model/products_model.dart';
import 'package:user_app/Widgets/cat_image_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Model/constant.dart';

class ProductWidgetMain extends StatefulWidget {
  final ProductsModel productsModel;
  const ProductWidgetMain({super.key, required this.productsModel});

  @override
  State<ProductWidgetMain> createState() => _ProductWidgetMainState();
}

class _ProductWidgetMainState extends State<ProductWidgetMain> {
  String currency = '';
  @override
  void initState() {
    getCurrency();
    getAuth();
    super.initState();
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

  bool isLogged = false;
  getAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          isLogged = false;
          carts.clear();
          favorites.clear();
        });
      } else {
        setState(() {
          isLogged = true;
        });
        // getCart();
        // getFullName();
        getFavorites();
        getCarts();
      }
    });
  }

  addToFavorite(ProductsModel productsModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Favorites')
        .doc(widget.productsModel.productID)
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
        .collection('users')
        .doc(user!.uid)
        .collection('Favorites')
        .doc(widget.productsModel.productID)
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
  getFavorites() {
    List<String> cartsMain = [];
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
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

  void resetToInitialList() {
    setState(() {
      favorites = List.from(initFavorite);
    });
  }

  addToCart(CartModel productsModel) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Cart')
        .doc('${productsModel.name}${productsModel.unitname1}')
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

  List<String> carts = [];
  getCarts() {
    List<String> cartsMain = [];
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Cart')
        .snapshots()
        .listen((event) {
      carts.clear();
      for (var element in event.docs) {
        cartsMain.add(element['productID']);
        setState(() {
          carts = cartsMain;
        });
      }
    });
  }

  Future<void> deleteCart(
      String id, String productname, String selectedUnit) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    firestore
        .collection('users')
        .doc(user!.uid)
        .collection('Cart')
        .doc('$productname$selectedUnit')
        .delete()
        .then((value) {
      setState(() {
        carts.remove(id);
      });

      const SnackBar(
        content: Text('Product has been removed'),
      );
    });
  }

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // context.push('/product-detail/${widget.productsModel.uid}');
      },
      onHover: (value) {
        // ignore: avoid_print
        print('is hovering $value');
        setState(() {
          isHovered = value;
        });
      },
      child: Transform.scale(
        scale: MediaQuery.of(context).size.width >= 1100
            ? (isHovered == true ? 1.05 : 1.0)
            : (isHovered == true ? 1 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).mode.isDark == true
                ? Colors.black87
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(
            //     color: const Color.fromARGB(255, 214, 212, 212),
            //     width: isHovered == true ? 1.5 : 0.8,
            //     style: BorderStyle.solid)
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black38,
            //     offset: const Offset(
            //       1.0,
            //       1.0,
            //     ),
            //     blurRadius: 1.0,
            //     spreadRadius: 0.0,
            //   ), //BoxShadow
            //   BoxShadow(
            //     color: Colors.white,
            //     offset: const Offset(0.0, 0.0),
            //     blurRadius: 0.0,
            //     spreadRadius: 0.0,
            //   ), //BoxShadow
            // ],
          ),
          child: SizedBox(
            // height: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Gap(10),
                Stack(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                            height: 170,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: CatImageWidget(
                                url: widget.productsModel.image1,
                                boxFit: 'cover',
                              ),
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: FadeIn(
                            duration: const Duration(milliseconds: 100),
                            animate: isHovered,
                            child: Container(
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  context.push(
                                      '/product-detail/${widget.productsModel.uid}');
                                },
                                child: const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    widget.productsModel.percantageDiscount == 0
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: appColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '-${widget.productsModel.percantageDiscount}%',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          ),
                    favorites.contains(widget.productsModel.productID) == true
                        ? (isHovered == false &&
                                MediaQuery.of(context).size.width >= 1100)
                            ? const SizedBox.shrink()
                            : Align(
                                alignment: Alignment.topRight,
                                child: SlideInRight(
                                  duration: const Duration(milliseconds: 500),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        removeFromFavorite();
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: appColor),
                                        child: const Center(
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                        : (isHovered == false &&
                                MediaQuery.of(context).size.width >= 1100)
                            ? const SizedBox.shrink()
                            : Align(
                                alignment: Alignment.topRight,
                                child: SlideInRight(
                                  duration: const Duration(milliseconds: 500),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (isLogged == false) {
                                          context.push('/login');
                                        } else {
                                          addToFavorite(widget.productsModel);
                                        }
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey),
                                        child: const Center(
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                  ],
                ),
                // const Divider(
                //   color: Color.fromARGB(255, 214, 212, 212),
                //   thickness: 0.2,
                // ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      widget.productsModel.name,

                      maxLines: 1,
                      // textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: MediaQuery.of(context).size.width <= 1100
                              ? 12
                              : null),
                    ),
                  ),
                ),

                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           '$currency${Formatter().converter(widget.productsModel.unitPrice1.toDouble())}',
                //           style: const TextStyle(fontWeight: FontWeight.bold),
                //           // maxLines: 1,
                //           // textAlign: TextAlign.start,
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$currency${Formatter().converter(widget.productsModel.unitPrice1.toDouble())}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width <= 1100
                                      ? 12
                                      : null),
                          // maxLines: 1,
                          // textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$currency${Formatter().converter(widget.productsModel.unitOldPrice1.toDouble())}',
                          style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                          // maxLines: 1,
                          // textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: [
                        RatingBarIndicator(
                          rating: widget.productsModel.totalRating == 0
                              ? 0
                              : widget.productsModel.totalRating.toDouble() /
                                  widget.productsModel.totalNumberOfUserRating
                                      .toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 10.0,
                          direction: Axis.horizontal,
                        ),
                        Text(
                          '(${widget.productsModel.totalNumberOfUserRating})',
                          style: const TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.all(8.0)
                      : const EdgeInsets.all(8.0),
                  child: carts.contains(widget.productsModel.productID) == true
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: appColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          onPressed: () {
                            if (isLogged == false) {
                              context.push('/login');
                            } else {
                              deleteCart(
                                  widget.productsModel.productID,
                                  widget.productsModel.name,
                                  widget.productsModel.unitname1);
                            }
                          },
                          child: Text(
                            "Add to cart",
                            style: TextStyle(
                                color: AdaptiveTheme.of(context).mode.isDark ==
                                        true
                                    ? Colors.black
                                    : Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? null
                                        : 10),
                          ).tr())
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              //  backgroundColor: appColor,
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                          onPressed: () {
                            if (isLogged == false) {
                              context.push('/login');
                            } else {
                              addToCart(CartModel(
                                  returnDuration:
                                      widget.productsModel.returnDuration,
                                  totalNumberOfUserRating: widget
                                      .productsModel.totalNumberOfUserRating,
                                  totalRating: widget.productsModel.totalRating,
                                  productID: widget.productsModel.productID,
                                  price: widget.productsModel.unitPrice1,
                                  selectedPrice:
                                      widget.productsModel.unitPrice1,
                                  quantity: 1,
                                  selected: widget.productsModel.unitname1,
                                  description: widget.productsModel.description,
                                  marketID: '',
                                  marketName: widget.productsModel.marketName,
                                  uid: widget.productsModel.uid,
                                  name: widget.productsModel.name,
                                  category: widget.productsModel.category,
                                  subCollection:
                                      widget.productsModel.subCollection,
                                  collection: widget.productsModel.collection,
                                  image1: widget.productsModel.image1,
                                  image2: widget.productsModel.image2,
                                  image3: widget.productsModel.image3,
                                  unitname1: widget.productsModel.unitname1,
                                  unitname2: widget.productsModel.unitname2,
                                  unitname3: widget.productsModel.unitname3,
                                  unitname4: widget.productsModel.unitname4,
                                  unitname5: widget.productsModel.unitname5,
                                  unitname6: widget.productsModel.unitname6,
                                  unitname7: widget.productsModel.unitname7,
                                  unitPrice1: widget.productsModel.unitPrice1,
                                  unitPrice2: widget.productsModel.unitPrice2,
                                  unitPrice3: widget.productsModel.unitPrice3,
                                  unitPrice4: widget.productsModel.unitPrice4,
                                  unitPrice5: widget.productsModel.unitPrice5,
                                  unitPrice6: widget.productsModel.unitPrice6,
                                  unitPrice7: widget.productsModel.unitPrice7,
                                  unitOldPrice1:
                                      widget.productsModel.unitOldPrice1,
                                  unitOldPrice2:
                                      widget.productsModel.unitOldPrice2,
                                  unitOldPrice3:
                                      widget.productsModel.unitOldPrice3,
                                  unitOldPrice4:
                                      widget.productsModel.unitOldPrice4,
                                  unitOldPrice5:
                                      widget.productsModel.unitOldPrice5,
                                  unitOldPrice6:
                                      widget.productsModel.unitOldPrice6,
                                  unitOldPrice7:
                                      widget.productsModel.unitOldPrice7,
                                  percantageDiscount:
                                      widget.productsModel.percantageDiscount,
                                  vendorId: widget.productsModel.vendorId,
                                  brand: widget.productsModel.brand));
                            }
                          },
                          child: Text(
                            "Add to cart",
                            style: TextStyle(
                                color: AdaptiveTheme.of(context).mode.isDark ==
                                        true
                                    ? Colors.white
                                    : Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? null
                                        : 10),
                          ).tr()),
                ),
                const Gap(5)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
