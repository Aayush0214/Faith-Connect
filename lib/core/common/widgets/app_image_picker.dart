import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppImagePicker extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final double radius;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const AppImagePicker({
    super.key,
    this.imageFile,
    this.imageUrl,
    this.radius = 40,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Profile Image
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryLight, width: 2),
          ),
          child: CircleAvatar(
            radius: radius.r,
            backgroundColor: Colors.grey[200],
            backgroundImage: _getBackgroundImage(),
            child: _buildPlaceholder(),
          ),
        ),

        // 2. Camera Button
        Positioned(
          bottom: 2.h,
          right: 2.w,
          child: InkWell(
            onTap: () => _showSourceSheet(context),
            child: CircleAvatar(
              radius: 16.r,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.camera_alt, size: 16.r, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getBackgroundImage() {
    if (imageFile != null) return FileImage(imageFile!);
    if (imageUrl != null && imageUrl!.isNotEmpty) return NetworkImage(imageUrl!);
    return null;
  }

  Widget? _buildPlaceholder() {
    if (imageFile == null && (imageUrl == null || imageUrl!.isEmpty)) {
      return Icon(Icons.person, size: 50.r, color: Colors.grey);
    }
    return null;
  }

  void _showSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGalleryTap();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                onCameraTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}