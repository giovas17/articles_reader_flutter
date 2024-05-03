import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String image;

  const RoundedImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.6;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        image,
        height: imageSize,
        width: imageSize,
        fit: BoxFit.fitWidth,
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: imageSize,
            height: imageSize,
            padding: const EdgeInsets.all(10),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, object, stackTrace) {
          return FlutterLogo(size: imageSize);
        },
      ),
    );
  }
}

class NetImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double aspectRatio;
  final Color background;

  const NetImage(
      {super.key,
      required this.imageUrl,
      required this.width,
      required this.aspectRatio,
      this.background = Colors.black});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        color: background,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              padding: const EdgeInsets.all(10),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (_, object, stackTrace) {
            return FlutterLogo(size: width);
          },
        ),
      ),
    );
  }
}
