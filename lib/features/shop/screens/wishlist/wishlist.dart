import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/icon/circular_icon.dart';
import 'package:e_mall/common/widgets/layouts/grid_layout.dart';
import 'package:e_mall/common/widgets/products/products_card/products_card_vertical.dart';
import 'package:e_mall/features/shop/screens/home/home.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,

        ),
        actions: [
          TCircularIcon(icon: Iconsax.add_copy, onPressed:()=>Get.to(const HomeScreen())),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.all(TSizes.defaultSpace) ,
          child: Column(
            children: [
              GridLayout(itemCount: 6, itemBuilder: (_, index)=>const TProductCardVertical(),)
            ],
          ),
        ),
      ),
    );
  }
}
