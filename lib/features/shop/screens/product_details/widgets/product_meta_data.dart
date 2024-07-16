import 'package:e_mall/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:e_mall/common/widgets/images/circular_image.dart';
import 'package:e_mall/common/widgets/texts/brand_title_with_verification.dart';
import 'package:e_mall/common/widgets/texts/product_price.dart';
import 'package:e_mall/common/widgets/texts/product_title_text.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/enums.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TProductMetaData extends StatelessWidget {
  const TProductMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Price and sale Price
        Row(
          children: [
            ///Sale tag
            TRoundedContainer(
              radius: TSizes.sm,
              backgroundColor: TColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm, vertical: TSizes.xs),
              child: Text(
                '25%',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(color: TColors.black),
              ),
            ),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),

            ///Price
            Text(
              '\$770',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .apply(decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),
            ProductCardPrice(
              price: '690',
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),

        ///Title
        ProductTitleText(title: 'HP Victus 12'),
        const SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),

        ///Stock Status
        Row(
          children: [
            ProductTitleText(title: 'Status'),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),
            Text(
              'In Stock',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),

        ///Brand
        Row(
          children: [
            TCircularImage(
              image: TImages.computerIcon,
              width: 32,
              height: 32,
              overlayColor: darkMode ? TColors.white : TColors.black,
            ),
            BrandTitleWithVerifiedIcon(
              title: 'HP',
              brandTextSize: TextSizes.medium,
            ),
          ],
        ),
      ],
    );
  }
}
