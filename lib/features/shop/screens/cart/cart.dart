import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:e_mall/features/shop/screens/checkout/checkout.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: TCartItems(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: ()=>Get.to(()=> const CheckoutScreen()),
          child: const Text('Checkout \$699'),
        ),
      ),
    );
  }
}

