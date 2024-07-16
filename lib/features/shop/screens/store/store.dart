import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/appbar/tabbar.dart';
import 'package:e_mall/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:e_mall/common/widgets/layouts/grid_layout.dart';
import 'package:e_mall/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:e_mall/common/widgets/brands/brand_card.dart';
import 'package:e_mall/common/widgets/texts/section_heading.dart';
import 'package:e_mall/features/shop/screens/store/widgets/category_tab.dart';
import 'package:e_mall/utils/constants/colors.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:e_mall/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            "Store",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            TCardCounterIcon(onPressed: () {}),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                expandedHeight: 440,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      const TSearchContainer(
                        text: 'Search in Store',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),

                      ///Featured Brands
                      TSectionHeading(
                        title: 'Featured Brands',
                        showActionButton: true,
                        onPressed: () {},
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwItems / 1.5,
                      ),

                      GridLayout(
                          itemCount: 4,
                          mainAxisEvent: 80,
                          itemBuilder: (_, index) {
                            return const TBrandCard(
                              showBorder: true,
                            );
                          })
                    ],
                  ),
                ),

                ///Tabs
                bottom: const TTabBar(tabs: [
                  Tab(
                    child: Text('Computers & Tablets'),
                  ),
                  Tab(
                    child: Text('Mobile Phones'),
                  ),
                  Tab(
                    child: Text('TV & Entertainment'),
                  ),
                  Tab(
                    child: Text('Audio'),
                  ),
                  Tab(
                    child: Text('Cameras'),
                  ),
                  Tab(
                    child: Text('Gaming'),
                  ),
                  Tab(
                    child: Text('Home Appliances'),
                  ),
                  Tab(
                    child: Text('Smart Watches'),
                  ),
                ]),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),
              TCategoryTab(),

            ],
          ),
        ),
      ),
    );
  }
}
