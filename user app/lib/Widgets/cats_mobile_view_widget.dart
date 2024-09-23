import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/categories.dart';

import 'cat_image_widget.dart';
import 'collections_expanded_tile.dart';

class CatsMobileViewWidget extends StatefulWidget {
  const CatsMobileViewWidget({
    super.key,
  });

  @override
  State<CatsMobileViewWidget> createState() => _CatsMobileViewWidgetState();
}

class _CatsMobileViewWidgetState extends State<CatsMobileViewWidget> {
  List<CategoriesModel> cats = [];
  List<CategoriesModel> allCats = [];
  bool isLoading = false;
  getCats() {
    setState(() {
      isLoading = true;
    });
    List<CategoriesModel> categories = [
      CategoriesModel(category: "View All".tr(), image: '')
    ];
    return FirebaseFirestore.instance
        .collection('Categories')
        .limit(7)
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
          categories.insert(0, fetchServices);
          cats = categories;
          //  cats.add(CategoriesModel(category: "View All".tr(), image: ''));
        });
      }
    });
  }

  getAllCats() {
    setState(() {
      isLoading = true;
    });
    List<CategoriesModel> categories = [];
    return FirebaseFirestore.instance
        .collection('Categories')
        .snapshots()
        .listen((value) {
      setState(() {
        isLoading = false;
      });
      allCats.clear();
      for (var element in value.docs) {
        setState(() {
          var fetchServices =
              CategoriesModel.fromMap(element.data(), element.id);
          categories.add(fetchServices);
          allCats = categories;
          //  cats.add(CategoriesModel(category: "View All".tr(), image: ''));
        });
      }
    });
  }

  @override
  void initState() {
    getCats();
    getAllCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        // height: 200,
        child: isLoading == true
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
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
              )
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cats.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, crossAxisSpacing: 5, mainAxisSpacing: 5),
                itemBuilder: (BuildContext context, int index) {
                  CategoriesModel categoriesModel = cats[index];
                  return index == 7
                      ? InkWell(
                          onTap: () {
                            modalSheet.showBarModalBottomSheet(
                                expand: true,
                                bounce: true,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Scaffold(
                                      body: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const Gap(20),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: const Text(
                                                    'Categories',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ).tr(),
                                                ),
                                              ],
                                            ),
                                            const Gap(10),
                                            ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: allCats.length,
                                                itemBuilder: (context, index) {
                                                  CategoriesModel
                                                      categoriesModel =
                                                     allCats[index];
                                                  return ExpansionTile(
                                                    leading:
                                                        ExtendedImage.network(
                                                      categoriesModel.image,
                                                      height: 50,
                                                      handleLoadingProgress:
                                                          false,
                                                      width: 50,
                                                    ),
                                                    title: Text(categoriesModel
                                                        .category),
                                                    children: [
                                                      CollectionsExpandedTile(
                                                        cat: categoriesModel
                                                            .category,
                                                      )
                                                    ],
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: Center(
                              child: Text(
                            categoriesModel.category,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                        )
                      : InkWell(
                          onTap: () {
                            context.push('/products/${categoriesModel.category}');
                          },
                          child: Stack(
                            children: [
                              CatImageWidget(
                                url: categoriesModel.image,
                                boxFit: 'cover',
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4)),
                                  child: Center(
                                    child: Text(
                                      categoriesModel.category,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                },
              ),
      ),
    );
  }
}
