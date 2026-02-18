import 'dart:io';

import 'package:faith_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'core/services/notification_service/notification_service.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:faith_connect/core/routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:faith_connect/core/theme/app_colors/app_colors.dart';
import 'package:faith_connect/features/onboarding/presentation/bloc/on_boarding_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // --- SAFE INITIALIZATION ---
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      // Retry logic:
      httpClient: RetryClient(
        http.Client(),
        retries: 3,
        when: (response) => response.statusCode == 503,
        whenError: (error, stackTrace) => error is SocketException,
      ),
    );
  } catch (e) {
    debugPrint("Supabase Init Warning: $e");
  }

  // --- Dependency Injection and Notifications ---
  await initDependencies();

  try {
    final notificationService = sl<NotificationService>();
    await notificationService.initNotifications();
  } catch (e) {
    debugPrint("Notification Init Error: $e");
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<OnBoardingBloc>()..add(FetchOnBoardingStatusEvent())),
        BlocProvider.value(value: sl<AuthBloc>()..add(AuthCheckSession())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.white),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
