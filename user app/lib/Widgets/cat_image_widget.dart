import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CatImageWidget extends StatefulWidget {
  final String url;
  final String boxFit;
  const CatImageWidget({super.key, required this.url, required this.boxFit});

  @override
  State<CatImageWidget> createState() => _CatImageWidgetState();
}

class _CatImageWidgetState extends State<CatImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.url,
      fit: widget.boxFit == 'cover' ? BoxFit.cover : BoxFit.fill,
      height: double.infinity,
      width: double.infinity,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            _controller.reset();
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
                // margin: EdgeInsets.all(8.0),
              ),
            );
          case LoadState.completed:
            if (state.wasSynchronouslyLoaded) {
              return state.completedWidget;
            }
            _controller.forward();

            ///if you don't want override completed widget
            ///please return null or state.completedWidget
            //return null;
            //return state.completedWidget;
            return FadeTransition(
              opacity: _controller,
              child: state.completedWidget,
            );
          case LoadState.failed:
            _controller.reset();
            //remove memory cached
            state.imageProvider.evict();
            return GestureDetector(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                      // margin: EdgeInsets.all(8.0),
                    ),
                  ),
                  const Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Text(
                      'load image failed, click to reload',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
        }
      },
    );
  }
}
