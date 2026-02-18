import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/shimmer_loading.dart';

class CommentLoadingShimmer extends StatelessWidget {
  const CommentLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),

      // 1. Icon/Avatar Skeleton
      leading: ShimmerSkeleton(
        height: 35.r,
        width: 35.r,
        shape: BoxShape.circle,
      ),

      // 2. Title Skeleton
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerSkeleton(
            height: 15.h,
            width: 150.w,
            borderRadius: 4,
          ),
          SizedBox(height: 8.h),
        ],
      ),

      // 3. Subtitle Skeleton (Description lines)
      subtitle: ShimmerSkeleton(
        height: 8.h,
        width: 150.w,
        borderRadius: 4,
      ),

      // 4. Time Skeleton (Optional Trailing)
      trailing: ShimmerSkeleton(
        height: 25.r,
        width: 50.r,
        shape: BoxShape.rectangle,
      ),
    );
  }
}