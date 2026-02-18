import 'dart:async';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

// class VideoPreLoaderService {
//   static final VideoPreLoaderService _instance = VideoPreLoaderService._internal();
//   factory VideoPreLoaderService() => _instance;
//   VideoPreLoaderService._internal();
//
//   /// Sirf Reels ke controllers yahan store honge
//   final Map<String, BetterPlayerController> _reelControllers = {};
//
//   /// Global Mute State
//   static final ValueNotifier<bool> globalMuteNotifier = ValueNotifier(true);
//
//   /// REELS: Get or Create Controller
//   Future<BetterPlayerController> getControllerForReel(String url) async {
//     if (_reelControllers.containsKey(url)) {
//       return _reelControllers[url]!;
//     }
//
//     // Naya controller banao
//     BetterPlayerController controller = BetterPlayerController(
//       BetterPlayerConfiguration(
//         aspectRatio: 9 / 16, // Reels vertical hoti hain
//         fit: BoxFit.cover,   // Full Screen fill karega
//         autoPlay: false,     // Hum manually play karenge
//         looping: true,
//         handleLifecycle: true,
//         controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false),
//       ),
//     );
//
//     // Data Source Setup
//     try {
//       await controller.setupDataSource(
//         BetterPlayerDataSource(
//           BetterPlayerDataSourceType.network,
//           url,
//           cacheConfiguration: const BetterPlayerCacheConfiguration(
//             useCache: true,
//             preCacheSize: 3 * 1024 * 1024, // 3MB Cache
//           ),
//         ),
//       );
//
//       // Global Mute Sync
//       controller.setVolume(globalMuteNotifier.value ? 0.0 : 1.0);
//     } catch (e) {
//       debugPrint("❌ Error setting up source: $e");
//     }
//
//     _reelControllers[url] = controller;
//     return controller;
//   }
//
//   /// REELS: Dispose specific url
//   void disposeController(String url) {
//     if (_reelControllers.containsKey(url)) {
//       final controller = _reelControllers[url];
//       _reelControllers.remove(url);
//       try {
//         controller?.pause();
//         controller?.dispose();
//         debugPrint("🗑️ Disposed Reel: $url");
//       } catch (e) {
//         debugPrint("⚠️ Dispose error: $e");
//       }
//     }
//   }
//
//   /// Helper: Home Videos ke liye (No Caching in Singleton to avoid conflict)
//   static BetterPlayerController createHomeController(String url) {
//     BetterPlayerController controller = BetterPlayerController(
//       const BetterPlayerConfiguration(
//         aspectRatio: 16 / 9,
//         fit: BoxFit.contain,
//         autoPlay: false,
//         looping: false,
//         handleLifecycle: true,
//         controlsConfiguration: BetterPlayerControlsConfiguration(
//           showControls: true,
//           enableSkips: false,
//         ),
//       ),
//     );
//
//     controller.setupDataSource(
//       BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network,
//         url,
//         cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
//       ),
//     );
//
//     // Sync Mute
//     controller.setVolume(globalMuteNotifier.value ? 0.0 : 1.0);
//     return controller;
//   }
//
//   void disposeAll() {
//     for (var controller in _reelControllers.values) {
//       try {
//         controller.pause();
//         controller.dispose();
//       } catch (e) {
//         debugPrint("⚠️ Dispose Error: $e");
//       }
//     }
//     _reelControllers.clear();
//     debugPrint("🧹 All Reels Disposed");
//   }
// }

///

class VideoPreLoaderService {
  static final VideoPreLoaderService _instance = VideoPreLoaderService._internal();
  factory VideoPreLoaderService() => _instance;
  VideoPreLoaderService._internal();

  /// Cache for preloaded controllers
  final Map<String, BetterPlayerController> _preloadedControllers = {};

  static final ValueNotifier<bool> reelMuteNotifier = ValueNotifier(true);
  static final ValueNotifier<bool> homeMuteNotifier = ValueNotifier(true);

  /// REELS: Preload Only (Buffer mein daalo)
  Future<void> preloadReel(String url) async {
    if (_preloadedControllers.containsKey(url)) return;

    final controller = _createReelController(url);
    try {
      await controller.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          url,
          cacheConfiguration: const BetterPlayerCacheConfiguration(
            useCache: true,
            preCacheSize: 5 * 1024 * 1024,
          ),
        ),
      );
      _preloadedControllers[url] = controller;
      debugPrint("💾 Preloaded: $url");
    } catch (e) {
      debugPrint("❌ Preload Failed: $e");
    }
  }

  /// REELS: Claim Controller (Ownership Transfer)
  /// Agar cache mein hai toh wahan se nikaal kar Widget ko dedo.
  /// Agar nahi hai toh naya banao.
  BetterPlayerController claimController(String url) {
    if (_preloadedControllers.containsKey(url)) {
      debugPrint("✅ Claimed Cached Controller: $url");
      final controller = _preloadedControllers.remove(url)!; // Remove from cache, give to widget
      return controller;
    }
    debugPrint("✨ Created Fresh Controller: $url");
    return _createReelController(url);
  }

  BetterPlayerController _createReelController(String url) {
    final controller = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 9 / 16,
        fit: BoxFit.cover,
        autoPlay: false,
        looping: true,
        handleLifecycle: true,
        controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false),
      ),
    );
    // Initial Mute State
    controller.setVolume(reelMuteNotifier.value ? 0.0 : 1.0);
    return controller;
  }

  /// Screen Exit Cleanup
  void disposeAll() {
    for (var controller in _preloadedControllers.values) {
      controller.dispose();
    }
    _preloadedControllers.clear();
    debugPrint("🧹 Cache Cleared");
  }

  // Home Controller helper remains same
  static BetterPlayerController createHomeController(String url) {
    BetterPlayerController controller = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: false,
        looping: false,
        handleLifecycle: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: true,
          enableSkips: false,
        ),
      ),
    );

    controller.setupDataSource(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
        cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
      ),
    );

    controller.setVolume(homeMuteNotifier.value ? 0.0 : 1.0);
    return controller;
  }
}