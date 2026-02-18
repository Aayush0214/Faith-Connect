import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors/app_colors.dart';

void showSnackBar({
  required BuildContext context,
  String message = "something went wrong",
  Color? color = AppColors.errorLight,
  IconData? icon = Icons.report_problem_outlined,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 25.sp,),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomText(
                  text: message,
                  fontSize: 14.sp,
                  textAlign: TextAlign.start,
                  textColor: AppColors.white,
                  fontWeight: FontWeight.w500,
                  textOverflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}

Future<void> showConfirmationDialog({
  required String title,
  required IconData icon,
  required String subTitle,
  required String button1Text,
  required String button2Text,
  required BuildContext context,
  bool useRootNavigator = false,
  required void Function() onButton1Clicked,
  required void Function() onButton2Clicked,
}) async {
  await showCupertinoDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: true,
    builder: (_) => Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(0, 4),
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red.withValues(alpha: 0.1),
                ),
                child: Icon(icon, size: 32.r, color: AppColors.red),
              ),
              SizedBox(height: 16.h),

              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onButton1Clicked,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.errorDark.withValues(alpha: 0.88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(button1Text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(height: 10.h),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onButton2Clicked,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondaryLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(button2Text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}