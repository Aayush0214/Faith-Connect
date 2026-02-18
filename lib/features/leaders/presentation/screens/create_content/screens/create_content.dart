import 'package:faith_connect/core/common/widgets/common_snackbar.dart';
import 'package:faith_connect/core/common/widgets/common_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/widgets/video_player.dart';
import '../create_content_bloc/create_content_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
//
// class CreateContentPage extends StatefulWidget {
//   const CreateContentPage({super.key});
//
//   @override
//   State<CreateContentPage> createState() => _CreateContentPageState();
// }
//
// class _CreateContentPageState extends State<CreateContentPage> {
//   final TextEditingController _captionController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: CustomText(text: "Create Content", fontWeight: FontWeight.bold, textColor: AppColors.black),
//         actions: [
//           BlocBuilder<CreateContentBloc, CreateContentState>(
//             builder: (context, state) {
//               return TextButton(
//                 onPressed: (state is MediaSelectedState)
//                     ? () => context.read<CreateContentBloc>().add(
//                     UploadPostEvent(caption: _captionController.text))
//                     : null,
//                 child: CustomText(
//                   text: "Post",
//                   textColor: (state is MediaSelectedState) ? AppColors.skyBlue : Colors.grey,
//                   fontWeight: FontWeight.bold,
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: BlocConsumer<CreateContentBloc, CreateContentState>(
//         listener: (context, state) {
//           if (state is UploadSuccess) {
//             showSnackBar(context: context, message: "Post Uploaded Successfully", color: AppColors.green, icon: Icons.cloud_done);
//           }
//           if (state is CreateContentError) {
//             showSnackBar(context: context, message: state.message);
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // MEDIA SELECTION AREA
//                 GestureDetector(
//                   onTap: () => _showPickerOptions(context),
//                   child: Container(
//                     height: 350.h,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(15.r),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: _buildMediaPreview(state),
//                   ),
//                 ),
//
//                 SizedBox(height: 20.h),
//
//                 // AUTO-DETECTED TAG
//                 if (state is MediaSelectedState)
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//                     decoration: BoxDecoration(
//                       color: state.postType == 'reel' ? Colors.purple.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(state.postType == 'reel' ? Icons.movie_creation_outlined : Icons.image_outlined, size: 16, color: state.postType == 'reel' ? Colors.purple : Colors.blue),
//                         SizedBox(width: 6.w),
//                         CustomText(text: state.postType.toUpperCase(), fontSize: 12.sp, fontWeight: FontWeight.bold, textColor: state.postType == 'reel' ? Colors.purple : Colors.blue),
//                       ],
//                     ),
//                   ),
//
//                 SizedBox(height: 15.h),
//
//                 // CAPTION FIELD
//                 CommonTextFormField(
//                   isSuffix: false,
//                   isPrefix: false,
//                   maximumLines: 5,
//                   hintText: "What's on your mind? Write a caption...",
//                   prefixIcon: Icons.closed_caption,
//                   controller: _captionController,
//                   keyboardType: TextInputType.multiline,
//                 ),
//
//                 if (state is UploadingState)
//                   const Padding(
//                     padding: EdgeInsets.only(top: 20),
//                     child: Center(child: CircularProgressIndicator()),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildMediaPreview(CreateContentState state) {
//     if (state is MediaSelectedState) {
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           // --- Video ya Image ka Preview ---
//           ClipRRect(
//             borderRadius: BorderRadius.circular(15.r),
//             child: state.postType == 'reel'
//                 ? AppVideoPlayer(
//               key: ValueKey(state.file.path),
//               url: state.file.path, // Local file path bhi kaam karta hai
//               isReel: true,
//               autoPlay: false, // Upload screen par khud se nahi chalega
//             )
//                 : Image.file(state.file, fit: BoxFit.cover),
//           ),
//
//           // --- Reset Button (Fix 1) ---
//           Positioned(
//             right: 10,
//             top: 10,
//             child: GestureDetector(
//               onTap: () {
//                 context.read<CreateContentBloc>().add(ResetMediaEvent());
//               },
//               child: const CircleAvatar(
//                 backgroundColor: Colors.black54,
//                 child: Icon(Icons.close, color: Colors.white, size: 20),
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//
//     // --- Initial State (Jab kuch select na ho) ---
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.cloud_upload_outlined, size: 50.sp, color: Colors.grey),
//         SizedBox(height: 10.h),
//         CustomText(text: "Tap to Select Post or Reel", textColor: Colors.grey),
//       ],
//     );
//   }
//
//   void _showPickerOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (innerContext) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.image),
//               title: const Text('Post (Image)'),
//               onTap: () {
//                 context.read<CreateContentBloc>().add(PickMediaEvent(isVideo: false));
//                 Navigator.pop(innerContext);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.videocam),
//               title: const Text('Reel (Video - Max 2 min)'),
//               onTap: () {
//                 context.read<CreateContentBloc>().add(PickMediaEvent(isVideo: true));
//                 Navigator.pop(innerContext);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CreateContentPage extends StatefulWidget {
  const CreateContentPage({super.key});

  @override
  State<CreateContentPage> createState() => _CreateContentPageState();
}

