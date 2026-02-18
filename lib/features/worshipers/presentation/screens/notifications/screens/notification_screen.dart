import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomText(
          text: "This feature is coming soon..",
          fontSize: 28.sp,
          maxLines: 2,
          textColor: AppColors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
