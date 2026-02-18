import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../../../../core/common/widgets/app_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// TITLE
        CustomText(
          text: title,
          maxLines: 2,
          fontSize: 32.sp,
          textAlign: TextAlign.center,
          textColor: AppColors.velvet,
          fontWeight: FontWeight.w600,
        ),

        Expanded(
          child: AppImage(
            path: image,
            fit: BoxFit.contain,
          ),
        ),

        /// SUBTITLE
        CustomText(
          text: subtitle,
          maxLines: 2,
          fontSize: 20.sp,
          textAlign: TextAlign.center,
          textColor: AppColors.black,
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }
}