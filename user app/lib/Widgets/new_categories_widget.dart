import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../Model/categories.dart';
import '../Model/constant.dart';

class NewCategoriesWidget extends StatefulWidget {
  const NewCategoriesWidget({
    super.key,
  });

  @override
  State<NewCategoriesWidget> createState() => _NewCategoriesWidgetState();
}

class _NewCategoriesWidgetState extends State<NewCategoriesWidget> {
  List<CategoriesModel> cats = [];
  bool isLoading = false;
  getCats() {
    setState(() {
      isLoading = true;
    });
    List<CategoriesModel> categories = [
      // CategoriesModel(category: "View All".tr(), image: '')
    ];
    return FirebaseFirestore.instance
        .collection('Categories')
        // .limit(7)
        .snapshots()
        .listen((value) {
      setState(() {
        isLoading = false;
      });
      cats.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices =
              CategoriesModel.fromMap(element.data(), element.id);
          categories.add(fetchServices);
          cats = categories;
          //  cats.add(CategoriesModel(category: "View All".tr(), image: ''));
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (MediaQuery.of(context).size.width >= 1100) const SizedBox(),
              Center(
                child: Padding(
                  padding: MediaQuery.of(context).size.width >= 1100
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                        // color: Colors.white,
                        fontFamily: 'LilitaOne',
                        // fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width >= 1100
                            ? 30
                            : 20),
                  ).tr(),
                ),
              ),
              Padding(
                padding: MediaQuery.of(context).size.width >= 1100
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.previousPage();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: appColor, shape: BoxShape.circle),
                        child: const Icon((Icons.arrow_back),
                            size: 20, color: Colors.white),
                      ),
                    ),
                    const Gap(10),
                    InkWell(
                      onTap: () {
                        _controller.nextPage();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: appColor, shape: BoxShape.circle),
                        child: const Icon((Icons.arrow_forward),
                            size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Gap(10),
        Padding(
          padding: MediaQuery.of(context).size.width >= 1100
              ? const EdgeInsets.only(left: 50, right: 50)
              : const EdgeInsets.all(0),
          child: SizedBox(
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
                      child: CarouselSlider.builder(
                        carouselController: _controller,
                        options: CarouselOptions(
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            initialPage: 0,
                            disableCenter: true,
                            enableInfiniteScroll: false,
                            padEnds: false,
                            aspectRatio: 2,
                            viewportFraction:
                                MediaQuery.of(context).size.width >= 1100
                                    ? 0.14
                                    : 0.47,
                            reverse: false,
                            autoPlay: false,
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
                        itemBuilder: (BuildContext context, int d, int index) {
                          CategoriesModel categoriesModel = cats[d];
                          return CaeegoriesLogoWidget(
                              categoriesModel: categoriesModel);
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class CaeegoriesLogoWidget extends StatefulWidget {
  final CategoriesModel categoriesModel;
  const CaeegoriesLogoWidget({super.key, required this.categoriesModel});

  @override
  State<CaeegoriesLogoWidget> createState() => _CaeegoriesLogoWidgetState();
}

class _CaeegoriesLogoWidgetState extends State<CaeegoriesLogoWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: MediaQuery.of(context).size.width >= 1100
          ? (isHovered == true ? 1.07 : 1.0)
          : (isHovered == true ? 1 : 1.0),
      child: InkWell(
          hoverColor: Colors.transparent,
          onHover: (value) {
            setState(() {
              isHovered = value;
            });
          },
          onTap: () {
            context.push('/products/${widget.categoriesModel.category}');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: AdaptiveTheme.of(context).mode.isDark == true
                  ? Colors.black87
                  : Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      // width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // border: Border.all(width: 1.5),
                          // color: Colors.white,
                          image: DecorationImage(
                              image: NetworkImage(widget.categoriesModel.image),
                              fit: BoxFit.cover,
                            )),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    widget.categoriesModel.category,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(5),
                ],
              ),
            ),
          )),
    );
  }
}
