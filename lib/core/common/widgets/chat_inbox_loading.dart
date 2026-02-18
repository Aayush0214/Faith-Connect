import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/widgets/shimmer_loading.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';

class ChatInboxLoading extends StatelessWidget {
  const ChatInboxLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 0),
              color: AppColors.black.withValues(alpha: 0.3),
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShimmerSkeleton(
            height: 40.h,
            width: 40.h,
            shape: BoxShape.circle,
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 2,
            child: Column(
              spacing: 5.h,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(
                  height: 15.h,
                  width: 100.w,
                  borderRadius: 4,
                ),
                ShimmerSkeleton(
                  height: 10.h,
                  width: 150.w,
                  borderRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            flex: 1,
            child: ShimmerSkeleton(
              height: 30.h,
              width: 80.w,
              borderRadius: 4,
            ),
          ),
        ],
      ),
    );
  }
}