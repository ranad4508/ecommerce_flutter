import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/images/circular_image.dart';
import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:e_mall/utils/constants/image_strings.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            ///Profile picture
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const TCircularImage(
                      image: TImages.user1,
                      width: 80,
                      height: 80,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Change Profile Picture'))
                  ],
                ),
              ),

              ///Detail
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const TSectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              TProfileMenu(
                title: "Name",
                value: 'Dinesh Kumar Rana',
                onPressed: () {},
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              //Heading Personal Info
              const TSectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              TProfileMenu(
                  onPressed: () {},
                  title: 'User ID',
                  icon: Iconsax.copy_copy,
                  value: '450808'),
              TProfileMenu(
                  onPressed: () {},
                  title: 'E-Mail',
                  value: 'dineshrana@gmail.com'),
              TProfileMenu(
                  onPressed: () {},
                  title: 'Phone Number',
                  value: '+977-9865747518'),
              TProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male'),
              TProfileMenu(
                  onPressed: () {},
                  title: 'Date of Birth',
                  value: '11 oct, 2001'),

              const Divider(),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Close Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
