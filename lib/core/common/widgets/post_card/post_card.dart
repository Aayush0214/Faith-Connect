import 'package:faith_connect/core/common/widgets/app_image.dart';
import 'package:faith_connect/core/common/widgets/app_network_image.dart';
import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:faith_connect/core/common/widgets/smart_caption.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../features/leaders/presentation/screens/dashboard/dashboard_bloc/leader_dashboard_bloc.dart';
import '../../../routes/route_names.dart';
import '../animated_like_button.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../entities/post_entity.dart';
import '../common_snackbar.dart';
import '../video_player.dart';

class PostCard extends StatefulWidget {
  final PostEntity post;
  final bool isSelf;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;
  final VoidCallback onShareTap;

  const PostCard({
    super.key,
    required this.post,
    required this.isSelf,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
    required this.onShareTap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late ValueNotifier<bool> _isPlayable;

  @override
  void initState() {
    super.initState();
    _isPlayable = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isPlayable.dispose();
    super.dispose();
  }

  void _handleMenuAction(String value, BuildContext context) {
    switch (value) {
      case 'share':
        widget.onShareTap();
        break;
      case 'report':
        showSnackBar(context: context, message: "Reported successfully");
        break;
      case 'delete':
        showConfirmationDialog(
          context: context,
          title: "Delete!",
          icon: Icons.delete,
          subTitle: "Are you sure you want to delete this reel?",
          useRootNavigator: false,
          button1Text: "Delete",
          button2Text: "Cancel",
          onButton1Clicked: (){
            context.read<LeaderDashboardBloc>().add(
              DeleteLeaderPostEvent(
                postId: widget.post.id,
                type: 'post',
              ),
            );
            Navigator.pop(context);
          },
          onButton2Clicked: () => Navigator.pop(context),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.post.id),
      onVisibilityChanged: (info) {
        if (!mounted) return;

        bool visible = info.visibleFraction > 0.8;
        if (_isPlayable.value != visible) {
          _isPlayable.value = visible;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            _buildHeader(),

            // --- SMART CAPTION ---
            if (widget.post.caption != null) _buildSmartCaption(),

            // --- DYNAMIC MEDIA CONTENT ---
            if (widget.post.mediaUrl != null) _buildDynamicMedia(),

            // --- ACTION BUTTONS ---
            _buildActionButtons(context),

            const Divider(thickness: 1, height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      child: Row(
        children: [
          AppNetworkImage(url: widget.post.leaderPhoto ?? "", height: 35.w, width: 35.w,),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: (){
                  context.pushNamed(
                      RouteNames.leaderProfileName,
                      extra: {
                        'leaderId':widget.post.leaderId,
                        'isSelf': widget.isSelf,
                      }
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: CustomText(text: widget.post.leaderName, textColor: AppColors.black, fontWeight: FontWeight.bold, fontSize: 14.sp, textAlign: TextAlign.left),
              ),
              CustomText(
                text: "${timeago.format(widget.post.createdAt, locale: 'en_short')} ago",
                textColor: AppColors.textDisabledDark,
                fontWeight: FontWeight.normal, fontSize: 12.sp,
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 20.sp),
            color: AppColors.white,
            offset: Offset(0, 0),
            shadowColor: AppColors.black.withValues(alpha: 0.8),
            onSelected: (value) => _handleMenuAction(value, context),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'share',
                child: ListTile(
                  leading: Icon(Icons.share, size: 20),
                  title: Text('Share Post'),
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: ListTile(
                  leading: Icon(Icons.report_problem_outlined, size: 20),
                  title: Text('Report'),
                ),
              ),

              // MAGIC: Only show Delete if it's the leader's own post
              if (widget.isSelf)
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartCaption() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: SmartCaption(caption: widget.post.caption!),
    );
  }

  Widget _buildDynamicMedia() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPlayable,
      builder: (context, canPlay, child) {
        return Container(
          width: double.infinity,
          color: Colors.black.withValues(alpha: 0.03),
          child: ConstrainedBox(
            constraints: BoxConstraints(
            ),
            child: widget.post.postType == 'reel' || widget.post.postType == 'video'
                ? AppVideoPlayer(
              url: widget.post.mediaUrl!,
              isReel: false,
              autoPlay: canPlay,
            ) : AppImage(
              path: widget.post.mediaUrl!,
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: widget.isSelf ? MainAxisAlignment.spaceAround : MainAxisAlignment.spaceBetween,
        children: [
          _iconWithCount(
            icon: widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.post.isLiked ? AppColors.red : AppColors.black,
            count: widget.post.likesCount,
            onTap: widget.onLikeTap,
          ),

          _iconWithCount(
            icon: Icons.comment,
            color: AppColors.black,
            count: widget.post.commentsCount,
            onTap: widget.onCommentTap,
          ),

          _iconWithCount(
            showCount: false,
            icon: Icons.share,
            color: AppColors.black,
            onTap: widget.onShareTap,
          ),

          if(!widget.isSelf) _iconWithCount(
            icon: widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border,
            showCount: false,
            color: AppColors.black,
            onTap: widget.onSaveTap,
          ),
        ],
      ),
    );
  }

  Widget _iconWithCount({required IconData icon, required Color color, int count = 0, bool showCount = true, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedActionButton(icon: icon, count: count, iconColor: color, onTap: onTap),
        showCount ? CustomText(text: "$count", textColor: AppColors.black, fontWeight: FontWeight.w600, fontSize: 13.sp, textAlign: TextAlign.left) : SizedBox(),
      ],
    );
  }
}