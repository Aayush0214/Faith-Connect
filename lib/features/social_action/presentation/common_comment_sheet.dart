import 'package:faith_connect/features/social_action/presentation/bloc/social_action_bloc.dart';
import 'package:faith_connect/features/social_action/presentation/comment_loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/common/entities/comment_entity.dart';
import '../../../core/common/widgets/app_network_image.dart';
import '../../../core/common/widgets/common_snackbar.dart';
import '../../../core/common/widgets/custom_text.dart';
import '../../../core/theme/app_colors/app_colors.dart';
import '../../../injection.dart';

void showCommentSheet({required BuildContext originalContext, required String postId}) {
  final socialBloc = sl<SocialActionBloc>();
  socialBloc.add(FetchCommentsEvent(postId: postId));
  final TextEditingController commentController = TextEditingController();
  showModalBottomSheet(
    context: originalContext,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocProvider.value(
        value: socialBloc,
        child: Builder(builder: (blocContext) {
          return BlocListener<SocialActionBloc, SocialActionState>(
            listener: (context, state) {
              if (state is SocialActionSuccess) {
                commentController.clear();
                showSnackBar(context: context, message: state.message, color: AppColors.green, icon: Icons.done_all);
              }
              if (state is SocialActionFailure) {
                commentController.clear();
                showSnackBar(context: context, message: state.error);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(blocContext).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(blocContext).size.height * 0.7,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    CustomText(text: "Comments", textColor: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
                    SizedBox(height: 10.h),
                    const Divider(height: 1),

                    Expanded(
                      child: BlocBuilder<SocialActionBloc, SocialActionState>(
                        builder: (context, state) {
                          if (state is SocialActionLoading){
                            return ListView.builder(
                              itemCount: 10,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => CommentLoadingShimmer(),
                            );
                          }
                          if (state is CommentsLoaded){
                            if (state.comments.isEmpty){
                              return RefreshIndicator(
                                color: AppColors.black,
                                backgroundColor: AppColors.white,
                                onRefresh: () async {
                                  socialBloc.add(FetchCommentsEvent(postId: postId));
                                  socialBloc.stream.firstWhere((state) => state is CommentsLoaded || state is SocialActionSuccess || state is SocialActionFailure);
                                },
                                child: SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.6,
                                    child: Center(
                                      child: CustomText(
                                        text: "Be the first to comment ✨",
                                        textColor: AppColors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return RefreshIndicator(
                              color: AppColors.black,
                              backgroundColor: AppColors.white,
                              onRefresh: () async {
                                socialBloc.add(FetchCommentsEvent(postId: postId));
                                socialBloc.stream.firstWhere((state) => state is CommentsLoaded || state is SocialActionSuccess || state is SocialActionFailure);
                              },
                              child: ListView.builder(
                                  itemCount: state.comments.length,
                                  itemBuilder: (context, index){
                                    final comment = state.comments[index];
                                    return buildCommentTile(
                                        context: context,
                                        comment: comment,
                                        onDeleteTap: () async =>  context.read<SocialActionBloc>().add(DeleteCommentEvent(commentId: comment.id, postId: comment.postId))
                                    );
                                  }
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    const Divider(height: 1),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Add comment...",
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: AppColors.black),
                            onPressed: () {
                              if (commentController.text.trim().isNotEmpty) {
                                socialBloc.add(AddCommentEvent(postId: postId, comment: commentController.text));
                                FocusScope.of(context).unfocus();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  ).then((_){
    socialBloc.close();
  });
}

Widget buildCommentTile({required BuildContext context, required CommentEntity comment, required VoidCallback onDeleteTap}) {
  final currentUserId = sl<SupabaseClient>().auth.currentUser?.id;
  final bool isMyComment = comment.userId == currentUserId;

  String formattedTime = timeago.format(comment.createdAt, locale: 'en_short');

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Photo
        AppNetworkImage(url: comment.userPhoto!, width: 35.w, height: 35.w, showBorder: false, fit: BoxFit.scaleDown,),
        SizedBox(width: 12.w),

        // Comment Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    text: comment.userName,
                    textColor: AppColors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: formattedTime,
                    textColor: Colors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: comment.commentText,
                textColor: AppColors.black.withValues(alpha: 0.8),
                fontSize: 13.sp,
                textAlign: TextAlign.left,
              ),

              // Bottom Action (Like/Reply feel dene ke liye)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {}, // Reply logic baad mein
                      child: CustomText(text: "Reply", fontSize: 11.sp, textColor: Colors.grey[800]!, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Options Menu
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          color: AppColors.white,
          icon: Icon(Icons.more_horiz, size: 20.sp, color: Colors.grey[600]),
          onSelected: (value) {
            if (value == 'delete') {
              onDeleteTap();
            } else if (value == 'report') {
              showSnackBar(context: context, message: "Comment Reported", icon: Icons.report);
            } else if (value == 'copy') {
              Clipboard.setData(ClipboardData(text: comment.commentText));
              showSnackBar(context: context, message: "Comment Copied", color: AppColors.black, icon: Icons.copy);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'copy', child: Row(children: [Icon(Icons.copy, size: 18), SizedBox(width: 8), Text("Copy text")])),
            const PopupMenuItem(value: 'report', child: Row(children: [Icon(Icons.flag_outlined, size: 18), SizedBox(width: 8), Text("Report")])),
            if (isMyComment)
              const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [Icon(Icons.delete_outline, color: Colors.red, size: 18), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])
              ),
          ],
        ),
      ],
    ),
  );
}

