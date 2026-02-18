import 'dart:io';
import '../../theme/app_colors/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    // 1. Permission Check (Android 13 logic included)
    bool hasPermission = await _requestGalleryPermission();

    if (!hasPermission) return null;

    // 2. Pick Image
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Optimization: Size reduce karne ke liye
    );

    if (image != null) return File(image.path);
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50
      );
      if (image != null) return File(image.path);
    }
    return null;
  }

  Future<File?> pickVideoFromGallery() async {
    bool hasPermission = await _requestGalleryPermission();
    if (!hasPermission) return null;

    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2), // Standard constraint
    );

    if (video != null) {
      return File(video.path);
    }
    return null;
  }

  // 🛡️ Industry Standard Permission Logic
  Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ ke liye 'photos' permission
        return await Permission.photos.request().isGranted;
      } else {
        // Old Android ke liye 'storage' permission
        return await Permission.storage.request().isGranted;
      }
    }
    // iOS ke liye
    return await Permission.photos.request().isGranted;
  }

  Future<File?> cropProfileImage(File file) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 90,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Photo',
          lockAspectRatio: true,
          hideBottomControls: true,
          cropStyle: CropStyle.circle,
          toolbarColor: AppColors.black,
          toolbarWidgetColor: AppColors.white,
        ),
        IOSUiSettings(
          title: 'Crop Photo',
          cropStyle: CropStyle.circle,
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    return cropped != null ? File(cropped.path) : null;
  }
}