import 'package:faith_connect/core/services/notification_service/notification_service.dart';
import 'package:faith_connect/features/authentication/data/auth_repository_impl/auth_repository_impl.dart';
import 'package:faith_connect/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:faith_connect/features/authentication/domain/auth_repository/auth_repository.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/login_usecase.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/logout_usecase.dart';
import 'package:faith_connect/features/authentication/domain/use_cases/signup_usecase.dart';
import 'package:faith_connect/features/authentication/presentation/screens/login/login_bloc/login_bloc.dart';
import 'package:faith_connect/features/authentication/presentation/screens/signup/signup_bloc/signup_bloc.dart';
import 'package:faith_connect/features/leaders/data/datasources/create_content_datasource.dart';
import 'package:faith_connect/features/leaders/data/datasources/dashboard_remote_datasource.dart';
import 'package:faith_connect/features/leaders/data/datasources/leader_chat_remote_datasource.dart';
import 'package:faith_connect/features/leaders/data/repositories_impl/create_content_repository_impl.dart';
import 'package:faith_connect/features/leaders/data/repositories_impl/dashboard_repository_impl.dart';
import 'package:faith_connect/features/leaders/data/repositories_impl/leader_chat_repository_impl.dart';
import 'package:faith_connect/features/leaders/domain/repositories/create_content_repository.dart';
import 'package:faith_connect/features/leaders/domain/repositories/dashboard_repository.dart';
import 'package:faith_connect/features/leaders/domain/repositories/leader_chat_repository.dart';
import 'package:faith_connect/features/leaders/domain/usecases/create_content_usecases/create_content_usecase.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/delete_leader_posts.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/get_leader_followers.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/get_leader_posts.dart';
import 'package:faith_connect/features/leaders/domain/usecases/dashboard_usecases/get_leader_details.dart';
import 'package:faith_connect/features/leaders/domain/usecases/leader_chat_usecases/mark_leader_message_as_read.dart';
import 'package:faith_connect/features/leaders/domain/usecases/leader_chat_usecases/send_leader_message_usecase.dart';
import 'package:faith_connect/features/leaders/domain/usecases/leader_chat_usecases/watch_leader_inbox_usecase.dart';
import 'package:faith_connect/features/leaders/domain/usecases/leader_chat_usecases/watch_leader_messages_usecase.dart';
import 'package:faith_connect/features/leaders/presentation/screens/create_content/create_content_bloc/create_content_bloc.dart';
import 'package:faith_connect/features/leaders/presentation/screens/dashboard/dashboard_bloc/leader_dashboard_bloc.dart';
import 'package:faith_connect/features/leaders/presentation/screens/messages/leader_chat_bloc/leader_chat_bloc.dart';
import 'package:faith_connect/features/social_action/data/remote_datasource/social_action_remote_datasource.dart';
import 'package:faith_connect/features/social_action/data/repository_impl/social_repository_impl.dart';
import 'package:faith_connect/features/social_action/domain/repository/social_repository.dart';
import 'package:faith_connect/features/social_action/domain/usecases/add_comment_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/get_comments_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/get_social_update_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/like_unlike_usecase.dart';
import 'package:faith_connect/features/social_action/domain/usecases/save_unsave_usecase.dart';
import 'package:faith_connect/features/social_action/presentation/bloc/social_action_bloc.dart';
import 'package:faith_connect/features/worshipers/data/datasources/chat_remote_datasource.dart';
import 'package:faith_connect/features/worshipers/data/datasources/home_remote_datasource.dart';
import 'package:faith_connect/features/worshipers/data/datasources/leader_remote_datasource.dart';
import 'package:faith_connect/features/worshipers/data/datasources/profile_remote_datasource.dart';
import 'package:faith_connect/features/worshipers/data/datasources/reels_remote_datasource.dart';
import 'package:faith_connect/features/worshipers/data/repositories_impl/chat_repository_impl.dart';
import 'package:faith_connect/features/worshipers/data/repositories_impl/home_repository_impl.dart';
import 'package:faith_connect/features/worshipers/data/repositories_impl/leader_repository_impl.dart';
import 'package:faith_connect/features/worshipers/data/repositories_impl/profile_repository_impl.dart';
import 'package:faith_connect/features/worshipers/data/repositories_impl/reels_repository_impl.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/chat_repository.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/home_repository.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/leader_repository.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/profile_repository.dart';
import 'package:faith_connect/features/worshipers/domain/repositories/reels_repository.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/chat_usecase/get_inbox_usecase.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/chat_usecase/get_or_create_chat.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/chat_usecase/send_message_usecase.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/chat_usecase/watch_chat_inbox.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/home_usecases/get_home_following_posts.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/profile_usecases/get_worshiper_stats.dart';
import 'package:faith_connect/features/worshipers/domain/use_cases/reel_usecase/reel_usecase.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/chats/chat_bloc/chat_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/home/home_bloc/home_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/leaders/leader_bloc/leader_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/profile/profile_bloc/profile_bloc.dart';
import 'package:faith_connect/features/worshipers/presentation/screens/reels/reels_bloc/reels_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routes/router_refresh_stream.dart';
import 'core/services/media_service/media_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/connection_checker/connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/leaders/presentation/screens/profile/leader_profile_bloc/leader_profile_bloc.dart';
import 'features/onboarding/domain/repository/onboarding_repository.dart';
import 'features/onboarding/data/datasource/onboarding_local_datasource.dart';
import 'features/onboarding/data/repository_impl/onboarding_repository_impl.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/get_selected_role.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/set_selected_role.dart';
import 'core/services/local_storage_service/data/repository_impl/local_storage_impl.dart';
import 'core/services/local_storage_service/domain/repository/local_storage_service.dart';
import 'package:faith_connect/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/get_onboarding_status.dart';
import 'package:faith_connect/features/onboarding/domain/usecase/set_onboarding_status.dart';

