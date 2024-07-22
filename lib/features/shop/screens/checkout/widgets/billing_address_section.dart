import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () {},
        ),
        Text(
          'Roshni Koirala',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems/2,
        ),
        Row(
          children: [
            const Icon(
              Icons.phone,
              color: Colors.grey,
              size: 16,
            ),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),
            Text(
              '+977 9865747518',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(
          height: TSizes.spaceBtwSections / 2,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_history,
              color: Colors.grey,
              size: 16,
            ),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),
            Expanded(
              child: Text(
                'RIYAN PHARMACY TIKATHALI, Lalitpur 00977',
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