class _CreateContentPageState extends State<CreateContentPage> {
  late TextEditingController _captionController;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: CustomText(text: "New Post", fontWeight: FontWeight.bold, fontSize: 20.sp, textColor: AppColors.black),
        actions: [
          BlocBuilder<CreateContentBloc, CreateContentState>(
            builder: (context, state) {
              bool canPost = state is MediaSelectedState;
              return TextButton(
                onPressed: canPost ? () => context.read<CreateContentBloc>().add(UploadPostEvent(caption: _captionController.text)) : null,
                child: CustomText(
                  text: "Share",
                  textColor: canPost ? AppColors.skyBlue : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateContentBloc, CreateContentState>(
        listener: (context, state) {
          if (state is UploadSuccess) {
            _captionController.clear();
            showSnackBar(context: context, message: "Post shared successfully!", color: Colors.green);
          }
          if (state is CreateContentError) {
            _captionController.clear();
            showSnackBar(context: context, message: state.message, color: Colors.red);
            debugPrint("Error: ${state.message}");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media Preview Card
                    _buildMediaSection(state),

                    SizedBox(height: 25.h),

                    // Caption Input
                    CustomText(text: "Caption", fontWeight: FontWeight.bold, fontSize: 16.sp, textColor: AppColors.black),
                    SizedBox(height: 10.h),
                    CommonTextFormField(
                      isSuffix: false,
                      isPrefix: false,
                      maximumLines: 5,
                      controller: _captionController,
                      keyboardType: TextInputType.multiline,
                      hintText: "Write something inspiring",
                    ),
                  ],
                ),
              ),

              // --- PREMIUM PROGRESS OVERLAY ---
              if (state is UploadingState)
                _buildLoadingOverlay(state.progress, state.message),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMediaSection(CreateContentState state) {
    return GestureDetector(
      onTap: () => _showPickerOptions(context),
      child: Container(
        height: 300.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade200, width: 2),
        ),
        child: state is MediaSelectedState
            ? _buildSelectedMedia(state)
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildSelectedMedia(MediaSelectedState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: state.postType == 'reel'
              ? AppVideoPlayer(url: state.file.path, isReel: true, autoPlay: false)
              : Image.file(state.file, fit: BoxFit.cover),
        ),
        Positioned(
          top: 15, right: 15,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            child: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () => context.read<CreateContentBloc>().add(ResetMediaEvent()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 60.sp, color: Colors.grey.shade400),
        SizedBox(height: 15.h),
        CustomText(text: "Tap to select media", textColor: Colors.grey.shade600, fontSize: 16.sp),
      ],
    );
  }

  Widget _buildLoadingOverlay(double progress, String message) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.h, width: 100.h,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                color: AppColors.skyBlue,
                backgroundColor: Colors.white10,
              ),
            ),
            SizedBox(height: 25.h),
            CustomText(text: message, textColor: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 5.h),
            CustomText(text: "${(progress * 100).toInt()}%", textColor: Colors.white70, fontSize: 14.sp),
          ],
        ),
      ),
    );
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined, color: AppColors.pink),
              title: const Text("Image Post"),
              onTap: () { context.read<CreateContentBloc>().add(const PickMediaEvent(isVideo: false)); Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.movie_outlined, color: AppColors.blue),
              title: const Text("Reel / Video"),
              onTap: () { context.read<CreateContentBloc>().add(const PickMediaEvent(isVideo: true)); Navigator.pop(context); },
            ),
          ],
        ),
      ),
    );
  }
}