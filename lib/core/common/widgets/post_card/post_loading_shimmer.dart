import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shimmer_loading.dart';

class PostLoadingShimmer extends StatelessWidget {
  const PostLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
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
      child: Column(
        spacing: 10.h,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerSkeleton(
                height: 35.r,
                width: 35.r,
                shape: BoxShape.circle,
              ),
              ShimmerSkeleton(
                height: 25.h,
                width: 150.w,
                borderRadius: 4,
              ),
            ],
          ),
          ShimmerSkeleton(
            height: 25.h,
            borderRadius: 4,
          ),

          ShimmerSkeleton(
            height: 150.h,
            borderRadius: 4,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerSkeleton(
                height: 25.h,
                width: 50.w,
                borderRadius: 4,
              ),

              ShimmerSkeleton(
                height: 25.h,
                width: 50.w,
                borderRadius: 4,
              ),

              ShimmerSkeleton(
                height: 25.h,
                width: 50.w,
                borderRadius: 4,
              ),

              ShimmerSkeleton(
                height: 25.h,
                width: 50.w,
                borderRadius: 4,
              ),
            ],
          )

        ],
      ),
    );
  }
}