import 'features/social_action/domain/usecases/delete_comment_usecase.dart';
import 'features/worshipers/domain/use_cases/chat_usecase/get_message_stream.dart';
import 'features/worshipers/domain/use_cases/chat_usecase/mark_messages_as_read.dart';
import 'features/worshipers/domain/use_cases/home_usecases/get_home_explore_posts.dart';
import 'features/worshipers/domain/use_cases/leader_usecases/fetch_explore_leaders.dart';
import 'features/worshipers/domain/use_cases/leader_usecases/fetch_followed_leaders.dart';
import 'features/worshipers/domain/use_cases/leader_usecases/toggle_follow_leader.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final secureStorage = FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();
  final supabase = Supabase.instance.client;
  final firebaseMessaging = FirebaseMessaging.instance;

  sl.registerLazySingleton<SupabaseClient>(() => supabase);
  sl.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
  sl.registerLazySingleton(() => NotificationService(supabase: sl(), firebaseMessaging: sl()));

  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageServiceImpl(secureStorage: secureStorage, sharedPreferences: sharedPreferences));
  sl.registerLazySingleton<MediaService>(() => MediaService());
  sl.registerFactory(() => InternetConnection());
  sl.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(internetConnection: sl()));

  _onBoardingRegistration();
  _authRegistration();
  _routerNotifier();

  /// Worshiper registration
  _worshiperHomeRegistration();
  _worshiperLeaderRegistration();
  _worshiperReelRegistration();
  _worshiperChatRegistration();
  _worshiperProfileRegistration();

  /// Social Action Registration
  _socialActionRegistration();

  /// Leader registration
  _leaderDashboardRegistration();
  _createContentRegistration();
  _leaderChatRegistration();
  _leaderProfileRegistration();
}

void _onBoardingRegistration() {
  sl..registerFactory<OnboardingLocalDataSource>(() => OnboardingLocalDataSourceImpl(localStorageService: sl()))
    ..registerFactory<OnboardingRepository>(() => OnboardingRepositoryImpl(dataSource: sl()))
    ..registerFactory<SetOnboardingStatusUseCase>(() => SetOnboardingStatusUseCase(repository: sl()))
    ..registerFactory<GetOnboardingStatusUseCase>(() => GetOnboardingStatusUseCase(repository: sl()))
    ..registerFactory<GetSelectedRoleUseCase>(() => GetSelectedRoleUseCase(onboardingRepository: sl()))
    ..registerFactory<SetSelectedRoleUseCase>(() => SetSelectedRoleUseCase(onboardingRepository: sl()))
    ..registerLazySingleton<OnBoardingBloc>(() => OnBoardingBloc(getOnBoardingStatusUseCase: sl(), setOnBoardingStatusUseCase: sl(), getSelectedRoleUseCase: sl(), setSelectedRoleUseCase: sl()));
}

void _authRegistration() {
  sl..registerFactory<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(supabaseClient: sl()))
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(authRemoteDatasource: sl()))
    ..registerFactory<LoginUseCase>(() => LoginUseCase(authRepository: sl()))
    ..registerFactory<SignupUseCase>(() => SignupUseCase(authRepository: sl()))
    ..registerFactory<LogoutUseCase>(() => LogoutUseCase(authRepository: sl()))
    ..registerLazySingleton<AuthBloc>(() => AuthBloc(supabaseInstance: sl(), logoutUsecase: sl()))
    ..registerFactory<SignupBloc>(() => SignupBloc(mediaService: sl(), signupUsecase: sl()))
    ..registerFactory<LoginBloc>(() => LoginBloc(loginUsecase: sl()));
}

