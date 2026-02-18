import 'package:faith_connect/features/leaders/presentation/screens/dashboard/dashboard_bloc/leader_dashboard_bloc.dart';
import 'package:faith_connect/features/social_action/presentation/common_comment_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/common/widgets/common_snackbar.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/common/widgets/post_card/post_card.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';

class ShowAllPosts extends StatefulWidget {
  final int initialIndex;
  final bool isSelf;

  const ShowAllPosts({super.key, required this.initialIndex, required this.isSelf});

  @override
  State<ShowAllPosts> createState() => _ShowAllPostsState();
}

class _ShowAllPostsState extends State<ShowAllPosts> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Scroll to the clicked post index after the UI builds
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex > 0) {
        _scrollController.jumpTo(widget.initialIndex * 500.h);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          showSnackBar(context: context,
              message: state.successActionMessage,
              color: AppColors.green,
              icon: Icons.done_all);
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: CustomText(text: "Posts", fontWeight: FontWeight.bold, textColor: AppColors.black),
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocBuilder<LeaderDashboardBloc, LeaderDashboardState>(
            builder: (context, state) {
              final currentPosts = state.posts;
              return ListView.separated(
                controller: _scrollController,
                itemCount: currentPosts.length + (state.hasMorePosts ? 1 : 0),
                padding: EdgeInsets.only(bottom: 50.h),
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  if (index == currentPosts.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (index >= currentPosts.length - 1 && state.hasMorePosts && !state.isFetchingMore) {
                    context.read<LeaderDashboardBloc>().add(
                      FetchMoreLeaderPosts(
                        leaderId: state.leader!.id, // state se lo, widget se nahi
                        type: 'post',
                      ),
                    );
                  }
                  final post = currentPosts[index];
                  return PostCard(
                    key: ValueKey(post.id),
                    post: post,
                    isSelf: widget.isSelf,
                    onLikeTap: () => context.read<LeaderDashboardBloc>().add(ToggleLikeEvent(postId: post.id)),
                    onCommentTap: () => showCommentSheet(originalContext: context, postId: post.id),
                    onSaveTap: () => context.read<LeaderDashboardBloc>().add(ToggleSavePostEvent(postId: post.id)),
                    onShareTap: () => showSnackBar(context: context, message: "Feature is coming soon..", color: AppColors.yellow, icon: Icons.info_outline),
                  );
                },
              );
            },
          ),
        ),
    );
  }
}