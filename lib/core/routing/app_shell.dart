import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/app_bottom_nav.dart';
import 'package:logitrack/features/dashboard/presentation/pages/warehouse_dashboard_page.dart';
import 'package:logitrack/features/products/presentation/pages/products_page.dart';
import 'package:logitrack/features/scanning/presentation/pages/scanner_page.dart';
import 'package:logitrack/features/operations/presentation/pages/operations_page.dart';
import 'package:logitrack/features/reports/presentation/pages/reports_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void changePage(int i) => setState(() => currentIndex = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          WarehouseDashboardPage(onOpenProducts: () => changePage(1)),
          const PurchaseOrdersPage(),
          const ScannerPage(),
          const OperationsPage(),
          const ReportsPage(),
          // const _Placeholder(
          //   title: 'Reports',
          //   icon: Icons.bar_chart_rounded,
          // ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onChanged: changePage,
      ),
    );
  }
}

// ignore: unused_element
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'This module will be implemented next.',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}