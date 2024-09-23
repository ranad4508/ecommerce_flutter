import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:user_app/Model/products_model.dart';

import '../Model/constant.dart';
import '../Widgets/product_widget_main.dart';

class FlashSalesPage extends StatefulWidget {
  const FlashSalesPage({super.key});

  @override
  State<FlashSalesPage> createState() => _FlashSalesPageState();
}

class _FlashSalesPageState extends State<FlashSalesPage> {
  List<ProductsModel> products = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = true;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('Flash Sales')
        // .limit(10)
        .snapshots()
        .listen((event) {
      setState(() {
        isLoaded = false;
      });
      context.loaderOverlay.hide();
      products.clear();
      for (var element in event.docs) {
        var prods = ProductsModel.fromMap(element, element.id);
        setState(() {
          products.add(prods);
        });
      }
    });
  }

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

  @override
  void initState() {
    getProducts();
    getFlashSalesTime();
    super.initState();
  }

  Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collectionPath);

    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await collectionReference.doc(documentSnapshot.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse the string into a DateTime object
    DateTime targetDate = DateTime.parse(flashSales);

    // Calculate the difference between the target date and the current date
    DateTime currentDate = DateTime.now();
    Duration difference = targetDate.difference(currentDate);
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width >= 1100 ? 200 : 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 230, 224, 237),
                  image: DecorationImage(
                      // opacity: 0.3,
                      fit: MediaQuery.of(context).size.width >= 1100
                          ? BoxFit.cover
                          : BoxFit.fill,
                      image: const AssetImage('assets/image/flash sales.png'))),
            ),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 60, right: 100)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Gap(20),
                  if (MediaQuery.of(context).size.width >= 1100)
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.push('/');
                            },
                            child: const Text(
                              'Home',
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ),
                          const Text(
                            '/ Flash Sales',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: MediaQuery.of(context).size.width >= 1100
                                  ? const EdgeInsets.all(0)
                                  : const EdgeInsets.all(8.0),
                              child: const Text(
                                'Flash Sales',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ).tr(),
                            ),
                            if (flashSales.isNotEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SlideCountdownSeparated(
                                    separatorStyle: TextStyle(
                                      color: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark ==
                                              true
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    separatorType: SeparatorType.title,
                                    decoration: BoxDecoration(
                                        color: appColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    style: const TextStyle(fontSize: 18),
                                    duration: difference,
                                    onDone: () {
                                      deleteAllDocumentsInCollection(
                                          'Flash Sales');
                                    },
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: MediaQuery.of(context).size.width >= 1100
                                  ? const EdgeInsets.all(0)
                                  : const EdgeInsets.all(8.0),
                              child: const Text(
                                'Flash Sales',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ).tr(),
                            ),
                            const Gap(20),
                            if (flashSales.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SlideCountdownSeparated(
                                  separatorType: SeparatorType.title,
                                  separatorStyle: TextStyle(
                                    color:
                                        AdaptiveTheme.of(context).mode.isDark ==
                                                true
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  decoration: BoxDecoration(
                                      color: appColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  style: const TextStyle(fontSize: 14),
                                  duration: difference,
                                  onDone: () {
                                    deleteAllDocumentsInCollection(
                                        'Flash Sales');
                                  },
                                ),
                              ),
                          ],
                        ),
                  const Gap(10),
                ],
              ),
            ),
            isLoaded == true
                ? Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 100, right: 100)
                        : const EdgeInsets.all(0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  color: Colors.grey[300],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 16,
                                      width: 120,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 16,
                                      width: 80,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: MediaQuery.of(context).size.width >= 1100
                        ? const EdgeInsets.only(left: 50, right: 50)
                        : const EdgeInsets.all(0),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        ProductsModel productsModel = products[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                context.push(
                                    '/product-detail/${productsModel.uid}');
                              },
                              child: ProductWidgetMain(
                                  productsModel: productsModel)),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              MediaQuery.of(context).size.width >= 1100
                                  ? 0.7
                                  : 0.57,
                          crossAxisCount:
                              MediaQuery.of(context).size.width >= 1100 ? 5 : 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                    ),
                  ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
