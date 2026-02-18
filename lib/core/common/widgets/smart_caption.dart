import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../theme/app_colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmartCaption extends StatelessWidget {
  final String caption;
  final Color captionColor;

  const SmartCaption({
    super.key,
    required this.caption,
    this.captionColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      caption,
      trimLines: 2,
      trimMode: TrimMode.Line,
      trimCollapsedText: ' more',
      trimExpandedText: ' less',
      colorClickableText: Colors.blueAccent,
      style: TextStyle(fontSize: 13.sp, color: captionColor),
      moreStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey),
      lessStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.grey),
    );
  }
}
