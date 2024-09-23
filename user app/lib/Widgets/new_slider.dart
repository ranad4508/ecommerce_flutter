// ignore_for_file: avoid_print

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../Model/constant.dart';
import '../Model/feeds.dart';

class NewSliderWidget extends StatefulWidget {
  const NewSliderWidget({
    super.key,
  });

  @override
  State<NewSliderWidget> createState() => _NewSliderWidgetState();
}

class _NewSliderWidgetState extends State<NewSliderWidget> {
  List<FeedsModel> feeds = [];
  bool isLoading = true;
  getFeeds() {
    setState(() {
      isLoading = true;
    });
    return FirebaseFirestore.instance
        .collection('Sliders')
        .snapshots()
        .listen((value) {
      setState(() {
        isLoading = false;
        feeds.clear();
      });
      for (var element in value.docs) {
        var result = FeedsModel.fromMap(element.data(), element.id);
        feeds.add(result);
        print('Feed length is ${feeds.length}');
      }
    });
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  String category = '';

  @override
  void initState() {
    getFeeds();
    super.initState();
  }

  List<String> img = [
    'assets/image/background 1.jpg',
    'assets/image/background 2.jpg',
    "assets/image/background 3.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading == true)
          Container(
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height / 1,
                          aspectRatio: 1,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          // onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (_, __, int pageViewIndex) => SizedBox(
                            height: MediaQuery.of(context).size.height / 1.2,
                            width: MediaQuery.of(context).size.width >= 1100
                                ? MediaQuery.of(context).size.width / 1
                                : MediaQuery.of(context).size.width / 1,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            )),
                        itemCount: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (isLoading == false)
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: feeds.length,
                  itemBuilder:
                      (BuildContext context, int itemIndex, int pageViewIndex) {
                    FeedsModel feedsModel = feeds[itemIndex];
                    category = feedsModel.category;
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  AdaptiveTheme.of(context).mode.isDark == true
                                      ? Colors.black87
                                      : null,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(_current == 0
                                      ? 'assets/image/2.png'
                                      : _current == 1
                                          ? 'assets/image/3.png'
                                          : 'assets/image/4.png'))),
                          child: MediaQuery.of(context).size.width >= 1100
                              ? Padding(
                                  padding: const EdgeInsets.all(100.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              feedsModel.detail,
                                              maxLines: MediaQuery.of(context)
                                                          .size
                                                          .width >=
                                                      1100
                                                  ? 3
                                                  : 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                wordSpacing: 1,
                                                fontFamily: 'LilitaOne',
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 50,
                                                color: _current == 2
                                                    ? const Color.fromARGB(
                                                        255, 94, 93, 93)
                                                    : Colors.black,
                                              ),
                                            )
                                                .animate()
                                                .fade(duration: 1000.ms)
                                                .scale(delay: 1000.ms),
                                            const Gap(10),
                                            Text(
                                              feedsModel.title,
                                              style: TextStyle(
                                                fontFamily: 'LCaveat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: _current == 2
                                                    ? const Color.fromARGB(
                                                        255, 94, 93, 93)
                                                    : Colors.black,
                                              ),
                                            )
                                                .animate()
                                                .fade(duration: 1100.ms)
                                                .scale(delay: 1100.ms),
                                            const Gap(20),
                                            ElevatedButton.icon(
                                              label: Text(
                                                'Shop Now',
                                                style: TextStyle(
                                                  color:
                                                      AdaptiveTheme.of(context)
                                                                  .mode
                                                                  .isDark ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ).tr(),
                                              icon: Icon(
                                                Icons.arrow_forward,
                                                color: AdaptiveTheme.of(context)
                                                            .mode
                                                            .isDark ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              onPressed: () {
                                                context.push(
                                                    '/products/${feedsModel.category}');
                                              },
                                            )
                                                .animate()
                                                .fade(duration: 1100.ms)
                                                .scale(delay: 1100.ms),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: FadeInRight(
                                            delay: const Duration(
                                                milliseconds: 1000),
                                            child: Image.network(
                                              feedsModel.image,
                                            )),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feedsModel.detail,
                                            maxLines: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1100
                                                ? 3
                                                : 2,
                                            style: TextStyle(
                                              wordSpacing: 1,
                                              fontFamily: 'LilitaOne',
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: _current == 2
                                                  ? const Color.fromARGB(
                                                      255, 94, 93, 93)
                                                  : Colors.black,
                                            ),
                                          )
                                              .animate()
                                              .fade(duration: 1000.ms)
                                              .scale(delay: 1000.ms),
                                          const Gap(10),
                                          Text(
                                            feedsModel.title,
                                            style: TextStyle(
                                              fontFamily: 'LCaveat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: _current == 2
                                                  ? const Color.fromARGB(
                                                      255, 94, 93, 93)
                                                  : Colors.black,
                                            ),
                                          )
                                              .animate()
                                              .fade(duration: 1100.ms)
                                              .scale(delay: 1100.ms),
                                          const Gap(20),
                                          ElevatedButton.icon(
                                            label: Text(
                                              'Shop Now',
                                              style: TextStyle(
                                                color: AdaptiveTheme.of(context)
                                                            .mode
                                                            .isDark ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ).tr(),
                                            icon: Icon(
                                              Icons.arrow_forward,
                                              color: AdaptiveTheme.of(context)
                                                          .mode
                                                          .isDark ==
                                                      true
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            onPressed: () {
                                              context.push(
                                                  '/products/${feedsModel.category}');
                                            },
                                          )
                                              .animate()
                                              .fade(duration: 1100.ms)
                                              .scale(delay: 1100.ms),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: FadeInRight(
                                          delay: const Duration(
                                              milliseconds: 1000),
                                          child: Image.network(
                                            feedsModel.image,
                                            scale: 2,
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                    const Gap(10)
                                  ],
                                ),
                        ));
                  },
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.width >= 1100
                          ? MediaQuery.of(context).size.height / 1
                          : MediaQuery.of(context).size.height / 1,
                      aspectRatio: 1,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 1500),
                      autoPlayCurve: Curves.slowMiddle,
                      enlargeCenterPage: true,
                      // onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: feeds.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(
                                    _current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        _controller.previousPage();
                      },
                      icon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: appColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Icon(Icons.chevron_left))),
                      color: Colors.white,
                    )),
                Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      iconSize: 30,
                      onPressed: () {
                        _controller.nextPage();
                      },
                      icon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: appColor,
                            shape: BoxShape.circle,
                          ),
                          child:
                              const Center(child: Icon(Icons.chevron_right))),
                      color: Colors.white,
                    )),
              ],
            ),
          )
      ],
    );
  }
}
