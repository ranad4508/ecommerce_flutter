import 'package:e_mall/features/shop/screens/home/home.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(
                icon: Icon(Iconsax.home_copy), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.shop_copy), label: 'Store'),
            NavigationDestination(
                icon: Icon(Iconsax.heart_copy), label: 'Wishlist'),
            NavigationDestination(
                icon: Icon(Iconsax.user_copy), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    Container(
      color: Colors.deepPurple,
    ),
    Container(
      color: Colors.orange,
    ),
    Container(
      color: Colors.blue,
    )
  ];
}
