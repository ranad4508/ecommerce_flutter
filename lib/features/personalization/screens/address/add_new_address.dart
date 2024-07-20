import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Add New Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.user_copy), labelText: 'Name'),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwInputField,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.mobile_copy),
                      labelText: 'Phone Number'),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwInputField,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.building_3_copy),
                            labelText: 'Street'),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputField,),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.code_copy),
                            labelText: 'Postal Code'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputField,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.buildings_copy),
                            labelText: 'City'),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwInputField,),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.activity_copy),
                            labelText: 'State'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputField,),
                TextFormField(decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.global_copy),
                    labelText: 'Country'),),
                const SizedBox(height: TSizes.defaultSpace,),
                SizedBox(width: double.infinity,
                  child: ElevatedButton(onPressed: () {}, child: Text('Save'),),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
