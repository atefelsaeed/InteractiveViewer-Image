import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InterActiveViewerImage extends StatelessWidget {
   InterActiveViewerImage({Key? key}) : super(key: key);

  final _transformationController = TransformationController();
  final _imageHasLoaded=true;
var cropperKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: cropperKey,
      child: LayoutBuilder(
        builder: (_, constraint) {
          return InteractiveViewer(
            transformationController: _transformationController,
            constrained: false,
            // panEnabled: false,
            scaleEnabled :false,
            // boundaryMargin: EdgeInsets.all(42),
            child: Builder(
              builder: (context) {
                // Set the initial scale once the image has been loaded
                if (_imageHasLoaded) {
                  _setInitialScale(context, constraint.biggest);
                }

                return Image.network('https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg?size=626&ext=jpg&ga=GA1.2.186927272.1633132800');
              },
            ),
            minScale: 0.1,
          );
        },
      ),
    );
  }

// Calculate ratio based on constraints of the cropper (outside) and the image (inside)
  double _getCoverRatio(Size outside, Size inside) {
    return outside.width / outside.height > inside.width / inside.height
        ? outside.width / inside.width
        : outside.height / inside.height;
  }

// Set the initial scale of the image
  void _setInitialScale(BuildContext context, Size parentSize) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject() as RenderBox?;
      final childSize = renderBox?.size ?? Size.zero;
      if (childSize != Size.zero) {
        _transformationController.value =
            Matrix4.identity() * _getCoverRatio(parentSize, childSize);
      }
    });
  }
}
