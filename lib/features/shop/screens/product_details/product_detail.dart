import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:e_mall/common/widgets/icon/circular_icon.dart';
import 'package:e_mall/common/widgets/images/rounded_image.dart';
import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/bottom_add_to_cart.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:e_mall/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Product Image slider
            TProductImageSlider(),

            /// Product Details
            Padding(
              padding: EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  ///Rating & share
                  TRatingAndShare(),

                  ///Price, Title, Stock & Brand
                  TProductMetaData(),

                  ///Attribute
                  ProductAttributes(),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Checkout'),
                    ),
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///Description
                  TSectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  ReadMoreText(
                    '13th Generation Intel® Core™ i7 processor Windows 11 Home 39.6 cm (15.6) diagonal,'
                    ' FHD, 144 Hz refresh rate, 9 ms response time display'
                    ' NVIDIA® GeForce RTX™ 4050 6GB 16 GB DDR4 RAM 1TB SSD'
                    ' Solid State Drive Backlit keyboard with numeric keypad'
                    ',Wide Vision 720p HD camera,B&O Speakers',
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Show less',
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),

                  ///Reviews
                  const Divider(),
                  SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TSectionHeading(
                        title: 'Reviews(29)',
                        showActionButton: false,
                      ),
                      IconButton(
                          icon: Icon(
                            Iconsax.arrow_right_3_copy,
                            size: 18,
                          ),
                          onPressed: () =>
                              Get.to(() => ProductReviewsScreen())),
                    ],
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
