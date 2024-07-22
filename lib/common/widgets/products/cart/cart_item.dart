import 'package:e_mall/common/widgets/images/rounded_image.dart';
import 'package:e_mall/common/widgets/texts/brand_title_with_verification.dart';
import 'package:e_mall/common/widgets/texts/product_title_text.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TRoundedImage(
          imageUrl: TImages.productImage11,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),

        ///Title, Price & Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandTitleWithVerifiedIcon(title: 'HP'),
              const Flexible(
                child: ProductTitleText(
                  title: 'HP Victus 12',
                  maxLines: 1,
                ),
              ),

              ///Attributes
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: 'Color ',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                      text: 'Green ',
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                      text: 'Size ',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                      text: '15.5" ',
                      style: Theme.of(context).textTheme.bodyLarge),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
