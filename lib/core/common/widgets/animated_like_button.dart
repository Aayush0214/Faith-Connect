import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedActionButton extends StatefulWidget {
  final int count;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const AnimatedActionButton({
    super.key,
    required this.icon,
    required this.count,
    required this.onTap,
    required this.iconColor,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: IconButton(
        icon: Icon(
          widget.icon,
          size: 24.sp,
          color: widget.iconColor,
        ),
        onPressed: () {
          _controller.forward().then((_) => _controller.reverse());
          widget.onTap();
        },
      ),
    );
  }
}
