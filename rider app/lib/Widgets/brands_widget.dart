import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rider_app/Model/brand_model.dart';


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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: 200,
      child: isLoading == true
          ? Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width >= 1100 ? 7 : 4,
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
              ),
            )
          : Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio:
                        MediaQuery.of(context).size.width >= 1100 ? 1.5 : 1.2,
                    crossAxisCount:
                        MediaQuery.of(context).size.width >= 1100 ? 7 : 4,
                    crossAxisSpacing:
                        MediaQuery.of(context).size.width >= 1100 ? 15 : 5,
                    mainAxisSpacing:
                        MediaQuery.of(context).size.width >= 1100 ? 15 : 5),
                itemBuilder: (BuildContext context, int index) {
                  BrandModel brandModel = cats[index];
                  return InkWell(
                      onTap: () {
                        context.push('/brand/${brandModel.collection}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width >= 1100
                                    ? 12
                                    : 0),
                            color: Colors.black.withOpacity(0.4),
                            image: DecorationImage(
                                image: NetworkImage(brandModel.backgroundImage),
                                fit: BoxFit.cover,
                                opacity: 0.4)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width >= 1100
                                    ? 12
                                    : 0),
                            color: Colors.black.withOpacity(0.6),
                            // image: DecorationImage(
                            //     image: NetworkImage(brandModel.backgroundImage),
                            //     fit: BoxFit.cover,
                            //     opacity: 0.4)
                          ),
                          child: Center(
                            child: Image.network(
                              brandModel.image,
                              color: Colors.white,
                              height: MediaQuery.of(context).size.width >= 1100
                                  ? 50
                                  : 35,
                              width: MediaQuery.of(context).size.width >= 1100
                                  ? 50
                                  : 35,
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
    );
  }
}
