import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/leaders/presentation/screens/dashboard/dashboard_bloc/leader_dashboard_bloc.dart';
import '../../../services/video_pre_loader_service/video_pre_loader_service.dart';
import '../common_snackbar.dart';
import '../custom_text.dart';
import '../video_player.dart';
import '../../../theme/app_colors/app_colors.dart';
import 'package:faith_connect/core/common/entities/post_entity.dart';
import 'package:faith_connect/core/common/widgets/smart_caption.dart';
import 'package:faith_connect/core/common/widgets/app_network_image.dart';
import 'package:faith_connect/core/common/widgets/animated_like_button.dart';

class ReelItem extends StatefulWidget {
  final PostEntity reel;
  final bool isSelf;
  final bool isActive;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;
  final VoidCallback onShareTap;

  const ReelItem({
    super.key,
    required this.reel,
    required this.isSelf,
    required this.isActive,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
    required this.onShareTap,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> with SingleTickerProviderStateMixin{

  late AnimationController _iconController;
  late Animation<double> _iconOpacity;
  final ValueNotifier<bool> _showMuteIconNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _showMuteIconNotifier.dispose();
    super.dispose();
  }

  void _handleTap() {
    // 1. Global Mute Toggle (Static Notifier in Service)
    final bool currentMute = VideoPreLoaderService.reelMuteNotifier.value;
    VideoPreLoaderService.reelMuteNotifier.value = !currentMute;

    // 2. Icon Pop-up Logic
    _showMuteIconNotifier.value = true;
    _iconController.forward(from: 0.0).then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _iconController.reverse().then((_) {
            _showMuteIconNotifier.value = false;
          });
        }
      });
    });
  }

  void _handleMenuAction(String value, BuildContext context) {
    switch (value) {
      case 'report':
        showSnackBar(context: context, message: "Reported successfully");
        break;
      case 'delete':
        showConfirmationDialog(
          context: context,
          title: "Delete!",
          icon: Icons.delete,
          subTitle: "Are you sure you want to delete this post?",
          useRootNavigator: false,
          button1Text: "Delete",
          button2Text: "Cancel",
          onButton1Clicked: (){
            context.read<LeaderDashboardBloc>().add(
              DeleteLeaderPostEvent(
                postId: widget.reel.id,
                type: 'reel',
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
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _handleTap,
            child: AppVideoPlayer(
              url: widget.reel.mediaUrl!,
              isReel: true,
              autoPlay: widget.isActive,
            ),
          ),
        ),

        // MUTE ICON LAYER (Using ValueListenableBuilder for performance)
        Positioned.fill(
          child: ValueListenableBuilder<bool>(
            valueListenable: _showMuteIconNotifier,
            builder: (context, showIcon, child) {
              if (!showIcon) return const SizedBox.shrink();
              return Center(
                child: FadeTransition(
                  opacity: _iconOpacity,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: VideoPreLoaderService.reelMuteNotifier,
                      builder: (context, isMuted, _) {
                        return Icon(
                          isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 50,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Overlay Content
        Positioned(
          bottom: 30,
          left: 15,
          right: 70,
          child: _buildGradientOverlay(),
        ),

        // Side Buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildGradientOverlay() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
          stops: const [0.6, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppNetworkImage(
                url: widget.reel.leaderPhoto!,
                height: 30.w,
                width: 30.w,
                fit: BoxFit.contain,
                showBorder: true,
                borderColor: AppColors.white,
              ),
              CustomText(text: widget.reel.leaderName, textColor: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16.sp, textAlign: TextAlign.left),
            ],
          ),
          SizedBox(height: 5.h),
          SmartCaption(caption: widget.reel.caption!, captionColor: AppColors.white,),
        ],
      ),
    );
  }

  Widget _buildActionButtons(){
    return Positioned(
      right: 15,
      bottom: 100,
      child: Column(
        spacing: 10.h,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconWithCount(
            icon: widget.reel.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.reel.isLiked ? AppColors.red : AppColors.white,
            count: widget.reel.likesCount,
            onTap: widget.onLikeTap,
          ),

          _iconWithCount(icon: Icons.chat_bubble_outline,
            color: AppColors.white,
            count: widget.reel.commentsCount,
            onTap: widget.onCommentTap,
          ),

          if(!widget.isSelf) _iconWithCount(
            icon: widget.reel.isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: AppColors.white,
            showCount: false,
            onTap: widget.onSaveTap,
          ),

          _iconWithCount(icon: Icons.share_outlined,
            color: AppColors.white,
            showCount: false,
            onTap: widget.onShareTap,
          ),

          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Colors.grey[900], // Dark theme menu for Reels
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz, color: AppColors.white, size: 28.sp),
              color: AppColors.white,
              onSelected: (value) => _handleMenuAction(value, context),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'report',
                  child: Text('Report', style: TextStyle(color: Colors.black)),
                ),
                if (widget.isSelf)
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconWithCount({required IconData icon, required Color color, int count = 0, bool showCount = true, required VoidCallback onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedActionButton(icon: icon, count: count, iconColor: color, onTap: onTap),
        showCount ? CustomText(text: "$count", textColor: AppColors.white, fontWeight: FontWeight.w600, fontSize: 13.sp, textAlign: TextAlign.left) : SizedBox(),
      ],
    );
  }
}
