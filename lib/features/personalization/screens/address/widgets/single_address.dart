import 'package:e_mall/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TRoundedContainer(
      padding: EdgeInsets.all( TSizes.md),
      width: double.infinity,
      showBorder: true,
      backgroundColor: selectedAddress
          ? TColors.primary.withOpacity(0.5)
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : dark
          ? TColors.darkerGrey
          : TColors.grey,
      margin: EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              right: 5,
              top: 0,
              child: Icon(
                selectedAddress ? Iconsax.tick_circle : null,
                color: selectedAddress
                    ? dark
                    ? TColors.light
                    : TColors.dark.withOpacity(0.6)
                    : null,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roshni Koirala',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: TSizes.sm / 2,
                ),
                const Text(
                  '+977 9841306857',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: TSizes.sm / 2,
                ),
                const Text(
                  'RIYAN PHARMACY TIKATHALI, Lalitpur 00977',
                  softWrap: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
