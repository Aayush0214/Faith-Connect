import 'package:faith_connect/core/common/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/theme/app_colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:faith_connect/core/common/widgets/app_image.dart';
import 'package:faith_connect/core/common/widgets/gradient_container.dart';

class RoleSelectionPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final String roleImage1;
  final String roleImage2;
  final String roleTitleFirst;
  final String roleTitleSecond;
  final String roleSubTitleFirst;
  final String roleSubTitleSecond;
  final void Function() onButtonFirstTapped;
  final void Function() onButtonSecondTapped;

  const RoleSelectionPage({
    super.key,
    required this.title,
    required this.subTitle,
    required this.roleTitleFirst,
    required this.roleTitleSecond,
    required this.roleSubTitleFirst,
    required this.roleSubTitleSecond,
    required this.roleImage1,
    required this.roleImage2,
    required this.onButtonFirstTapped,
    required this.onButtonSecondTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: title,
            maxLines: 2,
            fontSize: 32.sp,
            textAlign: TextAlign.center,
            textColor: AppColors.velvet,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            text: subTitle,
            maxLines: 2,
            fontSize: 20.sp,
            textAlign: TextAlign.center,
            textColor: AppColors.black,
            fontWeight: FontWeight.normal,
          ),
          _roleSelectorCard(
            roleImage: roleImage1,
            title: roleTitleFirst,
            subTitle: roleSubTitleFirst,
            gradient: AppColors.secondaryLight,
            onButtonTap: onButtonFirstTapped,
            buttonTitle: "Continue as Worshiper",
          ),
          _roleSelectorCard(
            roleImage: roleImage2,
            title: roleTitleSecond,
            gradient: AppColors.yellow,
            subTitle: roleSubTitleSecond,
            onButtonTap: onButtonSecondTapped,
            buttonTitle: "Continue as Leader",
          ),
        ],
      ),
    );
  }
}

Widget _roleSelectorCard({
  required String title,
  required String subTitle,
  required String roleImage,
  required Color gradient,
  required String buttonTitle,
  required void Function() onButtonTap,
}) {
  return GradientContainer(
    gradient2: gradient,
    width: double.maxFinite,
    padding: EdgeInsets.zero,
    margin: EdgeInsetsGeometry.symmetric(horizontal: 20.w, vertical: 10.h),
    child: Card(
      elevation: 0,
      color: AppColors.white,
      margin: EdgeInsets.all(2.r),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage(
              width: 50.w,
              height: 50.w,
              path: roleImage,
              borderRadius: BorderRadius.circular(20.r),
            ),
            CustomText(
              text: title,
              maxLines: 2,
              fontSize: 25.sp,
              textAlign: TextAlign.center,
              textColor: AppColors.velvet,
              fontWeight: FontWeight.w600,
            ),
            CustomText(
              text: subTitle,
              maxLines: 2,
              fontSize: 18.sp,
              textAlign: TextAlign.center,
              textColor: AppColors.black,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(height: 10.h),

            GradientButton(
              height: 35.h,
              gradient2: gradient,
              buttonText: buttonTitle,
              onTap: () => onButtonTap(),
            )
          ],
        ),
      ),
    ),
  );
}
