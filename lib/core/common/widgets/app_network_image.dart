import 'package:flutter/material.dart';
import '../../theme/app_colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final bool showBorder;
  final Color borderColor;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderColor = AppColors.velvet,
    this.showBorder = true,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder ? Border.all(color: borderColor, width: 1.5.w) : null,
        boxShadow: [
          BoxShadow(
            blurRadius: 10.r,
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          fit: fit,
          width: width,
          imageUrl: url,
          height: height,
          alignment: Alignment.center,
          placeholder: (context, url) => placeholder ?? const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) {
            debugPrint("🔥 Image Load Error for $url : $error");
            if (error is Exception) {
              debugPrint("🔥 Exception details: ${error.toString()}");
            }
            return errorWidget ??
                Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
          },
        ),
      ),
    );
  }
}
