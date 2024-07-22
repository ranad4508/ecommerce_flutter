import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:e_mall/common/widgets/products/cart/coupon_widget.dart';
import 'package:e_mall/common/widgets/success_screen/success_screen.dart';
import 'package:e_mall/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:e_mall/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:e_mall/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:e_mall/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:e_mall/navigation_menu.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///Items in cart
              TCartItems(
                showAddRemoveButtons: false,
              ),
              SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///Coupon Field
              TCouponCode(),
              SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              ///Billing section
              TRoundedContainer(
                padding: EdgeInsets.all(TSizes.md),
                showBorder: true,
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Column(
                  children: [
                    ///Pricing
                    TBillingAmountSection(),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    ///Divider
                    Divider(),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    /// Payment Section
                    TBillingPaymentSection(),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),

                    /// Address
                    TBillingAddressSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => Get.to(
            () => SuccessScreen(
              image: TImages.successfullPaymentIcon,
              title: "Payment Success",
              subTitle: 'Your item will be shipped soon!',
              onPressed: () => Get.offAll(() => NavigationMenu()),
            ),
          ),
          child: Text('Checkout \$699'),
        ),
      ),
    );
  }
}
