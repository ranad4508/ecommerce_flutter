import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/feeds.dart';

import 'cat_image_widget.dart';

class LastBannerWidget extends StatefulWidget {
  const LastBannerWidget({super.key});

  @override
  State<LastBannerWidget> createState() => _LastBannerWidgetState();
}

class _LastBannerWidgetState extends State<LastBannerWidget> {
  bool isLoaded = true;
  FeedsModel? banner1;
  FeedsModel? banner2;
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
        banner2 = feeds[random.nextInt(feeds.length)];
      });
    });
  }

  @override
  void initState() {
    getBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100
        ? Padding(
            padding: const EdgeInsets.only(left: 100, right: 100),
            child: SizedBox(
              height: MediaQuery.of(context).size.width >= 1100 ? 250 : 150,
              width: double.infinity,
              child: isLoaded == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                10.0), // Add some spacing between the shimmer containers
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              context.push('/products/${banner1!.category}');
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: CatImageWidget(
                                    url: banner1!.image, boxFit: 'fill'),
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              context.push('/products/${banner2!.category}');
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: CatImageWidget(
                                    url: banner2!.image, boxFit: 'fill'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          )
        : SizedBox(
            height: 150,
            width: double.infinity,
            child: isLoaded == true
                ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 300.0,
                            //  height: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          context.push('/products/${banner1!.category}');
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: SizedBox(
                            height: double.infinity,
                            width: 300,
                            child: CatImageWidget(
                              url: banner1!.image,
                              boxFit: 'fill',
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      InkWell(
                        onTap: () {
                          context.push('/products/${banner2!.category}');
                        },
                        child: SizedBox(
                          height: double.infinity,
                          width: 300,
                          child: CatImageWidget(
                            url: banner2!.image,
                            boxFit: 'fill',
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}
