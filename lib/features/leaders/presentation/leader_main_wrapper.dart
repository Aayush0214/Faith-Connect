import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/widgets/custom_text.dart';
import '../../../core/theme/app_colors/app_colors.dart';

class LeaderMainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LeaderMainWrapper({
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
        elevation: 20,
        color: AppColors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.dashboard_outlined, 'Dashboard', 0),
            _buildNavItem(Icons.add_box_outlined, 'Create', 1),
            _buildNavItem(Icons.message_outlined, 'Message', 2),
            _buildNavItem(Icons.settings, 'Settings', 3),
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