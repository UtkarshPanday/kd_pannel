import 'package:flutter/material.dart';
import 'package:kd_pannel/core/di/service_locator.dart';
import 'package:kd_pannel/core/navigation/navigation_service.dart';
import 'package:kd_pannel/core/theme/app_theme.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = sl<NavigationService>();

    return Container(
      width: 260,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        children: [
          // 1. Sidebar Header (Logo Section)
          Container(
            height: 70, // EXACT height to match Topbar
            width: double.infinity,
            padding: const EdgeInsets.only(left: 24), // EXACT 24px left padding
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1), // Exact alignment with Topbar border
              ),
            ),
            child: Image.asset(
              'assets/images/logo.png',
              width: 155, // Matching reference size
              height: 155,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.storefront_rounded,
                color: Color(0xFF4CAF50),
                size: 32,
              ),
            ),
          ),
          
          const SizedBox(height: 20), // Top spacing after divider: 20px
          
          // 2. Navigation Menu
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: navigationService.currentIndex,
              builder: (context, currentIndex, child) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 10,
                  separatorBuilder: (context, index) => const SizedBox(height: 6), // Item gap: 6px
                  itemBuilder: (context, index) {
                    final items = [
                      {'icon': Icons.dashboard_rounded, 'title': 'Dashboard'},
                      {'icon': Icons.campaign_rounded, 'title': 'Leads'},
                      {'icon': Icons.storefront_rounded, 'title': 'Dealers'},
                      {'icon': Icons.shopping_cart_rounded, 'title': 'Orders'},
                      {'icon': Icons.inventory_2_rounded, 'title': 'Products'},
                      {'icon': Icons.ad_units_rounded, 'title': 'Marketing'},
                      {'icon': Icons.support_agent_rounded, 'title': 'Support'},
                      {'icon': Icons.groups_rounded, 'title': 'Team Management'},
                      {'icon': Icons.bar_chart_rounded, 'title': 'Reports'},
                      {'icon': Icons.settings_rounded, 'title': 'Settings'},
                    ];
                    final item = items[index];
                    return _MenuItem(
                      icon: item['icon'] as IconData,
                      title: item['title'] as String,
                      isActive: currentIndex == index,
                      onTap: () => navigationService.setIndex(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 44, // Item height: 44px
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppTheme.primaryColor : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 14), // Gap: 14px
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? AppTheme.primaryColor : const Color(0xFF374151),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
