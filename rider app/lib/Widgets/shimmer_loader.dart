import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoaderWidget extends StatefulWidget {
  const ShimmerLoaderWidget({super.key});

  @override
  State<ShimmerLoaderWidget> createState() => _ShimmerLoaderWidgetState();
}

class _ShimmerLoaderWidgetState extends State<ShimmerLoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200, // Set the width as needed
              height: 15, // Set the height as needed
              color: Colors.grey, // Set the color as needed
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 300, // Set the width as needed
              height: 14, // Set the height as needed
              color: Colors.grey, // Set the color as needed
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 400, // Set the width as needed
              height: 15, // Set the height as needed
              color: Colors.grey, // Set the color as needed
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 250, // Set the width as needed
              height: 15, // Set the height as needed
              color: Colors.grey, // Set the color as needed
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 290, // Set the width as needed
              height: 15, // Set the height as needed
              color: Colors.grey, // Set the color as needed
            ),
          ),
        ),
      ],
    );
  }
}
