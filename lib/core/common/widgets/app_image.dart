import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isNetwork => path.startsWith("http");
  bool get _isSvg => path.endsWith(".svg");

  @override
  Widget build(BuildContext context) {
    Widget child;

    // ---------------------------
    // 1️⃣ SVG Image (Assets only)
    // ---------------------------
    if (_isSvg) {
      child = SvgPicture.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        placeholderBuilder: (context) =>
        placeholder ?? const Center(child: CircularProgressIndicator()),
      );
    }

    // ---------------------------
    // 2️⃣ Network Image (With Auth Token) 🔐
    // ---------------------------
    else if (_isNetwork) {
      child = CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => placeholder ?? const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
        errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
      );
    }

    // ---------------------------
    // 3️⃣ Local Asset Image (PNG/JPG)
    // ---------------------------
    else {
      child = Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        gaplessPlayback: true,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stack) =>
        errorWidget ?? const Icon(Icons.broken_image),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }
    return child;
  }
}
