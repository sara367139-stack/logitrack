import 'package:flutter/material.dart';

import 'package:logitrack/core/localization/app_localizations.dart';
import 'package:logitrack/core/theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _item(context, 0, Icons.grid_view_rounded, 'navHome'),
            _item(context, 1, Icons.inventory_2_outlined, 'navProducts'),
            _center(context),
            _item(context, 3, Icons.swap_horiz_rounded, 'navOperations'),
            _item(context, 4, Icons.bar_chart_rounded, 'navReports'),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context, int index, IconData icon, String key) {
    final active = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? AppColors.primary : AppColors.secondaryText,
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(key),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? AppColors.primary : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _center(BuildContext context) {
    final active = currentIndex == 2;
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.qr_code_scanner_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Text(
                context.tr('navAudit'),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color:
                      active ? AppColors.primary : AppColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}