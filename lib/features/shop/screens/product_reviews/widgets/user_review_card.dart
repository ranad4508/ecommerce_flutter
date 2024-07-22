import 'package:e_mall/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:e_mall/common/widgets/products/ratings/rating_indicator.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(TImages.user1),
                ),
                const SizedBox(
                  width: TSizes.spaceBtwItems,
                ),
                Text(
                  'Roshni Koirala',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        ///Review
        Row(
          children: [const TRatingBarIndicator(rating: 4),
          const SizedBox(width: TSizes.spaceBtwItems,),
          Text('20 July, 2024', style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        const ReadMoreText('This is a application that have a awesome user interface. I was able to navigate where i want and make my shopping experience really awesome.',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' Show less',
          trimCollapsedText: ' Show More',
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
          lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        ///Review
        TRoundedContainer(
          backgroundColor: dark?TColors.darkerGrey:TColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('eMall', style: Theme.of(context).textTheme.titleMedium,),
                    Text('20 July, 2024', style: Theme.of(context).textTheme.bodyMedium,),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                const ReadMoreText('Thank you ma\'am for your precious review.',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: ' Show less',
                  trimCollapsedText: ' Show More',
                  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                  lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),
      ],
    );
  }
}
