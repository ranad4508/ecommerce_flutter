import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
import 'package:user_app/Model/feeds.dart';
// import 'package:user_app/Widgets/cat_image_widget.dart';
import 'package:user_app/Widgets/hot_deals_widget_new.dart';
// import '../Model/constant.dart';
import '../Widgets/flash_sales_widget_new.dart';
import '../Widgets/guide_slider.dart';
import '../Widgets/last_banner_widget.dart';
import '../Widgets/new_categories_widget.dart';
import '../Widgets/new_offers.dart';
import '../Widgets/new_slider.dart';
import '../Widgets/products_by_cat_home_page_widget.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({
    super.key,
  });

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
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
        // Future.delayed(const Duration(seconds: 10), () {
        //   showGeneralDialog(
        //     context: context,
        //     pageBuilder: (BuildContext buildContext,
        //         Animation<double> animation,
        //         Animation<double> secondaryAnimation) {
        //       return Dialog(
        //           child: Container(
        //         decoration: BoxDecoration(
        //             border: Border.all(width: 2, color: Colors.white),
        //             borderRadius: BorderRadius.circular(5)),
        //         child: InkWell(
        //           onTap: () {
        //             context.go('/products/${banner1!.category}');
        //             context.pop();
        //           },
        //           child: SizedBox(
        //             height:
        //                 MediaQuery.of(context).size.width >= 1100 ? 500 : 700,
        //             width: MediaQuery.of(context).size.width >= 1100
        //                 ? 500
        //                 : MediaQuery.of(context).size.width / 1,
        //             child: Stack(
        //               children: [
        //                 SizedBox(
        //                   child: ClipRRect(
        //                     borderRadius: BorderRadius.circular(5),
        //                     child: CatImageWidget(
        //                       url: banner1!.image,
        //                       boxFit: 'cover',
        //                     ),
        //                   ),
        //                 ),
        //                 Align(
        //                   alignment: Alignment.topRight,
        //                   child: InkWell(
        //                     onTap: () {
        //                       // Future.delayed(const Duration(seconds: 1), () {
        //                       context.pop();
        //                       // });
        //                     },
        //                     child: Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: Container(
        //                         decoration:  BoxDecoration(
        //                             shape: BoxShape.circle,
        //                             color: appColor),
        //                         child: const Padding(
        //                           padding: EdgeInsets.all(8.0),
        //                           child: Icon(Icons.close, color: Colors.white),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ));
        //     },
        //     barrierDismissible: true,
        //     barrierLabel:
        //         MaterialLocalizations.of(context).modalBarrierDismissLabel,
        //     barrierColor: Colors.black.withOpacity(0.5),
        //     transitionDuration: const Duration(milliseconds: 200),
        //     transitionBuilder: (BuildContext context,
        //         Animation<double> animation,
        //         Animation<double> secondaryAnimation,
        //         Widget child) {
        //       return FadeTransition(
        //         opacity: CurvedAnimation(
        //           parent: animation,
        //           curve: Curves.fastOutSlowIn,
        //         ),
        //         child: child,
        //       );
        //     },
        //   );
        // });
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
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // MediaQuery.of(context).size.width >= 1100
            //     ? const Gap(20)
            //     : const Gap(10),
            SizedBox(
                height: MediaQuery.of(context).size.width >= 1100
                    ? MediaQuery.of(context).size.height / 1.2
                    : MediaQuery.of(context).size.height / 1.5,
                width: double.infinity,
                child: const NewSliderWidget()),
            const Gap(20),
            Padding(
              padding: MediaQuery.of(context).size.width >= 1100
                  ? const EdgeInsets.only(left: 50, right: 50)
                  : EdgeInsets.zero,
              child: const GuidesSliderWIdget(),
            ),

            const Gap(20),
            const FlashSalesWidgetNew(),
            const Gap(20),
            const NewCategoriesWidget(),
            const Gap(20),
            const LastBannerWidget(),
            const Gap(20),
            const HotDealsWidgetNew(),
            const Gap(20),
            const NewOffers(),
            const Gap(20),
            const ProductsByCatHomePageWidget(),
            const Gap(20),
            // const FooterWidget()
          ],
        ),
      ),
    );
  }
}
