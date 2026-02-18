import 'dart:io';

class UploadPostModel {
  final File media;
  final String caption;
  final String postType;
  final File? thumbnail;
  final int? duration;

  UploadPostModel({
    required this.media,
    required this.caption,
    required this.postType,
    this.thumbnail,
    this.duration,
  });
}
