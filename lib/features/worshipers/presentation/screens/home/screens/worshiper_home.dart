import 'package:faith_connect/core/common/widgets/common_snackbar.dart';
import 'package:faith_connect/core/common/widgets/custom_text.dart';
import 'package:faith_connect/core/routes/route_names.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:faith_connect/features/social_action/presentation/common_comment_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/common/widgets/common_empty_state.dart';
import '../home_bloc/home_bloc.dart';
import '../../../../../../core/common/widgets/post_card/post_card.dart';
import '../../../../../../core/common/widgets/post_card/post_loading_shimmer.dart';

class WorshiperHome extends StatefulWidget {
  const WorshiperHome({super.key});

  @override
  State<WorshiperHome> createState() => _WorshiperHomeState();
}

class _WorshiperHomeState extends State<WorshiperHome>{
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.status == HomeStatus.homeError && state.errorActionMessage.isNotEmpty) {
          showSnackBar(context: context, message: state.errorActionMessage);
          debugPrint("Home error: ${state.errorActionMessage}");
        }
        if (state.status == HomeStatus.homeActionSuccess && state.successActionMessage.isNotEmpty) {
          showSnackBar(context: context, message: state.successActionMessage, color: AppColors.green, icon: Icons.done_all);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.h), // Height kam kar di
            child: AppBar(
              elevation: 0.5,
              centerTitle: false,
              backgroundColor: Colors.white,
              title: CustomText(text: "FaithConnect", textColor: AppColors.black, fontSize: 20.sp, fontWeight: FontWeight.w900, textAlign: TextAlign.start),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.black),
                  onPressed: () => context.pushNamed(RouteNames.worshiperNotificationsName),
                ),
              ],
              bottom: TabBar(
                indicatorWeight: 3,
                labelColor: AppColors.black,
                indicatorColor: AppColors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp),
                tabs: [
                  Tab(
                    child: Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.explore, color: AppColors.black, size: 20.sp),
                        CustomText(text: "Explore", textColor: AppColors.black),
                      ],
                    ),
                  ),

                  Tab(
                    child: Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.post_add, color: AppColors.black, size: 20.sp),
                        CustomText(text: "Following", textColor: AppColors.black),
                      ],
                    ),
                  ),
                ],
                onTap: (index) {
                  if (index == 0) {
                    context.read<HomeBloc>().add(FetchExplorePosts());
                  } else {
                    context.read<HomeBloc>().add(FetchFollowingPosts());
                  }
                },
              ),
            ),
          ),
          // TabBarView se Swipe functionality aati hai
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPostList(context, isExplore: true),
              _buildPostList(context, isExplore: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context, {required bool isExplore}) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) {
        return previous.posts != current.posts ||
            current.status == HomeStatus.homeLoaded ||
            current.status == HomeStatus.homeLoading;
      },
      builder: (context, state) {
        if (state.status == HomeStatus.homeLoading && state.posts.isEmpty) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => PostLoadingShimmer(),
          );
        }

        if (state.posts.isEmpty) {
          return buildEmptyState(
            context: context,
            onRefresh: () async => context.read<HomeBloc>().add(
              isExplore ? FetchExplorePosts() : FetchFollowingPosts(),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.black,
          backgroundColor: AppColors.white,
          onRefresh: () async {
            context.read<HomeBloc>().add(isExplore ? FetchExplorePosts() : FetchFollowingPosts());
            await context.read<HomeBloc>().stream.firstWhere((state) => state.status == HomeStatus.homeLoaded || state.status == HomeStatus.homeError
            );
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // Check: Kya user niche pahunch gaya hai?
              if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                // Check: Kya pehle se fetching ho rahi hai? Ya aur data bacha hai?
                if (!state.isFetchingMore && state.hasMoreData) {
                  context.read<HomeBloc>().add(FetchMoreHomePosts(isExplore: isExplore));
                }
              }
              return false;
            },
            child: ListView.separated(
              itemCount: state.posts.length + (state.hasMoreData ? 1 : 0),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                // Agar last item hai aur data aur bacha hai toh loader dikhao
                if (index == state.posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final post = state.posts[index];
                return PostCard(
                  key: ValueKey(post.id),
                  post: post,
                  isSelf: false,
                  onLikeTap: () => context.read<HomeBloc>().add(ToggleLikeEvent(postId: post.id)),
                  onCommentTap: () => showCommentSheet(originalContext: context, postId: post.id),
                  onSaveTap: () => context.read<HomeBloc>().add(ToggleSavePostEvent(postId: post.id)),
                  onShareTap: () => showSnackBar(context: context, message: "Feature is coming soon..", color: AppColors.yellow),
                );
              },
            ),
          ),
        );
      },
    );
  }
}