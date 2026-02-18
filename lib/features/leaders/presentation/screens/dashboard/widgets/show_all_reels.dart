import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/widgets/common_snackbar.dart';
import '../../../../../../core/common/widgets/reel_item/reel_item.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../../../../../social_action/presentation/common_comment_sheet.dart';
import '../dashboard_bloc/leader_dashboard_bloc.dart';

class ShowAllReels extends StatefulWidget {
  final int initialIndex;
  final bool isSelf;

  const ShowAllReels({super.key, required this.initialIndex, required this.isSelf});

  @override
  State<ShowAllReels> createState() => _ShowAllReelsState();
}

class _ShowAllReelsState extends State<ShowAllReels> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose(); // Memory leak se bachne ke liye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaderDashboardBloc, LeaderDashboardState>(
      listener: (context, state) {
        if (state.status == LeaderDashboardStatus.failure) {
          showSnackBar(context: context, message: state.errorMessage);
        }
        if (state.status == LeaderDashboardStatus.leaderActionSuccess) {
          showSnackBar(context: context, message: state.successActionMessage, color: AppColors.green, icon: Icons.done_all);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<LeaderDashboardBloc, LeaderDashboardState>(
          builder: (context, state) {
            final currentReels = state.reels;
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: currentReels.length + (state.hasMoreReels ? 1 : 0),
              onPageChanged: (index) {
                _currentIndexNotifier.value = index;
                if (index >= currentReels.length - 1 && state.hasMoreReels && !state.isFetchingMore) {
                  context.read<LeaderDashboardBloc>().add(
                    FetchMoreLeaderPosts(
                      leaderId: state.leader!.id,
                      type: 'reel',
                    ),
                  );
                }
              },
              itemBuilder: (context, index) {
                if (index == currentReels.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final reel = currentReels[index];
                return ValueListenableBuilder<int>(
                  valueListenable: _currentIndexNotifier,
                  builder: (context, activeIndex, child) {
                    return ReelItem(
                      key: ValueKey(reel.id),
                      reel: reel,
                      isSelf: widget.isSelf,
                      isActive: activeIndex == index,
                      onLikeTap: () => context.read<LeaderDashboardBloc>().add(ToggleLikeEvent(postId: reel.id)),
                      onCommentTap: () => showCommentSheet(originalContext: context, postId: reel.id),
                      onSaveTap: () => context.read<LeaderDashboardBloc>().add(ToggleSavePostEvent(postId: reel.id)),
                      onShareTap: () => showSnackBar(context: context, message: "Feature is coming soon..", color: AppColors.yellow, icon: Icons.info_outline),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

