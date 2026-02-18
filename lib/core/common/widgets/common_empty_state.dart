import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors/app_colors.dart';
import 'custom_text.dart';

Widget buildEmptyState({required BuildContext context, required Future<void> Function() onRefresh}) {
  return RefreshIndicator(
    color: AppColors.black,
    backgroundColor: AppColors.white,
    onRefresh: onRefresh,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8, // Screen ki height ka 80%
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_motion, size: 60.sp, color: AppColors.black),
            const SizedBox(height: 10),
            CustomText(text: "No posts to show right now", textColor: AppColors.black, fontSize: 20.sp,),
          ],
        ),
      ),
    ),
  );
}