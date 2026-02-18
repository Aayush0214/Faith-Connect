import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxShape shape;
  final double borderRadius;

  const ShimmerSkeleton({
    super.key,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape,
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(borderRadius.r) : null,
        ),
      ),
    );
  }
}