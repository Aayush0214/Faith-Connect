import 'package:flutter/material.dart';
import '../../../../core/common/widgets/app_image.dart';
import 'package:faith_connect/core/common/widgets/common_container.dart';

class SocialLoginButton extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final String socialIconPath;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    this.height = 20,
    this.width = 20,
    this.radius = 10,
    required this.onTap,
    required this.socialIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: CommonContainer(
          child: AppImage(
            width: width,
            height: height,
            path: socialIconPath,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
