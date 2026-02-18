import 'package:faith_connect/core/common/widgets/common_snackbar.dart';
import 'package:faith_connect/core/services/video_pre_loader_service/video_pre_loader_service.dart';
import 'package:faith_connect/features/social_action/presentation/common_comment_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/entities/post_entity.dart';
import '../../../../../../core/common/widgets/common_empty_state.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../reels_bloc/reels_bloc.dart';
import '../../../../../../core/common/widgets/reel_item/reel_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    VideoPreLoaderService().disposeAll();
    super.dispose();
  }

  /// Naya Buffering Logic: Sliding Window
  // Future<void> _handleBuffering(int index, List<PostEntity> reels) async {
  //   // Current URL ko track karo
  //   final currentUrl = reels[index].mediaUrl!;
  //   _loadedUrls.add(currentUrl);
  //
  //   // 1. PRELOAD NEXT (Sirf 1 aage ka load karo for fast scroll)
  //   if (index < reels.length - 1) {
  //     final nextUrl = reels[index + 1].mediaUrl!;
  //     _loadedUrls.add(nextUrl);
  //     VideoPreLoaderService().getControllerForReel(nextUrl);
  //   }
  //
  //   // 2. CLEANUP OLD (Jo screen se door chale gaye unhe hatao)
  //   // Piche ke videos remove karo (Current - 2)
  //   if (index > 1) {
  //     final oldUrl = reels[index - 2].mediaUrl!;
  //     if (_loadedUrls.contains(oldUrl)) {
  //       VideoPreLoaderService().disposeController(oldUrl);
  //       _loadedUrls.remove(oldUrl);
  //     }
  //   }
  //
  //   // Aage ke videos remove karo (Current + 2) - Agar user jump karke aaya ho
  //   if (index < reels.length - 2) {
  //     final farUrl = reels[index + 2].mediaUrl!;
  //     if (_loadedUrls.contains(farUrl)) {
  //       VideoPreLoaderService().disposeController(farUrl);
  //       _loadedUrls.remove(farUrl);
  //     }
  //   }
  // }


  /// Sirf Aage ka maal load karo, piche ka dispose mat karo (PageView khud karega)
  void _preloadNext(int index, List<PostEntity> reels) {
    // 2 Reels aage tak preload karo
    for (int i = 1; i <= 2; i++) {
      if (index + i < reels.length) {
        VideoPreLoaderService().preloadReel(reels[index + i].mediaUrl!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReelsBloc, ReelsState>(
      listener: (context, state) {
        if (state.status == ReelsStatus.reelError && state.errorActionMessage.isNotEmpty) {
          showSnackBar(context: context, message: state.errorActionMessage);
        }
        if (state.status == ReelsStatus.reelActionSuccess && state.successActionMessage.isNotEmpty) {
          showSnackBar(context: context, message: state.successActionMessage, color: AppColors.green, icon: Icons.done_all);
        }
      },
      child: BlocBuilder<ReelsBloc, ReelsState>(
        builder: (context, state) {
          if (state.status == ReelsStatus.reelLoading && state.reels.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          if (state.reels.isEmpty) {
            return buildEmptyState(
              context: context,
              onRefresh: () async => context.read<ReelsBloc>().add(FetchReelsEvent()),
            );
          }

          // Initial load par buffering start karo
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_currentIndexNotifier.value == 0) _preloadNext(0, state.reels);
          });

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: state.reels.length + (state.hasMoreData ? 1 : 0),
            onPageChanged: (index) {
              _currentIndexNotifier.value = index;
              // Safe check for range
              if (index < state.reels.length) {
                _preloadNext(index, state.reels);
              }

              if (index >= state.reels.length - 2 && state.hasMoreData && !state.isFetchingMore) {
                context.read<ReelsBloc>().add(FetchMoreReels());
              }
            },
            itemBuilder: (context, index) {
              if (index == state.reels.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final reel = state.reels[index];
              return ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (context, currentIndex, _) {
                  return ReelItem(
                    key: ValueKey(reel.id),
                    reel: reel,
                    isSelf: false,
                    isActive: index == currentIndex,
                    onLikeTap: () => context.read<ReelsBloc>().add(ToggleLikeReel(reelId: reel.id)),
                    onCommentTap: () => showCommentSheet(originalContext: context, postId: reel.id),
                    onSaveTap: () => context.read<ReelsBloc>().add(ToggleSaveReel(reelId: reel.id)),
                    onShareTap: () {},
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}