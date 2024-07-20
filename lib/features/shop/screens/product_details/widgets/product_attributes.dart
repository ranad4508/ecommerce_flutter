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
          padding: EdgeInsets.all(TSizes.md),
          backgroundColor: dark ? TColors.darkerGrey : TColors.grey,
          child: Column(
            children: [
              Row(
                children: [
                  TSectionHeading(
                    title: 'Variation',
                    showActionButton: false,
                  ),
                  SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ProductTitleText(
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
                          SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),

                          ///Sale Price
                          ProductCardPrice(price: '685')
                        ],
                      ),
                      Row(
                        children: [
                          ProductTitleText(
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
              ProductTitleText(
                title:
                    'This is the description of the product variation',
                smallSize: true,
                maxLines: 5,
              ),
            ],
          ),
        ),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),

        ///Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TSectionHeading(
              title: 'Colors',
              showActionButton: false,
            ),
            SizedBox(
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
            TSectionHeading(
              title: 'Size',
              showActionButton: false,
            ),
            SizedBox(
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