void _routerNotifier() {
  sl.registerLazySingleton<RouterNotifier>(() => RouterNotifier(supabase: sl(), onboardingBloc: sl()));
}

/// ===================== Worshiper Section ========================= ///

void _worshiperHomeRegistration(){
  sl..registerFactory<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(supabase: sl()))
    ..registerFactory<HomeRepository>(() => HomeRepositoryImpl(homeRemoteDataSource: sl()))
    ..registerFactory<GetHomeExplorePostUsecase>(() => GetHomeExplorePostUsecase(homeRepository: sl()))
    ..registerFactory<GetHomeFollowingPostUsecase>(() => GetHomeFollowingPostUsecase(homeRepository: sl()))
    ..registerFactory<HomeBloc>(() => HomeBloc(
      getSocialUpdatesUseCase: sl(),
      followingPostUsecase: sl(),
      explorePostUsecase: sl(),
      saveUnsaveUseCase: sl(),
      likeUnlikeUseCase: sl(),
    ));
}

void _worshiperLeaderRegistration(){
  sl..registerFactory<LeaderRemoteDataSource>(() => LeaderRemoteDataSourceImpl(supabase: sl()))
    ..registerFactory<LeaderRepository>(() => LeaderRepositoryImpl(leaderRemoteDataSource: sl()))
    ..registerFactory<FetchExploreLeadersUsecase>(() => FetchExploreLeadersUsecase(leaderRepository: sl()))
    ..registerFactory<FetchFollowedLeadersUsecase>(() => FetchFollowedLeadersUsecase(leaderRepository: sl()))
    ..registerFactory<FollowUnfollowLeaderUsecase>(() => FollowUnfollowLeaderUsecase(leaderRepository: sl()))
    ..registerFactory<LeaderBloc>(() => LeaderBloc(fetchExploreLeaderUsecase: sl(), fetchFollowedLeadersUsecase: sl(), followLeaderUsecase: sl()));
}

void _worshiperReelRegistration(){
  sl..registerFactory<ReelsRemoteDataSource>(() => ReelsRemoteDataSourceImpl(supabase: sl()))
    ..registerFactory<ReelsRepository>(() => ReelsRepositoryImpl(reelsRemoteDataSource: sl()))
    ..registerFactory<GetReelsUsecase>(() => GetReelsUsecase(reelRepository: sl()))
    ..registerFactory<ReelsBloc>(() => ReelsBloc(
      getReelsUsecase: sl(),
      toggleLikeUsecase: sl(),
      toggleSavePostUsecase: sl(),
      getSocialUpdatesUseCase: sl(),
    ));
}

void _worshiperChatRegistration(){
  sl..registerFactory<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(supabase: sl()))
    ..registerFactory<ChatRepository>(() => ChatRepositoryImpl(chatRemoteDataSource: sl()))
    ..registerFactory<GetMessagesStreamUsecase>(() => GetMessagesStreamUsecase(chatRepository: sl()))
    ..registerFactory<GetInboxUsecase>(() => GetInboxUsecase(chatRepository: sl()))
    ..registerFactory<GetOrCreateChatUsecase>(() => GetOrCreateChatUsecase(chatRepository: sl()))
    ..registerFactory<MarkMessagesAsReadUsecase>(() => MarkMessagesAsReadUsecase(chatRepository: sl()))
    ..registerFactory<SendMessageUsecase>(() => SendMessageUsecase(chatRepository: sl()))
    ..registerFactory<WatchInboxUsecase>(() => WatchInboxUsecase(chatRepository: sl()))
    ..registerFactory<ChatBloc>(() => ChatBloc(fetchFollowedLeaders: sl(), getInbox: sl(), getMessagesStream: sl(), getOrCreateChat: sl(), markedAsReadUsecase: sl(), sendMessage: sl(), watchInboxUsecase: sl()));
}

void _worshiperProfileRegistration() {
  sl..registerFactory<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(supabase: sl()))
    ..registerFactory<ProfileRepository>(() => ProfileRepositoryImpl(profileRemoteDataSource: sl()))
    ..registerFactory<FetchWorshiperStatsUsecase>(() => FetchWorshiperStatsUsecase(profileRepository: sl()))
    ..registerFactory<ProfileBloc>(() => ProfileBloc(logoutUsecase: sl(), worshipStatUsecase: sl()));
}

