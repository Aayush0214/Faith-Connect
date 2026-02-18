import 'package:faith_connect/core/common/widgets/common_snackbar.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/common/widgets/app_network_image.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/shimmer_loading.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../authentication/presentation/bloc/auth_bloc.dart';

class WorshiperProfile extends StatelessWidget {
  const WorshiperProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          showSnackBar(context: context, message: state.errorMessage);
        }
      },
      child: RefreshIndicator(
        color: AppColors.black,
        backgroundColor: AppColors.white,
        onRefresh: () async {
          context.read<ProfileBloc>().add(FetchWorshiperStatus());
          context.read<ProfileBloc>().stream.firstWhere((state) => state is ProfileSuccessState || state is ProfileErrorState);
        },
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Profile Header
                ProfileHeader(),
                SizedBox(height: 10.h),

                Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10.w, vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            int following = 0;
                            int saved = 0;
                            int interactions = 0;
                            if (state is ProfileInitial){
                              return ProfileLoadingShimmer();
                            }
                            if (state is ProfileSuccessState) {
                              following = state.worshiperStats['following']!;
                              saved = state.worshiperStats['saved']!;
                              interactions = state.worshiperStats['interactions']!;
                            }
                            return Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                      color: AppColors.black.withValues(alpha: 0.1),
                                    ),
                                  ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _metaDataColumn(title: "Following", value: following.toString()),
                                  Container(width: 1.w, height: 30.h, color: AppColors.black),
                                  _metaDataColumn(title: "Saved", value: saved.toString()),
                                  Container(width: 1.w, height: 30.h, color: AppColors.black),
                                  _metaDataColumn(title: "Interactions", value: interactions.toString()),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),

                        CustomText(
                          text: "Account & Activity",
                          fontSize: 16.sp,
                          textColor: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 15.h),

                        // 1. Saved Content
                        _buildProfileTile(
                          icon: Icons.bookmark_outline_rounded,
                          title: "Saved Inspiration",
                          subtitle: "View your bookmarked posts & reels",
                          onTap: () {
                            // Navigate to SavedPostsScreen
                          },
                        ),

                        // 2. Following List
                        _buildProfileTile(
                          icon: Icons.people_outline_rounded,
                          title: "Leaders I Follow",
                          subtitle: "Manage your spiritual connections",
                          onTap: () {
                            // Navigate to FollowingListScreen
                          },
                        ),

                        // 3. Edit Profile
                        _buildProfileTile(
                          icon: Icons.edit_note_rounded,
                          title: "Edit Profile",
                          subtitle: "Change your bio, photo, or name",
                          onTap: () {
                            // Navigate to EditProfileScreen
                          },
                        ),

                        // 4. Notifications
                        _buildProfileTile(
                          icon: Icons.notifications_none_rounded,
                          title: "Notification Settings",
                          subtitle: "Alerts for new posts & messages",
                          onTap: () {},
                        ),

                        // 5. Logout
                        _buildProfileTile(
                          icon: Icons.logout_rounded,
                          title: "Logout",
                          subtitle: "See you again soon",
                          iconColor: Colors.redAccent,
                          onTap: () {
                            showConfirmationDialog(
                              context: context,
                              icon: Icons.logout,
                              title: "Logout",
                              subTitle: "Are you sure you want to logout?",
                              button1Text: "Yes, Logout",
                              button2Text: "Cancel",
                              onButton1Clicked: () {
                                Navigator.pop(context);
                                context.read<ProfileBloc>().add(LogoutEvent());
                              },
                              onButton2Clicked: () => Navigator.pop(context),
                            );
                          },
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    IconData getFaithIcon(String faith) {
      switch (faith) {
        case 'Hinduism':
          return Icons.temple_hindu;
        case 'Christianity':
          return Icons.church;
        case 'Islam':
          return Icons.mosque;
        case 'Judaism':
          return Icons.synagogue;
        case 'Buddhism':
          return Icons.temple_buddhist;
        default:
          return Icons.accessibility;
      }
    }
    return BlocBuilder<AuthBloc, AppAuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return ProfileHeaderShimmer();
        }
        String name = "Guest";
        String faith = "";
        String imageUrl = "";
        String bio = "";

        if (state is AuthAuthenticated) {
          name = state.user.userMetadata?['full_name'];
          imageUrl = state.user.userMetadata?['profile_photo_url'];
          faith = state.user.userMetadata?['faith'];
          bio = state.user.userMetadata?['bio'];
        }
        return Container(
          width: double.infinity,
          color: AppColors.white,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image with Border
              AppNetworkImage(
                url: imageUrl,
                width: 100.r,
                height: 100.r,
              ),
              SizedBox(height: 10.h),

              // Name
              CustomText(
                text: name,
                maxLines: 1,
                fontSize: 22.sp,
                textColor: Colors.black87,
                fontWeight: FontWeight.bold,
              ),

              // Faith
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  spacing: 8.w,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(getFaithIcon(faith), size: 20.sp, color: AppColors.white),
                    CustomText(
                      text: faith,
                      maxLines: 1,
                      fontSize: 14.sp,
                      textColor: AppColors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: bio,
                fontSize: 14.sp,
                isItalic: true,
                textColor: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.05),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Icon Circle Bone
          ShimmerSkeleton(
            height: 100.r,
            width: 100.r,
            shape: BoxShape.circle,
          ),

          SizedBox(height: 12.h),

          // 2. Text Line Bone
          ShimmerSkeleton(
            height: 25.h,
            width: 200.w,
            borderRadius: 4,
            shape: BoxShape.rectangle,
          ),

          SizedBox(height: 5.h),

          // 2. Text Line Bone
          ShimmerSkeleton(
            height: 15.h,
            width: double.maxFinite,
            borderRadius: 4,
            shape: BoxShape.rectangle,
          ),

          SizedBox(height: 12.h),

          // 2. Text Line Bone
          ShimmerSkeleton(
            height: 40.h,
            width: 150.w,
            borderRadius: 4,
            shape: BoxShape.rectangle,
          ),
        ],
      ),
    );
  }
}

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 4),
            color: AppColors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _metaDataLoading()),
          Container(width: 1.w, height: 30.h, color: AppColors.black),
          Expanded(child: _metaDataLoading()),
          Container(width: 1.w, height: 30.h, color: AppColors.black),
          Expanded(child: _metaDataLoading()),
        ],
      ),
    );
  }
}


