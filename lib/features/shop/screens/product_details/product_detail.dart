import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:e_mall/common/widgets/icon/circular_icon.dart';
import 'package:e_mall/common/widgets/images/rounded_image.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:e_mall/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
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
                  ///Checkout Button
                  ///Description
                  ///Reviews
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

