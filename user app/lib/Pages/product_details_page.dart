import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Widgets/product_detail_mobile_view_widget.dart';
import 'package:user_app/Widgets/product_detail_web_view_widget.dart';

class ProductDetailPage extends StatefulWidget {
  final String productUID;
  const ProductDetailPage({super.key, required this.productUID});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      body: MediaQuery.of(context).size.width >= 1100
          ? ProductDetailWebViewWidget(productID: widget.productUID)
          : ProductDetailMobileViewWidget(productID: widget.productUID),
    );
  }
}
