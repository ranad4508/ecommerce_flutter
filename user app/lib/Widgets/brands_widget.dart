import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/brand_model.dart';

import '../Model/constant.dart';

class BrandsWidget extends StatefulWidget {
  const BrandsWidget({
    super.key,
  });

  @override
  State<BrandsWidget> createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends State<BrandsWidget> {
  List<BrandModel> cats = [];
  bool isLoading = false;
  getCats() {
    setState(() {
      isLoading = true;
    });
    List<BrandModel> categories = [
      // BrandModel(category: "View All".tr(), image: '')
    ];
    return FirebaseFirestore.instance
        .collection('Brands')
        // .limit(7)
        .snapshots()
        .listen((value) {
      setState(() {
        isLoading = false;
      });
      cats.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices = BrandModel.fromMap(element.data(), element.id);
          categories.insert(0, fetchServices);
          cats = categories;
          //  cats.add(BrandModel(category: "View All".tr(), image: ''));
        });
      }
    });
  }

  @override
  void initState() {
    getCats();
    super.initState();
  }

  int current = 0;
  final CarouselController _controller = CarouselController();
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width >= 1100
              ? const EdgeInsets.only(left: 50, right: 50)
              : const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'BRANDS',
                  style: TextStyle(
                      // color: Colors.white,
                      fontFamily: 'LilitaOne',
                      // fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width >= 1100 ? 30 : 20),
                ).tr(),
              ),
            ],
          ),
        ),
        const Gap(10),
        SizedBox(
          width: double.infinity,
          // height: 200,
          child: isLoading == true
              ? Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: 8, // Number of grid items
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          // margin: EdgeInsets.all(8.0),
                        ),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerRight,
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
                        Expanded(
                          flex: 7,
                          child: CarouselSlider.builder(
                            carouselController: _controller,
                            options: CarouselOptions(
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                initialPage: 0,
                                disableCenter: true,
                                enableInfiniteScroll: true,
                                padEnds: false,
                                aspectRatio: 0.8,
                                viewportFraction:
                                    MediaQuery.of(context).size.width >= 1100
                                        ? 0.18
                                        : 0.8,
                                reverse: false,
                                autoPlay: isHovered == true ? false : true,
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
                                }),
                            itemCount: cats.length,
                            itemBuilder:
                                (BuildContext context, int d, int index) {
                              BrandModel brandModel = cats[d];
                              return BrandLogoWidget(brandModel: brandModel);
                            },
                          ),
                        ),
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
                            ))
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class BrandLogoWidget extends StatefulWidget {
  final BrandModel brandModel;
  const BrandLogoWidget({super.key, required this.brandModel});

  @override
  State<BrandLogoWidget> createState() => _BrandLogoWidgetState();
}

class _BrandLogoWidgetState extends State<BrandLogoWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      onTap: () {
        context.push('/brand/${widget.brandModel.collection}');
      },
      child: Transform.scale(
        scale: MediaQuery.of(context).size.width >= 1100
            ? (isHovered == true ? 1.05 : 1.0)
            : (isHovered == true ? 1 : 1.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AdaptiveTheme.of(context).mode.isDark == true
                  ? Colors.black87
                  : Colors.white,
              // image: DecorationImage(
              //     image: NetworkImage(
              //         brandModel.backgroundImage),
              //     fit: BoxFit.cover,
              //     opacity: 0.4)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromARGB(255, 247, 240, 240),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AdaptiveTheme.of(context).mode.isDark == true
                      ? Colors.black87
                      : Colors.white,
                  // image: DecorationImage(
                  //     image: NetworkImage(
                  //         brandModel.backgroundImage),
                  //     fit: BoxFit.cover,
                  //     opacity: 0.4)
                ),
                child: Center(
                  child: Image.network(
                    widget.brandModel.image,
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.white
                        : Colors.black87,
                    height: 130,
                    width: 130,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
