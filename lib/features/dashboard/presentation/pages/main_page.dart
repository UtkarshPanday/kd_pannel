import 'package:flutter/material.dart';
import 'package:kd_pannel/core/di/service_locator.dart';
import 'package:kd_pannel/core/navigation/navigation_service.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/topbar_widget.dart';
import 'dashboard_page.dart';
import 'support_dashboard_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = sl<NavigationService>();

    return Scaffold(
      body: Row(
        children: [
          // 1. Sidebar (Full Height)
          const SidebarWidget(),
          
          // 2. Right Side (Topbar + Content)
          Expanded(
            child: Column(
              children: [
                // Topbar (Only covers right area)
                const TopbarWidget(),
                
                // Content Area
                Expanded(
                  child: ValueListenableBuilder<int>(
                    valueListenable: navigationService.currentIndex,
                    builder: (context, index, child) {
                      return _getContentForIndex(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getContentForIndex(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const Center(child: Text('Leads Page', style: TextStyle(fontSize: 24)));
      case 2:
        return const Center(child: Text('Dealers Page', style: TextStyle(fontSize: 24)));
      case 3:
        return const Center(child: Text('Orders Page', style: TextStyle(fontSize: 24)));
      case 4:
        return const Center(child: Text('Products Page', style: TextStyle(fontSize: 24)));
      case 5:
        return const Center(child: Text('Marketing Page', style: TextStyle(fontSize: 24)));
      case 6:
        return const SupportDashboardPage();
      case 7:
        return const Center(child: Text('Team Management Page', style: TextStyle(fontSize: 24)));
      case 8:
        return const Center(child: Text('Reports Page', style: TextStyle(fontSize: 24)));
      case 9:
        return const Center(child: Text('Settings Page', style: TextStyle(fontSize: 24)));
      default:
        return const DashboardPage();
    }
  }
}
