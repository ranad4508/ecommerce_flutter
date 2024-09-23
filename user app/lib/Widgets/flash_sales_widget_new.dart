import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/products_model.dart';
import 'package:user_app/Widgets/product_widget_main.dart';
import 'package:user_app/Widgets/timer_basic.dart';

import '../Model/feeds.dart';
import 'timer_frame.dart';

class FlashSalesWidgetNew extends StatefulWidget {
  const FlashSalesWidgetNew({super.key});

  @override
  State<FlashSalesWidgetNew> createState() => _FlashSalesWidgetNewState();
}

class _FlashSalesWidgetNewState extends State<FlashSalesWidgetNew> {
  String flashSales = '';
  getFlashSalesTime() {
    FirebaseFirestore.instance
        .collection('Flash Sales Time')
        .doc('Flash Sales Time')
        .snapshots()
        .listen((event) {
      setState(() {
        flashSales = event['Flash Sales Time'];
      });
    });
  }

  Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionPath);

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }
  }

  bool reverse = false;
  @override
  void initState() {
    getFlashSalesTime();
    // getBanner();
    getProducts();

    super.initState();
  }

  List<ProductsModel> products = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = false;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    FirebaseFirestore.instance
        .collection('Flash Sales')
        .limit(8)
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

  int current = 0;
  bool isHovered = false;
  bool isLast = true;
  FeedsModel? banner1;
  // FeedsModel? banner2;
  List<FeedsModel> feeds = [];
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
        // banner2 = feeds[random.nextInt(feeds.length)];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width >= 1100
          ? const EdgeInsets.only(left: 50, right: 50)
          : const EdgeInsets.all(0),
      child: Column(
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.width >= 1100 ? 50 : 40,
            width: double.infinity,
            // decoration: BoxDecoration(
            //     color: appColor,
            //     borderRadius: MediaQuery.of(context).size.width >= 1100
            //         ? const BorderRadius.only(
            //             topLeft: Radius.circular(5),
            //             topRight: Radius.circular(5))
            //         : const BorderRadius.all(Radius.zero)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Flash Sales',
                    style: TextStyle(
                        // color: Colors.white,
                        fontFamily: 'LilitaOne',
                        // fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width >= 1100
                            ? 30
                            : 20),
                  ).tr(),
                ),
                // if (MediaQuery.of(context).size.width >= 1100)
                //   if (flashSales.isNotEmpty)
                //     SlideCountdownSeparated(
                //       separatorType: SeparatorType.title,
                //       decoration: const BoxDecoration(
                //         color: Color.fromARGB(255, 247, 240, 240),
                //       ),
                //       style: const TextStyle(
                //           color: Colors.black, fontSize: 18),
                //       duration: difference,
                //       onDone: () {
                //         deleteAllDocumentsInCollection('Flash Sales');
                //       },
                //     ),
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
                        context.push('/flash-sales');
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AdaptiveTheme.of(context).mode.isDark == true
                                ? Colors.white
                                : Colors.black,
                            fontSize: MediaQuery.of(context).size.width >= 1100
                                ? 15
                                : 12),
                      ).tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoaded == true
              ? SizedBox(
                  // height: 250,
                  //   width: double.infinity,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
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
                          ));
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 5 : 2),
                  ),
                )
              : MediaQuery.of(context).size.width >= 1100
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: TimerFrame(
                              description: 'Limited Offer Is Available',
                              timer: TimerBasic(
                                format: CountDownTimerFormat
                                    .daysHoursMinutesSeconds,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: products.length,
                              shrinkWrap: true,
                              itemBuilder: (
                                _,
                                index,
                              ) {
                                ProductsModel productsModel = products[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ProductWidgetMain(
                                      productsModel: productsModel),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          MediaQuery.of(context).size.width >=
                                                  1100
                                              ? 0.6
                                              : 0.65,
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width >=
                                                  1100
                                              ? 4
                                              : 2),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: TimerFrame(
                            description: 'Limited Offer Is Available',
                            timer: TimerBasic(
                              format:
                                  CountDownTimerFormat.daysHoursMinutesSeconds,
                            ),
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: products.length,
                            shrinkWrap: true,
                            itemBuilder: (
                              _,
                              index,
                            ) {
                              ProductsModel productsModel = products[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ProductWidgetMain(
                                    productsModel: productsModel),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio:
                                        MediaQuery.of(context)
                                                    .size
                                                    .width >=
                                                1100
                                            ? 0.6
                                            : 0.65,
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width >=
                                                1100
                                            ? 4
                                            : 2),
                          ),
                        ),
                      ],
                    )
        ],
      ),
    );
  }
}
