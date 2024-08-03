import 'package:e_mall/common/widgets/brands/brand_show_case.dart';
import 'package:e_mall/common/widgets/layouts/grid_layout.dart';
import 'package:e_mall/common/widgets/products/products_card/products_card_vertical.dart';
import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                ///Brands
                const TBrandShowcase(
                  images: [
                    TImages.productImage1,
                    TImages.productImage4,
                    TImages.productImage3
                  ],
                ),const TBrandShowcase(
                  images: [
                    TImages.productImage1,
                    TImages.productImage4,
                    TImages.productImage3
                  ],
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),

                ///Products
                TSectionHeading(
                  title: 'You might like',
                  onPressed: () {},
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),

                TGridLayout(
                    itemCount: 4,
                    itemBuilder: (_, index) => const TProductCardVertical()),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                )
              ],
            ),
          ),
        ]);
  }
}
