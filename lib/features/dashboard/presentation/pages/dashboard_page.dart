import 'package:flutter/material.dart';
import 'package:kd_pannel/core/theme/app_theme.dart';
import '../widgets/stat_card_widget.dart';
import '../widgets/table_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingXLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'KrishiDealer Admin Dashboard',
                style: AppTheme.heading,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                  vertical: AppTheme.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.textSecondary),
                    SizedBox(width: AppTheme.spacingSmall),
                    Text(
                      'This Month',
                      style: TextStyle(fontSize: 13, color: AppTheme.textBody, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: AppTheme.spacingXSmall),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXLarge),
          const _StatRow1(),
          const SizedBox(height: 20),
          const _StatRow2(),
          const SizedBox(height: AppTheme.spacingXLarge),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TableWidget(
                  title: 'Recent Orders',
                  columns: ['Dealer', 'Product', 'Amount', 'Date', 'Status'],
                  rows: [
                    ['King Agro', 'Drip Irrigation', '\$2,400', '2023-10-24', 'Completed'],
                    ['Gupta Seeds', 'Hybrid Seeds', '\$650', '2023-10-24', 'Pending'],
                    ['Patel Agro Supplies', 'Irrigation Pump', '\$1,150', '2023-10-23', 'Completed'],
                  ],
                ),
              ),
              SizedBox(width: AppTheme.spacingLarge),
              Expanded(
                flex: 2,
                child: TableWidget(
                  title: 'Recent Leads',
                  columns: ['Dealer Name', 'Contact Person', 'Created Time'],
                  rows: [
                    ['Choudhary Krishi', 'Nirmal Choudhary', '2 hours ago'],
                    ['Greenway Agro', 'Priya Joshi', '5 hours ago'],
                    ['Shiva Enterprises', 'Ravi Singh', '3 days ago'],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatRow1 extends StatelessWidget {
  const _StatRow1();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatCardWidget(
            title: 'Revenue Today',
            value: '\$2,450',
            color: AppTheme.success,
            icon: Icons.account_balance_wallet_outlined,
          ),
        ),
        SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: StatCardWidget(
            title: 'Orders Today',
            value: '32',
            color: AppTheme.lightGreen,
            icon: Icons.shopping_bag_outlined,
          ),
        ),
        SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: StatCardWidget(
            title: 'Total Dealers',
            value: '920',
            color: AppTheme.info,
            icon: Icons.people_outline,
          ),
        ),
        SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: StatCardWidget(
            title: 'Active Dealers',
            value: '550',
            color: AppTheme.teal,
            icon: Icons.how_to_reg_outlined,
          ),
        ),
        SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: StatCardWidget(
            title: 'New Leads',
            value: '24',
            color: AppTheme.warning,
            icon: Icons.campaign_outlined,
          ),
        ),
      ],
    );
  }
}

class _StatRow2 extends StatelessWidget {
  const _StatRow2();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatCardWidget(
            title: 'Sales Performance',
            value: '74,200 Orders',
            color: AppTheme.success,
            icon: Icons.trending_up,
          ),
        ),
        SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: StatCardWidget(
            title: 'Dealer Onboarding',
            value: '320 Dealers Joined',
            color: AppTheme.lightGreen,
            icon: Icons.person_add_alt_1_outlined,
          ),
        ),
        SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: StatCardWidget(
            title: 'Order Status',
            value: '2,450',
            subtext: 'Total Orders',
            color: AppTheme.warning,
            icon: Icons.shopping_cart_outlined,
          ),
        ),
        SizedBox(width: AppTheme.spacingMedium),
        Expanded(
          child: StatCardWidget(
            title: 'Pending Orders',
            value: '140',
            subtext: 'Orders Pending',
            color: AppTheme.error,
            icon: Icons.hourglass_empty,
          ),
        ),
      ],
    );
  }
}
