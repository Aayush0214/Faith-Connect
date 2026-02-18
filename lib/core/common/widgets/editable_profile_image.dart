import 'dart:io';
import 'app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors/app_colors.dart';

class EditableProfileImage extends StatelessWidget {
  final File? localImage;
  final String? networkImageUrl;
  final double radius;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;

  const EditableProfileImage({
    super.key,
    this.localImage,
    this.networkImageUrl,
    this.radius = 40,
    required this.onPickCamera,
    required this.onPickGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.velvet,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: _buildImage(context),
          ),
        ),

        Positioned(
          bottom: 0.h,
          right: 1.w,
          child: InkWell(
            onTap: () => _showSourceSheet(context),
            child: CircleAvatar(
              radius: 16.r,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.camera_alt, size: 16.r, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  /// 🔑 CORE IMAGE DECISION LOGIC
  Widget _buildImage(BuildContext context) {
    // 1️⃣ Local image → highest priority
    if (localImage != null) {
      return Image.file(
        localImage!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
      );
    }

    // 2️⃣ Network image (secure)
    if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      return AppNetworkImage(
        width: radius * 2,
        height: radius * 2,
        url: networkImageUrl!,
      );
    }

    // 3️⃣ Fallback placeholder
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.person, size: radius * 2, color: Colors.grey),
    );
  }

  void _showSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                onPickGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                onPickCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}