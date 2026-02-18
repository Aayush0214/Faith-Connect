import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors/app_colors.dart';

class CustomDotIndicator extends StatelessWidget {
  final int dotsCount;
  final double currentPosition;

  const CustomDotIndicator({super.key, this.dotsCount = 3, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      animate: true,
      fadeOutLastDot: true,
      dotsCount: dotsCount,
      axis: Axis.horizontal,
      position: currentPosition,
      fadeOutDistance: dotsCount - 1,
      mainAxisAlignment: MainAxisAlignment.center,
      animationDuration: const Duration(milliseconds: 300),
      decorator: DotsDecorator(
        size: const Size.square(10),
        activeSize: const Size(30, 7),
        activeColor: AppColors.velvet,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
