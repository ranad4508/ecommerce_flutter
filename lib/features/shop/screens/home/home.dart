import 'package:e_mall/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:e_mall/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:e_mall/common/widgets/layouts/grid_layout.dart';
import 'package:e_mall/common/widgets/products/products_card/products_card_vertical.dart';
import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/features/shop/screens/all_products/all_products.dart';
import 'package:e_mall/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:e_mall/features/shop/screens/home/widgets/home_categories.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Header
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  ///Appbar
                  THomeAppBar(),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///Searchbar
                  TSearchContainer(
                    text: 'Search in Store',
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///Categories
                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        ///Heading
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: TColors.white,
                        ),
                        SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),

                        ///Categories
                        THomeCategories(),
                      ],
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections,),
                ],
              ),
            ),

            ///Body part
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  // Promo slider
                  const TPromoSlider(
                    banners: [
                      TImages.banner1,
                      TImages.banner2,
                      TImages.banner3
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  //   Popular Products
                  TSectionHeading(title: "Popular Products", onPressed: ()=>Get.to(()=>AllProducts()),),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  TGridLayout(itemCount: 4,itemBuilder: (_, index) => const TProductCardVertical(),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

