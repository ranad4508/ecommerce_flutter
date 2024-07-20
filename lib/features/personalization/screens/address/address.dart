import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:e_mall/features/personalization/screens/address/add_new_address.dart';
import 'package:e_mall/features/personalization/screens/address/widgets/single_address.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        onPressed: () => Get.to(() => AddNewAddressScreen()),
        child: Icon(Iconsax.add_copy, color: TColors.white,),

      ),
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Addresses', style: Theme.of(context).textTheme.headlineSmall,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TSingleAddress(selectedAddress: true),
              TSingleAddress(selectedAddress: false),
            ],
          ),
        ),
      ),
    );
  }
}
