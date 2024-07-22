import 'package:e_mall/common/widgets/chips/choice_chip.dart';
import 'package:e_mall/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:e_mall/common/widgets/texts/product_price.dart';
import 'package:e_mall/common/widgets/texts/product_title_text.dart';
import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        ///Selected attributes pricing and Description
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.md),
          backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
          child: Column(
            children: [
              Row(
                children: [
                  const TSectionHeading(
                    title: 'Variation',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ProductTitleText(
                            title: 'Price : ',
                            smallSize: true,
                          ),

                          ///Actual Price
                          Text(
                            '\$725',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),

                          ///Sale Price
                          const ProductCardPrice(price: '685')
                        ],
                      ),
                      Row(
                        children: [
                          const ProductTitleText(
                            title: 'Stock : ',
                            smallSize: true,
                          ),
                          Text(
                            'In Stock',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              ///variation Description
              const ProductTitleText(
                title:
                    'This is the description of the product variation',
                smallSize: true,
                maxLines: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems,
        ),

        ///Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TSectionHeading(
              title: 'Colors',
              showActionButton: false,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems/2,
            ),
            Wrap(
              spacing: 8,
              children: [
                TChoiceChip(text: 'Grey', selected: true, onSelected: (value){},),
                TChoiceChip(text: 'Stormy Grey', selected: false,onSelected: (value){}),
                TChoiceChip(text: 'Ceramic White', selected: false,onSelected: (value){}),
                TChoiceChip(text: 'Silver', selected: false,onSelected: (value){}),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TSectionHeading(
              title: 'Size',
              showActionButton: false,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems/2,
            ),
            Wrap(
              spacing: 8,
              children: [
                TChoiceChip(text: '15.6"', selected: true,onSelected: (value){},),
                TChoiceChip(text: '15.6"', selected: false,onSelected: (value){},),
                TChoiceChip(text: '15.6"', selected: false,onSelected: (value){},),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

