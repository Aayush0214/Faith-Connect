import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors/app_colors.dart';
import 'package:faith_connect/core/common/widgets/custom_text.dart';

class WorshiperMainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const WorshiperMainWrapper({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: AppColors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home_rounded, 'Home', 0),
            _buildNavItem(Icons.people_rounded, 'Leaders', 1),
            _buildNavItem(Icons.video_collection, 'Reels', 2),
            _buildNavItem(Icons.chat, 'Chats', 3),
            _buildNavItem(Icons.person_rounded, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = navigationShell.currentIndex == index;
    return InkWell(
      onTap: () => _onTap(index),
      customBorder: CircleBorder(),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Icon(
              icon,
              color: isSelected ? AppColors.white : Colors.grey,
            ),
          ),
          Expanded(
            child: CustomText(
              text: label,
              textColor: isSelected ? AppColors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
