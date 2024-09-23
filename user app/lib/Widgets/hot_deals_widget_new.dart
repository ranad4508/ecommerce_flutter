import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/products_model.dart';
import '../Model/constant.dart';
import 'product_widget_main.dart';

class HotDealsWidgetNew extends StatefulWidget {
  const HotDealsWidgetNew({super.key});

  @override
  State<HotDealsWidgetNew> createState() => _HotDealsWidgetNewState();
}

class _HotDealsWidgetNewState extends State<HotDealsWidgetNew> {
  bool reverse = false;
  @override
  void initState() {
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
        .collection('Hot Deals')
        .limit(7)
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
  final CarouselController _controller = CarouselController();
  bool isHovered = false;
  bool isLast = true;
  bool stopHovering = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  'Hot Deals',
                  style: TextStyle(
                      // color: Colors.white,
                      fontFamily: 'LilitaOne',
                      // fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 30 : 20),
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
                      context.push('/hot-deals');
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
          isLoaded == true
              ? SizedBox(
                  height: 370,
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
                )
              : MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHovered = false;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 320,
                        width: double.infinity,
                        child: CarouselSlider.builder(
                          carouselController: _controller,
                          itemCount: products.length,
                          itemBuilder: (_, index, int pageViewIndex) {
                            ProductsModel productsModel = products[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onHover: (value) {
                                    setState(() {
                                      stopHovering = value;
                                    });
                                  },
                                  onTap: () {
                                    if (MediaQuery.of(context).size.width <=
                                        1100) {
                                      context.push(
                                          '/product-detail/${productsModel.uid}');
                                    }
                                  },
                                  child: ProductWidgetMain(
                                      productsModel: productsModel)),
                            );
                          },
                          options: CarouselOptions(
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                              initialPage: 0,
                              disableCenter: true,
                              enableInfiniteScroll: true,
                              viewportFraction: MediaQuery.of(context)
                                          .size
                                          .width >=
                                      1100
                                  ? 0.18
                                  : MediaQuery.of(context).size.width > 600 &&
                                          MediaQuery.of(context).size.width <
                                              1200
                                      ? 0.3
                                      : 0.5,
                              padEnds: false,
                              aspectRatio: 0.8,
                              reverse: false,
                              autoPlay: stopHovering == true ? false : true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              // onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  current = index;
                                  // ignore: avoid_print
                                  print('current is $current');
                                });
                                if (index == 5) {
                                  setState(() {
                                    isLast = false;
                                  });
                                } else {
                                  setState(() {
                                    isLast = true;
                                  });
                                }
                              }),
                        ),
                      ),
                      if (MediaQuery.of(context).size.width >= 1100)
                        isHovered == false
                            ? const SizedBox.shrink()
                            : current == 0
                                ? const SizedBox.shrink()
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          _controller.previousPage();
                                        },
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: appColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                                child: Icon(
                                              Icons.chevron_left,
                                              color: Colors.white,
                                            ))),
                                      ),
                                    )),
                      if (MediaQuery.of(context).size.width >= 1100)
                        isHovered == false
                            ? const SizedBox.shrink()
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _controller.nextPage();
                                    },
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: appColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                            child: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                        ))),
                                  ),
                                )),
                      if (MediaQuery.of(context).size.width <= 1100)
                        current == 0
                            ? const SizedBox.shrink()
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _controller.previousPage();
                                    },
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: appColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                            child: Icon(
                                          Icons.chevron_left,
                                          color: Colors.white,
                                        ))),
                                  ),
                                )),
                      if (MediaQuery.of(context).size.width <= 1100)
                        Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  _controller.nextPage();
                                },
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ))),
                              ),
                            )),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
