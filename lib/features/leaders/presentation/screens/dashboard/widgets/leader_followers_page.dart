import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/entities/user_entity.dart';
import '../../../../../../core/common/widgets/app_network_image.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../dashboard_bloc/leader_dashboard_bloc.dart';

class LeaderFollowersPage extends StatelessWidget {
  const LeaderFollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Followers",
          fontWeight: FontWeight.bold,
          textColor: AppColors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: BlocBuilder<LeaderDashboardBloc, LeaderDashboardState>(
        builder: (context, state) {
          if (state.leaderFollowers.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            itemCount: state.leaderFollowers.length,
            separatorBuilder: (context, index) => Divider(color: AppColors.black, height: 1,),
            itemBuilder: (context, index) {
              final user = state.leaderFollowers[index];
              return _followerTile(context, user);
            },
          );
        },
      ),
    );
  }

  Widget _followerTile(BuildContext context, UserEntity user) {
    return Row(
      children: [
        AppNetworkImage(
          url: user.profilePhotoUrl ?? "",
          height: 50.w,
          width: 50.w,
          borderRadius: BorderRadius.circular(25.r),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: user.fullName,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                textColor: AppColors.black,
              ),
              CustomText(
                text: user.bio ?? "Worshipper",
                textColor: Colors.grey,
                fontSize: 12.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 10.h),
          CustomText(text: "No followers yet", textColor: Colors.grey),
        ],
      ),
    );
  }
}