/// ===================== Social Action ============================= ///

void _socialActionRegistration(){
  sl..registerLazySingleton<SocialActionRemoteDataSource>(() => SocialActionRemoteDataSourceImpl(supabaseClient: sl()))
    ..registerLazySingleton<SocialActionRepository>(() => SocialActionRepositoryImpl(socialActionDatasource: sl()))
    ..registerFactory<LikeUnlikeUseCase>(() => LikeUnlikeUseCase(socialRepository: sl()))
    ..registerFactory<SaveUnsaveUseCase>(() => SaveUnsaveUseCase(socialRepository: sl()))
    ..registerFactory<AddCommentUseCase>(() => AddCommentUseCase(socialRepository: sl()))
    ..registerFactory<GetCommentUseCase>(() => GetCommentUseCase(socialRepository: sl()))
    ..registerFactory<DeleteCommentUseCase>(() => DeleteCommentUseCase(socialRepository: sl()))
    ..registerLazySingleton<GetSocialUpdatesUseCase>(() => GetSocialUpdatesUseCase(socialRepository: sl()))
    ..registerFactory(() => SocialActionBloc(
      likeUnlikeUseCase: sl(),
      saveUnsaveUseCase: sl(),
      addCommentUseCase: sl(),
      getCommentUseCase: sl(),
      deleteCommentUseCase: sl(),
      getSocialUpdatesUseCase: sl(),
    ));
}

/// ===================== Leader Section ========================= ///

void _leaderDashboardRegistration(){
  sl..registerFactory<LeaderDashboardRemoteDatasource>(() => LeaderDashboardRemoteDatasourceImpl(supabase: sl()))
    ..registerFactory<LeaderDashboardRepository>(() => LeaderDashboardRepositoryImpl(dashboardDatasource: sl()))
    ..registerFactory<GetLeaderFollowersUsecase>(() => GetLeaderFollowersUsecase(dashboardRepository: sl()))
    ..registerFactory<GetLeaderPostsUsecase>(() => GetLeaderPostsUsecase(dashboardRepository: sl()))
    ..registerFactory<DeleteLeaderPostUsecase>(() => DeleteLeaderPostUsecase(dashboardRepository: sl()))
    ..registerFactory<GetLeaderProfileDataUsecase>(() => GetLeaderProfileDataUsecase(dashboardRepository: sl()))
    ..registerFactory<LeaderDashboardBloc>(() => LeaderDashboardBloc(
      getLeaderProfile: sl(),
      getPosts: sl(),
      followUnfollowLeaderUsecase: sl(),
      deleteLeaderPostUseCase: sl(),
      getLeaderFollowers: sl(),
      getSocialUpdatesUseCase: sl(),
      likeUnlikeUseCase: sl(),
      saveUnsaveUseCase: sl(),
    ));
}

void _createContentRegistration(){
  sl..registerFactory<CreateContentDatasource>(() => CreateContentDatasourceImpl(supabase: sl()))
    ..registerFactory<CreateContentRepository>(() => CreateContentRepositoryImpl(createContentDatasource: sl()))
    ..registerFactory<CreateContentUsecase>(() => CreateContentUsecase(createContentRepository: sl()))
    ..registerFactory<CreateContentBloc>(() => CreateContentBloc(mediaService: sl(), createContentUsecase: sl()));
}

void _leaderChatRegistration(){
  sl..registerFactory<LeaderChatRemoteDataSource>(() => LeaderChatRemoteDataSourceImpl(supabase: sl()))
    ..registerFactory<LeaderChatRepository>(() => LeaderChatRepositoryImpl(remoteDataSource: sl()))
    ..registerFactory<WatchLeaderInboxUseCase>(() => WatchLeaderInboxUseCase(chatRepository: sl()))
    ..registerFactory<WatchLeaderMessagesUseCase>(() => WatchLeaderMessagesUseCase(chatRepository: sl()))
    ..registerFactory<SendLeaderMessageUseCase>(() => SendLeaderMessageUseCase(chatRepository: sl()))
    ..registerFactory<MarkLeaderMessageAsReadUseCase>(() => MarkLeaderMessageAsReadUseCase(chatRepository: sl()))
    ..registerFactory<LeaderChatBloc>(() => LeaderChatBloc(watchInbox: sl(), watchMessages: sl(), sendMessage: sl(), leaderMessageAsReadUseCase: sl()));
}

void _leaderProfileRegistration(){
  sl.registerFactory<LeaderProfileBloc>(() => LeaderProfileBloc(logoutUsecase: sl()));
}

