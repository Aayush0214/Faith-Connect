import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';

import '../../services/video_pre_loader_service/video_pre_loader_service.dart';

// class AppVideoPlayer extends StatefulWidget {
//   final String url;
//   final bool isReel;
//   final bool autoPlay;
//
//   const AppVideoPlayer({
//     super.key,
//     required this.url,
//     this.isReel = false,
//     required this.autoPlay,
//   });
//
//   @override
//   State<AppVideoPlayer> createState() => _AppVideoPlayerState();
// }
//
// class _AppVideoPlayerState extends State<AppVideoPlayer> {
//   BetterPlayerController? _controller;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initController();
//   }
//
//   Future<void> _initController() async {
//     if (widget.isReel) {
//       // REELS: Service se lo (Shared memory management)
//       _controller = await VideoPreLoaderService().getControllerForReel(widget.url);
//     } else {
//       // HOME: Naya banao (Safe isolation)
//       _controller = VideoPreLoaderService.createHomeController(widget.url);
//     }
//
//     if (mounted) {
//       setState(() {
//         _isInitialized = true;
//       });
//       _handleAutoPlay();
//     }
//   }
//
//   @override
//   void didUpdateWidget(AppVideoPlayer oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.autoPlay != widget.autoPlay) {
//       _handleAutoPlay();
//     }
//   }
//
//   void _handleAutoPlay() {
//     if (_controller != null && _isInitialized) {
//       if (widget.autoPlay) {
//         _controller!.play();
//       } else {
//         _controller!.pause();
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     // HOME videos ko yahi dispose karo.
//     // REELS ko ReelsScreen dispose karega (Sliding window logic).
//     if (!widget.isReel) {
//       _controller?.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized || _controller == null) {
//       return Container(
//         color: Colors.black,
//         child: const Center(
//           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//         ),
//       );
//     }
//
//     return Container(
//       color: Colors.black,
//       child: widget.isReel
//           ? SizedBox.expand(child: BetterPlayer(controller: _controller!)) // Full Screen
//           : BetterPlayer(controller: _controller!), // Normal
//     );
//   }
// }

///

class AppVideoPlayer extends StatefulWidget {
  final String url;
  final bool isReel;
  final bool autoPlay;

  const AppVideoPlayer({
    super.key,
    required this.url,
    this.isReel = false,
    required this.autoPlay,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  BetterPlayerController? _controller;
  bool _isInitialized = false;

  // Flag to prevent loop (Listener -> Controller -> Listener)
  bool _isSyncing = false;

  ValueNotifier<bool> get _currentMuteNotifier => widget.isReel ? VideoPreLoaderService.reelMuteNotifier : VideoPreLoaderService.homeMuteNotifier;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    if (widget.isReel) {
      // Service se "Maang lo" (Claim ownership)
      _controller = VideoPreLoaderService().claimController(widget.url);

      // Data source agar already setup nahi hai (Fresh case)
      if (_controller!.betterPlayerDataSource == null) {
        await _controller!.setupDataSource(
            BetterPlayerDataSource(
              BetterPlayerDataSourceType.network,
              widget.url,
              cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
            )
        );
      }
    } else {
      _controller = VideoPreLoaderService.createHomeController(widget.url);
    }

    // Global Mute Sync listener
    _currentMuteNotifier.addListener(_onGlobalMuteChanged);

    // 2. LOCAL -> GLOBAL (Jab User native button dabaye - Home Page Fix)
    if (!widget.isReel && _controller?.videoPlayerController != null) {
      _controller!.videoPlayerController!.addListener(_onLocalVolumeChanged);
    }

    // Force sync initial state
    _onGlobalMuteChanged();

    if (mounted) {
      setState(() => _isInitialized = true);
      _handleAutoPlay();
    }
  }

  // JAB GLOBAL VARIABLE BADLE (Reel Tap ya Code se)
  void _onGlobalMuteChanged() {
    if (_isSyncing || _controller == null) return;

    final shouldBeMuted = _currentMuteNotifier.value;
    final currentVolume = _controller!.videoPlayerController!.value.volume;

    // Agar already waisa hi hai toh kuch mat karo
    if ((shouldBeMuted && currentVolume == 0.0) || (!shouldBeMuted && currentVolume > 0)) {
      return;
    }

    _isSyncing = true; // Loop protect
    _controller!.setVolume(shouldBeMuted ? 0.0 : 1.0);
    _isSyncing = false;
  }

  // JAB USER NATIVE BUTTON DABAYE (Sirf Home Page ke liye)
  void _onLocalVolumeChanged() {
    if (_isSyncing || _controller == null) return;

    // Check karo abhi volume kya hai
    final currentVolume = _controller!.videoPlayerController!.value.volume;
    final isMutedLocally = currentVolume == 0.0;

    // Agar Global variable alag hai, toh use update karo
    if (_currentMuteNotifier.value != isMutedLocally) {
      _isSyncing = true; // Loop protect
      _currentMuteNotifier.value = isMutedLocally; // Ye sabko bata dega!
      _isSyncing = false;
    }
  }

  @override
  void didUpdateWidget(AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay) {
      _handleAutoPlay();
    }
  }

  void _handleAutoPlay() {
    if (_controller != null && _isInitialized) {
      try {
        if (widget.autoPlay) {
          _controller!.play();
        } else {
          _controller!.pause();
        }
      } catch (e) {
        debugPrint("⚠️ Controller Error: $e");
      }
    }
  }

  @override
  void dispose() {
    _currentMuteNotifier.removeListener(_onGlobalMuteChanged);
    // Local listener hatana zaroori hai
    _controller?.videoPlayerController?.removeListener(_onLocalVolumeChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Container(
      color: Colors.black,
      child: widget.isReel
          ? SizedBox.expand(child: BetterPlayer(controller: _controller!))
          : BetterPlayer(controller: _controller!),
    );
  }
}