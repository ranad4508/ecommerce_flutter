import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Widgets/products_by_cat_widget.dart';

import '../Model/feeds.dart';
import 'brands_widget.dart';
import 'last_banner_widget.dart';

class ProductsByCatHomePageWidget extends StatefulWidget {
  const ProductsByCatHomePageWidget({super.key});

  @override
  State<ProductsByCatHomePageWidget> createState() =>
      _ProductsByCatHomePageWidgetState();
}

class _ProductsByCatHomePageWidgetState
    extends State<ProductsByCatHomePageWidget> {
  String cat1 = '';
  String cat2 = '';
  String cat3 = '';
  String cat4 = '';
  String cat5 = '';

  bool loaded = false;
  List<String> categories = [];

  getCategoriesTabs() {
    setState(() {
      loaded = true;
    });
    List<String> dataMain = [];
    FirebaseFirestore.instance
        .collection('Categories')
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        setState(() {
          loaded = false;
        });
        dataMain.add(element['category']);
        setState(() {
          categories = dataMain;
          // ignore: avoid_print
          print('Cat2 is $categories');
        });
      }
    });
  }

  @override
  void initState() {
    getCategoriesTabs();
    getBanner();
    super.initState();
  }

  FeedsModel? banner1;
  FeedsModel? banner2;
  List<FeedsModel> feeds = [];
  bool isLoaded = true;
  getBanner() {
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

        // print(isLoaded = false);
      }
      Random random = Random();
      setState(() {
        banner1 = feeds[random.nextInt(feeds.length)];
        banner2 = feeds[random.nextInt(feeds.length)];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    cat1 = categories[0];
    cat2 = categories[1];
    cat3 = categories[2];
    cat4 = categories[3];
    cat5 = categories[4];
    return Column(
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width >= 1100
              ? const EdgeInsets.only(left: 50, right: 50)
              : const EdgeInsets.all(0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cat1,
                      style: TextStyle(
                          // color: Colors.white,
                          fontFamily: 'LilitaOne',
                          // fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 30
                              : 20),
                    ).tr(),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CountdownTimer(
                  //     textStyle: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: MediaQuery.of(context).size.width >= 1100
                  //             ? 18
                  //             : 15),
                  //     endTime:
                  //         DateTime.parse(flashSales).millisecondsSinceEpoch,
                  //     onEnd: () {
                  //       // FirebaseFirestore.instance
                  //       //     .collection('Flash Sales Products')
                  //       //     .doc(productModel.uid)
                  //       //     .delete();
                  //       deleteAllDocumentsInCollection('Flash Sales');
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.all(8.0),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {
                          context.push('/products/$cat1');
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AdaptiveTheme.of(context).mode.isDark == true?Colors.white: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width >= 1100
                                      ? 15
                                      : 12),
                        ).tr(),
                      ),
                    ),
                  ),
                ],
              ),
              loaded == true
                  ? Card(
                      semanticContainer: false,
                      shape: const Border.fromBorderSide(BorderSide.none),
                      color: MediaQuery.of(context).size.width >= 1100
                          ? Colors.white
                          : null,
                      elevation: MediaQuery.of(context).size.width >= 1100
                          ? 0.5
                          : null,
                      child: SizedBox(
                        height: 200,
                        //   width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 170.0,
                                height: double.infinity,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 330,
                      width: double.infinity,
                      child: ProductsByCatWidget(
                        cat: cat1,
                      ))
            ],
          ),
        ),
        // if (MediaQuery.of(context).size.width >= 1100)
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 50, right: 50)
                : const EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cat2,
                        style: TextStyle(
                            // color: Colors.white,
                            fontFamily: 'LilitaOne',
                            // fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width >= 1100
                                    ? 30
                                    : 20),
                      ).tr(),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: CountdownTimer(
                    //     textStyle: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: MediaQuery.of(context).size.width >= 1100
                    //             ? 18
                    //             : 15),
                    //     endTime:
                    //         DateTime.parse(flashSales).millisecondsSinceEpoch,
                    //     onEnd: () {
                    //       // FirebaseFirestore.instance
                    //       //     .collection('Flash Sales Products')
                    //       //     .doc(productModel.uid)
                    //       //     .delete();
                    //       deleteAllDocumentsInCollection('Flash Sales');
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: MediaQuery.of(context).size.width >= 1100
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(8.0),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () {
                            context.push('/products/$cat2');
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AdaptiveTheme.of(context).mode.isDark == true?Colors.white: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? 15
                                        : 12),
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
                loaded == true
                    ? Card(
                        semanticContainer: false,
                        shape: const Border.fromBorderSide(BorderSide.none),
                        color: MediaQuery.of(context).size.width >= 1100
                            ? Colors.white
                            : null,
                        elevation: MediaQuery.of(context).size.width >= 1100
                            ? 0.5
                            : null,
                        child: SizedBox(
                          height: 200,
                          //   width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 170.0,
                                  height: double.infinity,
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 330,
                        width: double.infinity,
                        child: ProductsByCatWidget(
                          cat: cat2,
                        ))
              ],
            ),
          ),
        const Gap(20),
        Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 50, right: 50)
                : const EdgeInsets.all(0),
            child: const BrandsWidget()),
        const Gap(40),
        const LastBannerWidget(),
        const Gap(20),
        Padding(
          padding: MediaQuery.of(context).size.width >= 1100
              ? const EdgeInsets.only(left: 50, right: 50)
              : const EdgeInsets.all(0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cat3,
                      style: TextStyle(
                          // color: Colors.white,
                          fontFamily: 'LilitaOne',
                          // fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width >= 1100
                              ? 30
                              : 20),
                    ).tr(),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CountdownTimer(
                  //     textStyle: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: MediaQuery.of(context).size.width >= 1100
                  //             ? 18
                  //             : 15),
                  //     endTime:
                  //         DateTime.parse(flashSales).millisecondsSinceEpoch,
                  //     onEnd: () {
                  //       // FirebaseFirestore.instance
                  //       //     .collection('Flash Sales Products')
                  //       //     .doc(productModel.uid)
                  //       //     .delete();
                  //       deleteAllDocumentsInCollection('Flash Sales');
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.all(8.0),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {
                          context.push('/products/$cat3');
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:AdaptiveTheme.of(context).mode.isDark == true?Colors.white: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width >= 1100
                                      ? 15
                                      : 12),
                        ).tr(),
                      ),
                    ),
                  ),
                ],
              ),
              loaded == true
                  ? Card(
                      semanticContainer: false,
                      shape: const Border.fromBorderSide(BorderSide.none),
                      color: MediaQuery.of(context).size.width >= 1100
                          ? Colors.white
                          : null,
                      elevation: MediaQuery.of(context).size.width >= 1100
                          ? 0.5
                          : null,
                      child: SizedBox(
                        height: 200,
                        //   width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 170.0,
                                height: double.infinity,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 330,
                      width: double.infinity,
                      child: ProductsByCatWidget(
                        cat: cat3,
                      ))
            ],
          ),
        ),
        // if (MediaQuery.of(context).size.width >= 1100)
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 50, right: 50)
                : const EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cat4,
                        style: TextStyle(
                            // color: Colors.white,
                            fontFamily: 'LilitaOne',
                            // fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width >= 1100
                                    ? 30
                                    : 20),
                      ).tr(),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: CountdownTimer(
                    //     textStyle: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: MediaQuery.of(context).size.width >= 1100
                    //             ? 18
                    //             : 15),
                    //     endTime:
                    //         DateTime.parse(flashSales).millisecondsSinceEpoch,
                    //     onEnd: () {
                    //       // FirebaseFirestore.instance
                    //       //     .collection('Flash Sales Products')
                    //       //     .doc(productModel.uid)
                    //       //     .delete();
                    //       deleteAllDocumentsInCollection('Flash Sales');
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: MediaQuery.of(context).size.width >= 1100
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(8.0),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () {
                            context.push('/products/$cat4');
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AdaptiveTheme.of(context).mode.isDark == true?Colors.white: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? 15
                                        : 12),
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
                loaded == true
                    ? Card(
                        semanticContainer: false,
                        shape: const Border.fromBorderSide(BorderSide.none),
                        color: MediaQuery.of(context).size.width >= 1100
                            ? Colors.white
                            : null,
                        elevation: MediaQuery.of(context).size.width >= 1100
                            ? 0.5
                            : null,
                        child: SizedBox(
                          height: 200,
                          //   width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 170.0,
                                  height: double.infinity,
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 330,
                        width: double.infinity,
                        child: ProductsByCatWidget(
                          cat: cat4,
                        ))
              ],
            ),
          ),
        // if (MediaQuery.of(context).size.width >= 1100)
          Padding(
            padding: MediaQuery.of(context).size.width >= 1100
                ? const EdgeInsets.only(left: 50, right: 50)
                : const EdgeInsets.all(0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cat5,
                        style: TextStyle(
                            // color: Colors.white,
                            fontFamily: 'LilitaOne',
                            // fontWeight: FontWeight.bold,
                            fontSize:
                                MediaQuery.of(context).size.width >= 1100
                                    ? 30
                                    : 20),
                      ).tr(),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: CountdownTimer(
                    //     textStyle: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: MediaQuery.of(context).size.width >= 1100
                    //             ? 18
                    //             : 15),
                    //     endTime:
                    //         DateTime.parse(flashSales).millisecondsSinceEpoch,
                    //     onEnd: () {
                    //       // FirebaseFirestore.instance
                    //       //     .collection('Flash Sales Products')
                    //       //     .doc(productModel.uid)
                    //       //     .delete();
                    //       deleteAllDocumentsInCollection('Flash Sales');
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: MediaQuery.of(context).size.width >= 1100
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(8.0),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () {
                            context.push('/products/$cat5');
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AdaptiveTheme.of(context).mode.isDark == true?Colors.white: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? 15
                                        : 12),
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
                loaded == true
                    ? Card(
                        semanticContainer: false,
                        shape: const Border.fromBorderSide(BorderSide.none),
                        color: MediaQuery.of(context).size.width >= 1100
                            ? Colors.white
                            : null,
                        elevation: MediaQuery.of(context).size.width >= 1100
                            ? 0.5
                            : null,
                        child: SizedBox(
                          height: 200,
                          //   width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 170.0,
                                  height: double.infinity,
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 330,
                        width: double.infinity,
                        child: ProductsByCatWidget(
                          cat: cat5,
                        ))
              ],
            ),
          )
      ],
    );
  }
}
