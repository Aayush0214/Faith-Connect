import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors/app_colors.dart';

class GradientContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final Color gradient1;
  final Color gradient2;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const GradientContainer({
    super.key,
    this.height,
    this.width,
    this.gradient1 = AppColors.pink,
    this.gradient2 = AppColors.secondaryLight,
    this.margin = const EdgeInsetsGeometry.all(10),
    this.padding = const EdgeInsetsGeometry.all(10),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            gradient1,
            gradient2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: child,
    );
  }
}


