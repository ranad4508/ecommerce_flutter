import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/products/ratings/rating_indicator.dart';
import 'package:e_mall/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:e_mall/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Appbar
      appBar: const TAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Ratings and reviews are verified and are from people who use the same type of devies that you use'),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              ///Overal product ratings
              const TOverallProductRating(),
              const TRatingBarIndicator(rating: 4.5,),
              Text('299', style: Theme.of(context).textTheme.bodySmall,),
              const SizedBox(height: TSizes.spaceBtwSections,),

              ///User Reviews Card
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),

            ],
          ),
        ),
      ),

      ///Body
    );
  }
}

