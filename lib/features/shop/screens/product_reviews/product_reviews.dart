import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/products/ratings/rating_indicator.dart';
import 'package:e_mall/features/shop/screens/product_reviews/widgets/progress_indicator_and_rating.dart';
import 'package:e_mall/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:e_mall/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/device/device_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Appbar
      appBar: TAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Ratings and reviews are verified and are from people who use the same type of devies that you use'),
              SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              ///Overal product ratings
              TOverallProductRating(),
              TRatingBarIndicator(rating: 4.5,),
              Text('299', style: Theme.of(context).textTheme.bodySmall,),
              SizedBox(height: TSizes.spaceBtwSections,),

              ///User Reviews Card
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),

            ],
          ),
        ),
      ),

      ///Body
    );
  }
}

