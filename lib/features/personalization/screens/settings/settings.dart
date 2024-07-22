import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:e_mall/common/widgets/list_tile/settings_menu.dart';
import 'package:e_mall/common/widgets/list_tile/user_profile_tile.dart';
import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/features/personalization/screens/address/address.dart';
import 'package:e_mall/features/personalization/screens/profile/profile.dart';
import 'package:e_mall/features/shop/screens/order/order.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          ///Header
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  ///User Profile card
                  TUserProfileTile(onPressed:()=> Get.to(()=>const ProfileScreen())),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),

            ///Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.safe_home_copy,
                    title: "My Addresses",
                    subTitle: "Set shipping delivery address",
                    onTap: ()=> Get.to(()=> const UserAddressScreen()),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.shopping_cart_copy,
                    title: "My Cart",
                    subTitle: "Add, remove products and move to checkout",
                    onTap: () {},
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.bag_tick_copy,
                    title: "My Orders",
                    subTitle: "In-progress and completed orders",
                    onTap: () =>Get.to(()=> const OrderScreen()),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.discount_shape_copy,
                    title: "My Coupons",
                    subTitle: "List of all the discounted coupons",
                    onTap: () {},
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.notification_copy,
                    title: "Notifications",
                    subTitle: "Set any kind of notification message",
                    onTap: () {},
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.security_card_copy,
                    title: "Account Privacy",
                    subTitle: "Manage data usage and connected accounts",
                    onTap: () {},
                  ),

                  ///App Settings
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  const TSectionHeading(
                    title: "App Settings",
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  const TSettingsMenuTile(
                      icon: Iconsax.document_cloud_copy,
                      title: "Load Data",
                      subTitle: "Upload data to your Cloud Firebase"),
                  TSettingsMenuTile(
                    icon: Iconsax.location_copy,
                    title: "Geolocation",
                    subTitle: "set recommendation based on location",
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),

                  TSettingsMenuTile(
                    icon: Iconsax.security_user_copy,
                    title: "Safe Mode",
                    subTitle: "Search result is safe for all ages",
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.image_copy,
                    title: "HD Image Quality",
                    subTitle: "Set image quality to be seen",
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),

                  ///Logout button
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections * 2.5,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
