// ignore_for_file: avoid_print

import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../Model/feeds.dart';
import 'cat_image_widget.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    super.key,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  Future<List<FeedsModel>> getFeeds() {
    return FirebaseFirestore.instance
        .collection('Feeds')
        // .limit(5)
        .get()
        .then((event) {
      return event.docs.map((e) => FeedsModel.fromMap(e.data(), e.id)).toList();
    });
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<FeedsModel> feeds = [];
  List<FeedsModel> feedsFilter = [];
  bool isLoaded = true;
  FeedsModel? banner1;
  FeedsModel? banner2;

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

        print(isLoaded = false);
      }
      Random random = Random();
      setState(() {
        banner1 = feeds[random.nextInt(feeds.length)];
        banner2 = feeds[random.nextInt(feeds.length)];
      });
    });
  }

  String category = '';

  @override
  void initState() {
    getBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100
        ? Row(
            children: [
              const Gap(100),
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    FutureBuilder<List<FeedsModel>>(
                        future: getFeeds(),
                        builder: (context, snapshot) {
                          if (snapshot.data?.isEmpty ?? true) {
                            return Container(
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1,
                                            aspectRatio: 1,
                                            viewportFraction: 1,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: true,
                                            autoPlayInterval:
                                                const Duration(seconds: 3),
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: true,
                                            // onPageChanged: callbackFunction,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                          itemBuilder: (_, __,
                                                  int pageViewIndex) =>
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.2,
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width >=
                                                          1100
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                  )),
                                          itemCount: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Container(
                              color: Colors.white,
                              child: Stack(
                                children: [
                                  CarouselSlider.builder(
                                    carouselController: _controller,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) {
                                      FeedsModel feedsModel =
                                          snapshot.data![itemIndex];
                                      category = feedsModel.category;
                                      return InkWell(
                                        onTap: () async {
                                          // Navigator.of(context).push(MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         MarketlistPage(category: feedsModel.category)));
                                          context.push(
                                              '/products/${feedsModel.category}');
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            feedsModel.image,
                                            fit: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1100
                                                ? BoxFit.fill
                                                : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            600 &&
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width <
                                                            1200
                                                    ? BoxFit.fill
                                                    : BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.2,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1100
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1
                                                : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            600 &&
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width <
                                                            1200
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1,
                                          ),
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                        height:
                                            MediaQuery.of(context).size.width >=
                                                    1100
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.2
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.5,
                                        aspectRatio: 1,
                                        viewportFraction: 1,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 5),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        // onPageChanged: callbackFunction,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                  ),
                                  snapshot.data!.length > 5
                                      ? const SizedBox.shrink()
                                      : Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: snapshot.data!
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              return GestureDetector(
                                                onTap: () => _controller
                                                    .animateToPage(entry.key),
                                                child: Container(
                                                  width: 12.0,
                                                  height: 12.0,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: (Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black)
                                                          .withOpacity(
                                                              _current ==
                                                                      entry.key
                                                                  ? 0.9
                                                                  : 0.4)),
                                                ),
                                              );
                                            }).toList(),
                                          )),
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
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                                child:
                                                    Icon(Icons.chevron_left))),
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
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                                child:
                                                    Icon(Icons.chevron_right))),
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            );
                          } else {
                            return Container(
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1,
                                            aspectRatio: 1,
                                            viewportFraction: 1,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: true,
                                            autoPlayInterval:
                                                const Duration(seconds: 3),
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: true,
                                            // onPageChanged: callbackFunction,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                          itemBuilder: (_, __,
                                                  int pageViewIndex) =>
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                    ),
                                                  )),
                                          itemCount: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
              const Gap(30),
              isLoaded == true
                  ? Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 3,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                  ),
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              )),
                          const Gap(10),
                          Expanded(
                              flex: 3,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.white,
                                  ),
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              )),
                        ],
                      ))
                  : Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  context.push('/products/${banner1!.category}');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: CatImageWidget(
                                        url: banner1!.image, boxFit: 'fill'),
                                  ),
                                ),
                              )),
                          const Gap(10),
                          Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  context.push('/products/${banner2!.category}');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: CatImageWidget(
                                        url: banner2!.image, boxFit: 'fill'),
                                  ),
                                ),
                              )),
                        ],
                      )),
              const Gap(100)
            ],
          )
        : Stack(
            children: [
              FutureBuilder<List<FeedsModel>>(
                  future: getFeeds(),
                  builder: (context, snapshot) {
                    if (snapshot.data?.isEmpty ?? true) {
                      return Container(
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1,
                                      aspectRatio: 1,
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      // onPageChanged: callbackFunction,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    itemBuilder: (_, __, int pageViewIndex) =>
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.2,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    1100
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                            )),
                                    itemCount: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Container(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                              carouselController: _controller,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                FeedsModel feedsModel =
                                    snapshot.data![itemIndex];
                                category = feedsModel.category;
                                return InkWell(
                                  onTap: () async {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         MarketlistPage(category: feedsModel.category)));
                                    context
                                        .push('/products/${feedsModel.category}');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: Image.network(
                                      feedsModel.image,
                                      fit: MediaQuery.of(context).size.width >=
                                              1100
                                          ? BoxFit.fill
                                          : MediaQuery.of(context).size.width >
                                                      600 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1200
                                              ? BoxFit.fill
                                              : BoxFit.fill,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.2,
                                      width: MediaQuery.of(context)
                                                  .size
                                                  .width >=
                                              1100
                                          ? MediaQuery.of(context).size.width /
                                              1
                                          : MediaQuery.of(context).size.width >
                                                      600 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1200
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1,
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                  height: MediaQuery.of(context).size.width >=
                                          1100
                                      ? MediaQuery.of(context).size.height / 1.2
                                      : MediaQuery.of(context).size.height /
                                          1.5,
                                  aspectRatio: 0.8,
                                  viewportFraction: 0.8,
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
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                            ),
                            snapshot.data!.length > 5
                                ? const SizedBox.shrink()
                                : Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: snapshot.data!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return GestureDetector(
                                          onTap: () => _controller
                                              .animateToPage(entry.key),
                                          child: Container(
                                            width: 12.0,
                                            height: 12.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 4.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                          ),
                                        );
                                      }).toList(),
                                    )),
                            // Align(
                            //     alignment: Alignment.centerLeft,
                            //     child: IconButton(
                            //       iconSize: 40,
                            //       onPressed: () {
                            //         _controller.previousPage();
                            //       },
                            //       icon: Container(
                            //           height: 50,
                            //           width: 50,
                            //           decoration: BoxDecoration(
                            //             color: Colors.grey.withOpacity(0.4),
                            //             shape: BoxShape.circle,
                            //           ),
                            //           child: const Center(
                            //               child: Icon(Icons.chevron_left))),
                            //       color: Colors.white,
                            //     )),
                            // Align(
                            //     alignment: Alignment.centerRight,
                            //     child: IconButton(
                            //       iconSize: 40,
                            //       onPressed: () {
                            //         _controller.nextPage();
                            //       },
                            //       icon: Container(
                            //           height: 50,
                            //           width: 50,
                            //           decoration: BoxDecoration(
                            //             color: Colors.grey.withOpacity(0.4),
                            //             shape: BoxShape.circle,
                            //           ),
                            //           child: const Center(
                            //               child: Icon(Icons.chevron_right))),
                            //       color: Colors.white,
                            //     )),
                          ],
                        ),
                      );
                    } else {
                      return Container(
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1,
                                      aspectRatio: 1,
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      // onPageChanged: callbackFunction,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    itemBuilder: (_, __, int pageViewIndex) =>
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                              ),
                                            )),
                                    itemCount: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ],
          );
  }
}
