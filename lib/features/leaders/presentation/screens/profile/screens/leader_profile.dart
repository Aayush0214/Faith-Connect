import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/common/widgets/common_snackbar.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../leader_profile_bloc/leader_profile_bloc.dart';

class LeaderProfile extends StatelessWidget {
  const LeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaderProfileBloc, LeaderProfileState>(
      listener: (context, state) {
        if (state is LeaderProfileErrorState) {
          showSnackBar(context: context, message: state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: CustomText(
            text: "Settings",
            fontSize: 20.sp,
            textColor: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
              height: 1.h,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10.w, vertical: 12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        context.read<LeaderProfileBloc>().add(LogoutEvent());
                      },
                      onButton2Clicked: () => Navigator.pop(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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