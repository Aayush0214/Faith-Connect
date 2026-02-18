import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color gradient1;
  final Color gradient2;

  const GradientButton({
    super.key,
    this.width,
    this.height,
    required this.onTap,
    required this.buttonText,
    this.gradient1 = AppColors.pink,
    this.gradient2 = AppColors.secondaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [gradient1, gradient2],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}