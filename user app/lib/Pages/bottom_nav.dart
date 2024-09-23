import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_close_app/flutter_close_app.dart';
import 'package:gap/gap.dart';
// ignore: library_prefixes
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import '../Model/categories.dart';
import '../Widgets/collections_expanded_tile.dart';
import 'home_page_2.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int currentIndex = 0;
  List<CategoriesModel> allCats = [];
  bool isLoading = false;

  // Define your screens here

  navToHotDeal() {
    setState(() {
      currentIndex = 1;
    });
  }

  navToFlashSales() {
    setState(() {
      currentIndex = 2;
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
    getAllCats();
    super.initState();
  }

  showBottomSheetTab() {
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
                          padding: const EdgeInsets.only(left: 15),
                          child: const Text(
                            'Categories',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                      ],
                    ),
                    const Gap(10),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allCats.length,
                        itemBuilder: (context, index) {
                          CategoriesModel categoriesModel = allCats[index];
                          return ExpansionTile(
                            leading: ExtendedImage.network(
                              categoriesModel.image,
                              height: 50,
                              handleLoadingProgress: false,
                              width: 50,
                            ),
                            title: Text(categoriesModel.category),
                            children: [
                              CollectionsExpandedTile(
                                cat: categoriesModel.category,
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return FlutterCloseAppPage(
        interval: 2,
        condition: true,
        onCloseFailed: () {
          // The interval is more than 2 seconds, or the return key is pressed for the first time
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Press again to exit'),
          ));
        },
        child: const HomePage2());
  }
}
