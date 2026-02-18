import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:faith_connect/core/common/widgets/app_image.dart';
import 'package:faith_connect/core/constants/constant_images.dart';
import 'package:faith_connect/core/constants/constant_strings.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';

import '../../../core/common/widgets/custom_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            spacing: 10.h,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImage(
                fit: BoxFit.contain,
                path: ConstantImages.appLogo,
                width: MediaQuery.of(context).size.height * 0.25,
              ),
              CustomText(
                text: ConstantStrings.splashText,
                maxLines: 2,
                fontSize: 18.sp,
                textAlign: TextAlign.center,
                textColor: AppColors.velvet,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
