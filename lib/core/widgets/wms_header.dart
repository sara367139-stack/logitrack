import 'package:flutter/material.dart';

import 'package:logitrack/core/localization/app_localizations.dart';
import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/theme/app_theme.dart';

class WmsHeader extends StatelessWidget implements PreferredSizeWidget {
  const WmsHeader({super.key, this.section, this.sectionKey});

  final String? section;
  final String? sectionKey;

  @override
  Size get preferredSize => const Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ===== Row 1 =====
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.local_shipping_rounded,
                        size: 17, color: Colors.white),
                  ),
                  const SizedBox(width: 9),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LogiTrack',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Text(
                        sectionKey == null
                            ? section ?? ''
                            : context.tr(sectionKey!),
                        style: TextStyle(
                          fontSize: 8.5,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryText,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.circle, size: 8, color: AppColors.green),
                  const SizedBox(width: 12),

                  // 🔔 الجرس → Floor Feed
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(AppRouter.notifications),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(Icons.notifications_none_rounded,
                              size: 17, color: AppColors.primary),
                        ),
                        Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            height: 14,
                            width: 14,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 👤 البروفايل → Terminal Profile
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(AppRouter.terminalProfile),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.person,
                          size: 17, color: AppColors.secondaryText),
                    ),
                  ),
                ],
              ),
            ),

            // ===== Row 2 =====
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: Row(
                children: [
                  // 🏢 المستودع → Warehouse Locations
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRouter.locations),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warehouse_outlined,
                              size: 13, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'WH-North Bay Hub',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              size: 15, color: AppColors.secondaryText),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.wifi_rounded,
                      size: 14, color: AppColors.secondaryText),
                  const SizedBox(width: 5),
                  Text(
                    '9:41 AM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}
