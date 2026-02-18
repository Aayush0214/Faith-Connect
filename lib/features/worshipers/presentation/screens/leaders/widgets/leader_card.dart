import 'package:faith_connect/core/common/widgets/app_network_image.dart';
import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routes/route_names.dart';
import '../../../../domain/entities/leader_entity.dart';
import '../leader_bloc/leader_bloc.dart';

class LeaderCard extends StatelessWidget {
  final LeaderEntity leader;
  final bool isExplore;

  const LeaderCard({super.key, required this.leader, required this.isExplore});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      child: ListTile(
        onTap: () {
          context.pushNamed(
            RouteNames.leaderProfileName,
            extra: {
              'leaderId':leader.id,
              'isSelf': false,
            }
          );
        },
        leading: AppNetworkImage(
          width: 40.h,
          height: 40.h,
          showBorder: true,
          fit: BoxFit.contain,
          url: leader.photoUrl!,
          borderColor: AppColors.black,
        ),
        title: CustomText(text: leader.name, textColor: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.left),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: leader.faith, textColor: AppColors.skyBlue, fontSize: 12.sp, fontWeight: FontWeight.w600, textAlign: TextAlign.left),
            if (leader.bio != null)
              CustomText(text: leader.bio!, textColor: AppColors.grey, fontSize: 12.sp, fontWeight: FontWeight.w600, textAlign: TextAlign.left),
            Row(
              spacing: 5.w,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: "${leader.followersCount} Followers",
                  maxLines: 1,
                  fontSize: 10.sp,
                  textAlign: TextAlign.left,
                  textColor: AppColors.grey,
                  fontWeight: FontWeight.w600,
                  textOverflow: TextOverflow.ellipsis,
                ),
                Icon(Icons.circle, size: 8.sp, color: AppColors.black),
                CustomText(
                  text: "${leader.postsCount} Posts",
                  maxLines: 1,
                  fontSize: 10.sp,
                  textAlign: TextAlign.left,
                  textColor: AppColors.grey,
                  fontWeight: FontWeight.w600,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        trailing: isExplore ? ElevatedButton(
          onPressed: () {
            context.read<LeaderBloc>().add(ToggleFollowEvent(leaderId: leader.id, isExplore: isExplore));
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            foregroundColor: leader.isFollowing ? AppColors.black : AppColors.white,
            backgroundColor: leader.isFollowing ? AppColors.white : AppColors.black,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: leader.isFollowing ? AppColors.black : AppColors.transparent),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(leader.isFollowing ? "Unfollow" : "Follow"),
        ) : Icon(Icons.arrow_forward_ios, size: 14.sp),
      ),
    );
  }
}