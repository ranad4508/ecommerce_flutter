import 'package:flutter/material.dart';
import 'products_by_similar_widget.dart';

class SimilarItemsWidget extends StatefulWidget {
  final String category;
  final String productID;
  const SimilarItemsWidget(
      {super.key, required this.category, required this.productID});

  @override
  State<SimilarItemsWidget> createState() => _SimilarItemsWidgetState();
}

class _SimilarItemsWidgetState extends State<SimilarItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 330,
        width: double.infinity,
        child: ProductsBySimilarWidget(
          productID: widget.productID,
          cat: widget.category,
        ));
  }
}
