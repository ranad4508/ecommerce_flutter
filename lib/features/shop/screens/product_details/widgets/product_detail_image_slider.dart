import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:e_mall/common/widgets/icon/circular_icon.dart';
import 'package:e_mall/common/widgets/images/rounded_image.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TCurvedEdgesWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            ///Main large image
            SizedBox(
              height: 400,
              child: Padding(
                padding:
                const EdgeInsets.all(TSizes.productItemRadius * 2),
                child: Center(
                  child: Image(
                    image: AssetImage(TImages.productImage11),
                  ),
                ),
              ),
            ),

            ///Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  itemCount: 6,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) => TRoundedImage(
                    imageUrl: TImages.productImage12,
                    width: 80,
                    backgroundColor:
                    dark ? TColors.dark : TColors.white,
                    border: Border.all(color: TColors.primary),
                    padding: EdgeInsets.all(TSizes.sm),
                  ),
                ),
              ),
            ),

            ///Appbar Icons
            TAppBar(
              showBackArrow: true,
              actions: [
                TCircularIcon(
                  icon: Iconsax.heart,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
