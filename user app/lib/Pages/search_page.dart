import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/Model/products_model.dart';
import 'package:user_app/Widgets/flash_hot_deal_product_widget.dart';

import '../Model/constant.dart';
//import 'package:user_app/Widgets/footer_widget.dart';

class SearchPage extends StatefulWidget {
  final String productString;
  const SearchPage({super.key, required this.productString});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductsModel> products = [];
  // List<ProductsModel> productsFilter = [];
  bool isLoaded = true;

  getProducts() async {
    setState(() {
      isLoaded = true;
    });
    context.loaderOverlay.show();
    FirebaseFirestore.instance
        .collection('Products')
        // .limit(10)
        .where('name', arrayContains: widget.productString)
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

  @override
  void initState() {
    getProducts();

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 100, right: 100)
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
                            '/ Search',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
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
                        ? const EdgeInsets.only(left: 100, right: 100)
                        : const EdgeInsets.all(0),
                    child: products.isEmpty
                        ? Center(
                            child: Column(children: [
                              Icon(
                                Icons.remove_shopping_cart,
                                color: appColor,
                                size: MediaQuery.of(context).size.height / 3,
                              ),
                              const Gap(10),
                              const Text('No Product Was Found')
                            ]),
                          )
                        : GridView.builder(
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
                                    child: ProductWidget(
                                        productsModel: productsModel)),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.8,
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width >=
                                                1100
                                            ? 5
                                            : 2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5),
                          ),
                  ),
            const Gap(20),
            //const FooterWidget()
          ],
        ),
      ),
    );
  }
}
