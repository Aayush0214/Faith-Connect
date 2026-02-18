import 'dart:async';

import 'package:faith_connect/core/common/widgets/common_snackbar.dart';
import 'package:faith_connect/core/common/widgets/common_text_form_field.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/leaders/leader_bloc/leader_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/leaders/widgets/leader_loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/widgets/common_empty_state.dart';
import '../../../../../../core/common/widgets/custom_text.dart';
import '../../../../../../core/theme/app_colors/app_colors.dart';
import '../widgets/leader_card.dart';


class LeadersPage extends StatefulWidget {
  const LeadersPage({super.key});

  @override
  State<LeadersPage> createState() => _LeadersPageState();
}

class _LeadersPageState extends State<LeadersPage> with SingleTickerProviderStateMixin{
  Timer? _debounce;
  late TabController _tabController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<LeaderBloc>().add(SearchQueryChanged(
        query: query,
        isExplore: _tabController.index == 0,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaderBloc, LeaderState>(
      listener: (context, state) {
        if(state.status == LeaderStatus.failure && state.errorMessage.isNotEmpty) {
          showSnackBar(context: context, message: state.errorMessage);
          debugPrint("error: ${state.errorMessage}");
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0, // Clean look
            centerTitle: false,
            backgroundColor: Colors.white,
            title: CustomText(
              text: "Religious Leaders",
              textColor: AppColors.black,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(85.h),
              child: Column(
                children: [
                  // 1. Search Bar Implementation
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
                    child: CommonTextFormField(
                      isSuffix: true,
                      prefixIcon: Icons.search,
                      hintText: "Search leaders",
                      controller: _searchController,
                      suffixIcon: Icons.clear,
                      onSuffixClick: () {
                        _searchController.clear();
                        _onSearchChanged("");
                      },
                      onValueChanged: _onSearchChanged,
                    ),
                  ),

                  // 2. TabBar
                  TabBar(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add, size: 18.sp),
                            SizedBox(width: 8.w),
                            const Text("Explore"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 18.sp),
                            SizedBox(width: 8.w),
                            const Text("My Leaders"),
                          ],
                        ),
                      ),
                    ],
                    onTap: (index) {
                      _searchController.clear();
                      context.read<LeaderBloc>().add(SearchQueryChanged(query: '', isExplore: index == 0));
                      context.read<LeaderBloc>().add(FetchLeadersEvent(isExplore: index == 0));
                    },
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _leaderList(context: context, isExplore: true),
              _leaderList(context: context, isExplore: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leaderList({required BuildContext context, required bool isExplore}) {
    return BlocBuilder<LeaderBloc, LeaderState>(
      builder: (context, state) {
        if (state.status == LeaderStatus.loading) {
          return ListView.builder(
            itemCount: 8,
            padding: EdgeInsets.only(top: 10.h, bottom: 20.h, left: 5.w, right: 5.w),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return LeaderLoadingShimmer();
            },
          );
        }
        final leaders = isExplore ? state.exploreLeaders : state.myLeaders;

        if (leaders.isEmpty) {
          return buildEmptyState(
            context: context,
            onRefresh: () async{
              _searchController.clear();
              context.read<LeaderBloc>().add(SearchQueryChanged(query: '', isExplore: isExplore));
              context.read<LeaderBloc>().add(FetchLeadersEvent(isExplore: isExplore));
              await context.read<LeaderBloc>().stream.firstWhere((state) => state.status == LeaderStatus.loaded || state.status == LeaderStatus.failure);
            },
          );
        }

        return RefreshIndicator(
          color: AppColors.black,
          backgroundColor: AppColors.white,
          onRefresh: () async {
            _searchController.clear();
            context.read<LeaderBloc>().add(SearchQueryChanged(query: '', isExplore: isExplore));
            context.read<LeaderBloc>().add(FetchLeadersEvent(isExplore: isExplore));
            await context.read<LeaderBloc>().stream.firstWhere((state) => state.status == LeaderStatus.loaded || state.status == LeaderStatus.failure);
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              final hasMore = isExplore ? state.hasMoreExplore : state.hasMoreMyLeaders; // Tab ke hisab se check karo
              if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                if (!state.isFetchingMore && hasMore) {
                  context.read<LeaderBloc>().add(FetchMoreLeaders(isExplore: isExplore));
                }
              }
              return false;
            },
            child: ListView.builder(
              itemCount: leaders.length + (state.hasMoreExplore ? 1 : 0),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h, left: 5.w, right: 5.w),
              itemBuilder: (context, index) {
                final leader = leaders[index];
                return LeaderCard(
                  leader: leader,
                  isExplore: isExplore,
                );
              },
            ),
          ),
        );
      },
    );
  }
}