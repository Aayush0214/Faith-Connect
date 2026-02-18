import 'package:faith_connect/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../dashboard_bloc/leader_dashboard_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import 'package:faith_connect/core/common/widgets/app_image.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:faith_connect/core/common/entities/post_entity.dart';
import '../../../../../worshipers/domain/entities/leader_entity.dart';
import 'package:faith_connect/core/common/widgets/app_network_image.dart';

class LeaderDashboard extends StatelessWidget {
  final String leaderId;
  final bool isSelf;

  const LeaderDashboard({super.key, required this.leaderId, this.isSelf = false});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return BlocProvider(
      key: ValueKey(leaderId),
      create: (context) => sl<LeaderDashboardBloc>()..add(FetchLeaderDashboardData(leaderId: leaderId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: CustomText(text: "Leader Dashboard", textColor: AppColors.black, textAlign: TextAlign.left),
        ),
        body: BlocBuilder<LeaderDashboardBloc, LeaderDashboardState>(
          builder: (context, state) {
            if (state.status == LeaderDashboardStatus.loading && state.leader == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.leader == null) return const Center(child: Text("Leader not found"));

            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: SafeArea(
                        bottom: false,
                        child: ProfileHeaderWidget(
                            leader: state.leader!,
                            isSelf: isSelf
                        ),
                      ),
                    ),
                    // 2. Sticky TabBar
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          labelColor: AppColors.black,
                          indicatorColor: AppColors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: const [
                            Tab(icon: Icon(Icons.grid_on)),
                            Tab(icon: Icon(Icons.movie_outlined)),
                          ],
                        ),
                        topPadding: topPadding, // Pass top padding
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // Posts Tab
                    PostGridView(leaderId: leaderId, type: 'post', posts: state.posts, isSelf: isSelf),
                    // Reels Tab
                    PostGridView(leaderId: leaderId, type: 'reel', posts: state.reels,isSelf: isSelf),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProfileHeaderWidget extends StatelessWidget {
  final LeaderEntity leader;
  final bool isSelf;

  const ProfileHeaderWidget({super.key, required this.leader, required this.isSelf});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppNetworkImage(
                url: leader.photoUrl!,
                width: 60.h,
                height: 60.h,
                showBorder: true,
                borderColor: AppColors.black,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(value: leader.postsCount.toString(), label: "Posts"),
                    _buildStatColumn(value: leader.followersCount.toString(), label: "Followers", onTap: (){
                      // 1. Pehle event fire karo
                      context.read<LeaderDashboardBloc>().add(FetchLeaderFollowers(leaderId: leader.id));

                      // 2. Fir navigate karo
                      context.pushNamed(
                      RouteNames.leaderFollowersNames,
                      extra: {'bloc': context.read<LeaderDashboardBloc>()},
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(text: leader.name, fontSize: 18.sp, fontWeight: FontWeight.bold, textColor: AppColors.black,),
          if (leader.bio != null) Text(leader.bio!),
          CustomText(text: leader.faith, fontSize: 12.sp, fontWeight: FontWeight.bold, textColor: AppColors.skyBlue,),
          SizedBox(height: 10.h),
          // Action Buttons
          Row(
            spacing: 10.w,
            children: [
              if (!isSelf) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<LeaderDashboardBloc>().add(FollowUnfollowLeaderEvent(leaderId: leader.id));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      overlayColor: AppColors.textDisabledDark,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      foregroundColor: leader.isFollowing ? AppColors.black : AppColors.white,
                      backgroundColor: leader.isFollowing ? AppColors.white : AppColors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: leader.isFollowing ? AppColors.black : AppColors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(leader.isFollowing ? "Following" : "Follow"),
                  ),
                ),
                if (leader.isFollowing)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                        foregroundColor: AppColors.white,
                        backgroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text("Message"),
                    ),
                  ),
              ] else ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: AppColors.white,
                      backgroundColor: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      )
                    ),
                    child: const Text("Edit Profile"),
                  ),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatColumn({required String value, required String label, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CustomText(text: value, textColor: AppColors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
          CustomText(text: label, textColor: AppColors.textHintLight, fontSize: 14.sp, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}

class PostGridView extends StatelessWidget {
  final String leaderId;
  final String type;
  final bool isSelf;
  final List<PostEntity> posts;

  const PostGridView({super.key, required this.leaderId, required this.isSelf, required this.type, required this.posts});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderDashboardBloc, LeaderDashboardState>(
      builder: (context, state) {
        final hasMore = type == 'post' ? state.hasMorePosts : state.hasMoreReels;
        return RefreshIndicator(
          color: AppColors.black,
          backgroundColor: AppColors.white,
          onRefresh: () async {
            context.read<LeaderDashboardBloc>().add(FetchLeaderDashboardData(leaderId: leaderId));
            await context.read<LeaderDashboardBloc>().stream.firstWhere((state) => state.status == LeaderDashboardStatus.loaded || state.status == LeaderDashboardStatus.failure);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 200) {
                if (!state.isFetchingMore && hasMore) {
                  context.read<LeaderDashboardBloc>().add(FetchMoreLeaderPosts(leaderId: leaderId, type: type));
                }
              }
              return false;
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: type == "post" ? 3 : 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1,
              ),
              itemCount: hasMore ? posts.length + 1 : posts.length,
              itemBuilder: (context, index) {
                if (index >= posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black,),
                    ),
                  );
                }
                final post = posts[index];
                return GestureDetector(
                  onTap: () {
                    if (type == 'reel') {
                      context.pushNamed(
                        RouteNames.showAllReelsNames,
                        extra: {
                          'initialIndex': index,
                          'isSelf': isSelf,
                          'bloc': context.read<LeaderDashboardBloc>(),
                        },
                      );
                    } else {
                      context.pushNamed(
                        RouteNames.showAllPostsNames,
                        extra: {
                          'initialIndex': index,
                          'isSelf': isSelf,
                          'bloc': context.read<LeaderDashboardBloc>(),
                        },
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.black, width: 1.0),
                    ),
                    child: AppImage(
                      fit: BoxFit.cover,
                      path: post.postType == 'reel' ? post.thumbnailUrl! : post.mediaUrl!,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._child, {required this.topPadding});

  final Widget _child;
  final double topPadding; // Status bar ki height

  // 48.0 (TabBar height) + topPadding
  @override
  double get minExtent => 60.0 ;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Taki content niche se na dikhe
      child: Column(
        children: [
          SizedBox(height: 48.0, child: _child),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate.topPadding != topPadding;
  }
}