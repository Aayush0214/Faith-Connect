import 'package:faith_connect/features/leaders/presentation/screens/messages/widgets/leader_chat_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/leaders/presentation/screens/dashboard/dashboard_bloc/leader_dashboard_bloc.dart';
import '../../features/leaders/presentation/screens/dashboard/widgets/leader_followers_page.dart';
import '../../injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common/entities/chat_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faith_connect/core/routes/route_guard.dart';
import 'package:faith_connect/core/routes/route_names.dart';
import 'package:faith_connect/core/routes/route_transitions.dart';
import 'package:faith_connect/core/routes/router_refresh_stream.dart';
import '../../features/leaders/presentation/leader_main_wrapper.dart';
import '../../features/splash_screen/presentation/splash_screen.dart';
import '../../features/worshipers/presentation/worshiper_main_wrapper.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/worshipers/presentation/screens/chats/widgets/worshiper_chat_page.dart';
import '../../features/worshipers/presentation/screens/reels/screens/reels_screen.dart';
import '../../features/leaders/presentation/screens/profile/screens/leader_profile.dart';
import '../../features/worshipers/presentation/screens/home/screens/worshiper_home.dart';
import '../../features/worshipers/presentation/screens/leaders/screens/leaders_page.dart';
import '../../features/leaders/presentation/screens/dashboard/widgets/show_all_reels.dart';
import '../../features/leaders/presentation/screens/dashboard/widgets/show_all_posts.dart';
import '../../features/leaders/presentation/screens/messages/screens/leader_chat_inbox.dart';
import '../../features/leaders/presentation/screens/dashboard/screens/leader_dashboard.dart';
import '../../features/worshipers/presentation/screens/profile/screens/worshiper_profile.dart';
import '../../features/leaders/presentation/screens/create_content/screens/create_content.dart';
import '../../features/authentication/presentation/screens/login/presentation/login_screen.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/home/home_bloc/home_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/chats/chat_bloc/chat_bloc.dart';
import '../../features/worshipers/presentation/screens/notifications/screens/notification_screen.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/reels/reels_bloc/reels_bloc.dart';
import '../../features/leaders/presentation/screens/profile/leader_profile_bloc/leader_profile_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/chats/screens/worshiper_chat_inbox.dart';
import 'package:faith_connect/features/authentication/presentation/screens/login/login_bloc/login_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/leaders/leader_bloc/leader_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:faith_connect/features/authentication/presentation/screens/signup/signup_bloc/signup_bloc.dart';
import 'package:faith_connect/features/authentication/presentation/screens/signup/presentation/signup_screen.dart';
import 'package:faith_connect/features/leaders/presentation/screens/messages/leader_chat_bloc/leader_chat_bloc.dart';
import 'package:faith_connect/features/leaders/presentation/screens/create_content/create_content_bloc/create_content_bloc.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    redirect: RouteGuards.globalRedirect,
    refreshListenable: sl<RouterNotifier>(),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        pageBuilder: (context, state) => RouteTransitions.fade(const SplashScreen()),
      ),

      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboardingName,
        builder: (context, state) => const OnBoardingScreen(),
      ),

      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        pageBuilder: (context, state) => RouteTransitions.fade(
          BlocProvider(
            create: (context) => sl<LoginBloc>(),
            child: const LoginScreen(),
          ),
        ),
      ),

      GoRoute(
        path: RouteNames.signup,
        name: RouteNames.signupName,
        pageBuilder: (context, state) => RouteTransitions.slideRightToLeft(
          BlocProvider(
            create: (context) => sl<SignupBloc>(),
            child: const SignupScreen(),
          ),
        ),
      ),

      GoRoute(
        path: RouteNames.worshiperNotifications,
        name: RouteNames.worshiperNotificationsName,
        builder: (context, state) => const NotificationScreen(),
      ),

      // WORSHIPER FLOW (Shell Route with Bottom Nav)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return WorshiperMainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.worshiperHome,
                name: RouteNames.worshiperHomeName,
                pageBuilder: (context, state) => RouteTransitions.noTransition(
                    BlocProvider(
                      create: (context) => sl<HomeBloc>()..add(FetchExplorePosts()),
                      child: const WorshiperHome(),
                    )
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.worshiperLeaderList,
                name: RouteNames.worshiperLeaderListName,
                pageBuilder: (context, state) => RouteTransitions.noTransition(
                    BlocProvider(
                      create: (context) => sl<LeaderBloc>()..add(FetchLeadersEvent(isExplore: true)),
                      child: const LeadersPage(),
                    )
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.worshiperReels,
                name: RouteNames.worshiperReelsName,
                pageBuilder: (context, state) => RouteTransitions.noTransition(
                    BlocProvider(
                      create: (context) => sl<ReelsBloc>()..add(FetchReelsEvent()),
                      child: const ReelsScreen(),
                    )
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => BlocProvider(
                  create: (context) => sl<ChatBloc>()..add(WatchInboxEvent()),
                  child: child,
                ),
                routes: [
                  GoRoute(
                    path: RouteNames.worshiperChatsInbox,
                    name: RouteNames.worshiperChatsInboxName,
                    pageBuilder: (context, state) => RouteTransitions.noTransition(const WorshiperChatInbox()),
                  ),
                  GoRoute(
                    path: RouteNames.mainChatScreen,
                    name: RouteNames.mainChatScreenName,
                    pageBuilder: (context, state) {
                      final chat = state.extra as ChatEntity;
                      return RouteTransitions.noTransition(WorshiperChatPage(chat: chat));
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.worshiperProfile,
                name: RouteNames.worshiperProfileNames,
                pageBuilder: (context, state) => RouteTransitions.noTransition(
                  BlocProvider(
                    create: (context) => sl<ProfileBloc>()..add(FetchWorshiperStatus()),
                    child: const WorshiperProfile(),
                  )
                ),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
          path: RouteNames.leaderProfile,
          name: RouteNames.leaderProfileName,
          pageBuilder: (context, state) {
            final data = state.extra as Map<String, dynamic>?;
            final String lId = data?['leaderId'] ?? "";
            final bool isSelf = data?['isSelf'] ?? false;

            debugPrint("Log: Standalone Route Leader ID: $lId");
            return RouteTransitions.noTransition(
              LeaderDashboard(leaderId: lId, isSelf: isSelf),
            );
          },
          routes: [
            GoRoute(
              path: RouteNames.showAllPosts,
              name: RouteNames.showAllPostsNames,
              builder: (context, state) {
                final Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
                final leaderBloc = extraData['bloc'] as LeaderDashboardBloc;
                final int initialIndex = extraData['initialIndex'] ?? 0;
                final bool isSelf = extraData['isSelf'] ?? false;

                return BlocProvider.value(
                  value: leaderBloc,
                  child: ShowAllPosts(
                    initialIndex: initialIndex,
                    isSelf: isSelf,
                  ),
                );
              },
            ),
            GoRoute(
              path: RouteNames.showAllReels,
              name: RouteNames.showAllReelsNames,
              builder: (context, state) {
                final Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
                final leaderBloc = extraData['bloc'] as LeaderDashboardBloc;
                final int initialIndex = extraData['initialIndex'] ?? 0;
                final bool isSelf = extraData['isSelf'] ?? false;
                return BlocProvider.value(
                  value: leaderBloc,
                  child: ShowAllReels(
                    initialIndex: initialIndex,
                    isSelf: isSelf,
                  ),
                );
              },
            ),
            GoRoute(
              path: RouteNames.leaderFollowers,
              name: RouteNames.leaderFollowersNames,
              builder: (context, state) {
                final Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
                final leaderBloc = extraData['bloc'] as LeaderDashboardBloc;

                return BlocProvider.value(
                  value: leaderBloc,
                  child: const LeaderFollowersPage(),
                );
              },
            ),
          ]
      ),

      // LEADER FLOW (Shell Route with Bottom Nav)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LeaderMainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.leaderDashboard,
                name: RouteNames.leaderDashboardName,
                pageBuilder: (context, state) {
                  final currentLeaderId = sl<SupabaseClient>().auth.currentUser?.id ?? '';
                  debugPrint("🔥 DASHBOARD ROUTE TRIGGERED: $currentLeaderId");
                  return RouteTransitions.noTransition(
                    LeaderDashboard(leaderId: currentLeaderId, isSelf: true),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.createContent,
                name: RouteNames.createContentName,
                pageBuilder: (context, state) => RouteTransitions.noTransition(
                    BlocProvider(
                      create: (context) => sl<CreateContentBloc>(),
                      child: const CreateContentPage(),
                    )
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                  builder: (context, state, child) => BlocProvider(
                    create: (context) => sl<LeaderChatBloc>()..add(WatchLeaderInboxEvent()),
                    child: child,
                  ),
                  routes: [
                    GoRoute(
                      path: RouteNames.leaderChatInbox,
                      name: RouteNames.leaderChatInboxName,
                      pageBuilder: (context, state) => RouteTransitions.noTransition(const LeaderInboxPage()),
                    ),
                    GoRoute(
                      path: RouteNames.leaderMainChatScreen,
                      name: RouteNames.leaderMainChatScreenName,
                      pageBuilder: (context, state){
                        final chat = state.extra as ChatEntity;
                        return RouteTransitions.noTransition(LeaderChatDetailPage(chat: chat));
                      }
                    ),
                  ]
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.leaderSettings,
                name: RouteNames.leaderSettingsName,
                pageBuilder: (context, state) => RouteTransitions.noTransition(
                    BlocProvider(
                      create: (context) => sl<LeaderProfileBloc>(),
                      child: const LeaderProfile(),
                    )
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
