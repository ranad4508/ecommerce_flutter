import 'package:e_mall/common/widgets/appbar/appbar.dart';
import 'package:e_mall/common/widgets/brands/brand_card.dart';
import 'package:e_mall/common/widgets/products/sortable/sortable_products.dart';
import 'package:e_mall/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: Text('HP'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              ///Brand detail
              TBrandCard(showBorder: true,),
              SizedBox(height: TSizes.spaceBtwSections,),
              TSortableProducts()
            ],
          ),
        ),
      ),
    );
  }
}
