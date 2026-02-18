import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteTransitions {
  static const Duration _defaultDuration = Duration(milliseconds: 300);

  static CustomTransitionPage slideRightToLeft(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? _defaultDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage fade(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? _defaultDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage scale(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? _defaultDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
    );
  }

  // Additional transition - Slide from bottom
  static CustomTransitionPage slideBottomToTop(Widget child, {Duration? duration}) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration ?? _defaultDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  // No transition - Direct page
  static CustomTransitionPage noTransition(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}