Widget _metaDataColumn({required String title, required String value}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CustomText(
        text: title,
        maxLines: 1,
        fontSize: 14.sp,
        textColor: AppColors.black,
        fontWeight: FontWeight.bold,
        textOverflow: TextOverflow.ellipsis,
      ),
      CustomText(
        text: value,
        maxLines: 1,
        fontSize: 13.sp,
        textColor: AppColors.black,
        fontWeight: FontWeight.w500,
        textOverflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

Widget _metaDataLoading() {
  return Column(
    spacing: 5.h,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ShimmerSkeleton(
        height: 20.h,
        width: 80.w,
        borderRadius: 4,
      ),
      ShimmerSkeleton(
        height: 20.h,
        width: 50.w,
        borderRadius: 4,
      ),
    ],
  );
}

Widget _buildProfileTile({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
  Color? iconColor,
}) {
  return Container(
    width: double.maxFinite,
    margin: EdgeInsets.only(bottom: 10.h),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15.r),
      boxShadow: [
        BoxShadow(
          blurRadius: 6,
          offset: Offset(0, 4),
          color: AppColors.black.withValues(alpha: 0.1),
        ),
      ]
    ),
    child: ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 0),
              color: AppColors.black.withValues(alpha: 0.16),
            )
          ]
        ),
        child: Icon(icon, color: iconColor?? AppColors.black, size: 24.sp),
      ),
      title: CustomText(
        text: title,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        textColor: AppColors.black,
        textAlign: TextAlign.start,
      ),
      subtitle: CustomText(
        text: subtitle,
        fontSize: 12.sp,
        textColor: AppColors.grey,
        textAlign: TextAlign.start,
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: AppColors.grey),
      onTap: onTap,
    ),
  );
}