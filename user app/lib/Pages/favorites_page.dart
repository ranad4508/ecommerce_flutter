import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/products_model.dart';
//import 'package:user_app/Widgets/footer_widget.dart';
import 'package:user_app/Widgets/product_widget_main.dart';
import 'package:user_app/Widgets/web_menu.dart';

import '../Model/constant.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<ProductsModel> products = [];
  List<ProductsModel> initProducts = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = true;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Favorites')
        // .limit(10)
        // .where('category', isEqualTo: widget.category)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      context.loaderOverlay.hide();
      products.clear();
      for (var element in event.docs) {
        var prods = ProductsModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
          initProducts = products;
        });
      }
    });
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Favorites',
        style: TextStyle(fontWeight: FontWeight.bold),
      ).tr()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (MediaQuery.of(context).size.width <= 1100) const Gap(20),
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.only(left: 100, right: 100)
                    : const EdgeInsets.all(0),
                child: Column(
                  children: [
                    const Gap(20),
                    if (MediaQuery.of(context).size.width >= 1100)
                      Align(
                        alignment: MediaQuery.of(context).size.width >= 1100
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                context.push('/');
                              },
                              child: const Text(
                                'Home',
                                style: TextStyle(fontSize: 10),
                              ).tr(),
                            ),
                            const Text(
                              '/ Favorites',
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ],
                        ),
                      ),
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: const Text(
                        'Favorites',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ).tr(),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            if (MediaQuery.of(context).size.width >= 1100)
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Card(
                          shape: BeveledRectangleBorder(),
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          child: WebMenu(path: '/favorites')),
                    ),
                    Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            isLoaded == true
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width >=
                                                  1100
                                              ? 4
                                              : 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemCount: 20,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Container(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 16,
                                                    width: 120,
                                                    color: Colors.grey[300],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    height: 16,
                                                    width: 80,
                                                    color: Colors.grey[300],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : products.isEmpty
                                    ? Center(
                                        child: Column(children: [
                                          Icon(
                                            Icons.remove_shopping_cart,
                                            color: appColor,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                          ),
                                          const Gap(10),
                                          const Text('No Product Was Found')
                                        ]),
                                      )
                                    : GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          ProductsModel productsModel =
                                              products[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: () {
                                                  context.push(
                                                      '/product-detail/${productsModel.uid}');
                                                },
                                                child: ProductWidgetMain(
                                                    productsModel:
                                                        productsModel)),
                                          );
                                        },
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 0.65,
                                                crossAxisCount:
                                                    MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            1100
                                                        ? 4
                                                        : 2,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 5),
                                      ),
                          ]),
                        ))
                  ],
                ),
              ),
            ////////////////////////////////////////////////////// Mobile View /////////////////
            if (MediaQuery.of(context).size.width <= 1100)
              isLoaded == true
                  ? GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 4 : 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  color: Colors.grey[300],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 120,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 16,
                                      width: 80,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : products.isEmpty
                      ? Center(
                          child: Column(children: [
                            Icon(
                              Icons.remove_shopping_cart,
                              color: appColor,
                              size: MediaQuery.of(context).size.height / 3,
                            ),
                            const Gap(10),
                            const Text('No Product Was Found')
                          ]),
                        )
                      : GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            ProductsModel productsModel = products[index];
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: InkWell(
                                  onTap: () {
                                    context.push(
                                        '/product-detail/${productsModel.uid}');
                                  },
                                  child: ProductWidgetMain(
                                      productsModel: productsModel)),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.60,
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width >= 1100
                                          ? 4
                                          : 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                        ),
            const Gap(20),
            //const FooterWidget()
          ],
        ),
      ),
    );
  }
}
