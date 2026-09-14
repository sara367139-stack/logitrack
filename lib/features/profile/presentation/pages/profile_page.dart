import 'package:flutter/material.dart';

import 'package:logitrack/core/services/app_settings.dart';
import 'package:logitrack/core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ============================================================
  // TRANSLATION
  // ============================================================

  String _tr(BuildContext context, String en, String ar) {
    final settings = AppSettingsScope.of(context);
    return settings.isArabic ? ar : en;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final isArabic = settings.isArabic;

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(
            _tr(
              context,
              'Profile & Settings',
              'الملف والإعدادات',
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ==================================================
                // PROFILE HEADER
                // ==================================================

                _buildProfileHeader(context),

                const SizedBox(height: 22),

                // ==================================================
                // QUICK STATS
                // ==================================================

                _buildStatsSection(context),

                const SizedBox(height: 24),

                // ==================================================
                // PERSONAL INFORMATION
                // ==================================================

                _sectionTitle(
                  context,
                  'PERSONAL INFORMATION',
                  'المعلومات الشخصية',
                ),

                const SizedBox(height: 10),

                _buildSettingsCard(
                  children: [
                    _buildInfoTile(
                      context,
                      icon: Icons.person_outline_rounded,
                      title: _tr(
                        context,
                        'Name',
                        'الاسم',
                      ),
                      value: 'Sarah Jenkins',
                    ),

                    _divider(),

                    _buildInfoTile(
                      context,
                      icon: Icons.badge_outlined,
                      title: _tr(
                        context,
                        'Employee ID',
                        'رقم الموظف',
                      ),
                      value: 'WH-OP-8924',
                    ),

                    _divider(),

                    _buildInfoTile(
                      context,
                      icon: Icons.work_outline_rounded,
                      title: _tr(
                        context,
                        'Role',
                        'الوظيفة',
                      ),
                      value: _tr(
                        context,
                        'Operations Manager',
                        'مدير العمليات',
                      ),
                    ),

                    _divider(),

                    _buildInfoTile(
                      context,
                      icon: Icons.email_outlined,
                      title: _tr(
                        context,
                        'Email',
                        'البريد الإلكتروني',
                      ),
                      value: 'sarah@logitrack.com',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ==================================================
                // WAREHOUSE
                // ==================================================

                _sectionTitle(
                  context,
                  'WAREHOUSE',
                  'المخزن',
                ),

                const SizedBox(height: 10),

                _buildSettingsCard(
                  children: [
                    _buildActionTile(
                      context,
                      icon: Icons.warehouse_outlined,
                      title: _tr(
                        context,
                        'Assigned Warehouse',
                        'المخزن المخصص',
                      ),
                      subtitle: 'WH-North Bay Hub',
                      onTap: () {
                        _showWarehouseDialog(context);
                      },
                    ),

                    _divider(),

                    _buildActionTile(
                      context,
                      icon: Icons.schedule_outlined,
                      title: _tr(
                        context,
                        'Shift Schedule',
                        'جدول الوردية',
                      ),
                      subtitle: _tr(
                        context,
                        '08:00 AM - 04:00 PM',
                        '08:00 ص - 04:00 م',
                      ),
                    ),

                    _divider(),

                    _buildActionTile(
                      context,
                      icon: Icons.swap_horiz_rounded,
                      title: _tr(
                        context,
                        'Switch Warehouse',
                        'تغيير المخزن',
                      ),
                      subtitle: _tr(
                        context,
                        'Change your active warehouse',
                        'تغيير المخزن الحالي',
                      ),
                      onTap: () {
                        _showWarehouseDialog(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ==================================================
                // SECURITY
                // ==================================================

                _sectionTitle(
                  context,
                  'SECURITY & ACCESS',
                  'الأمان والوصول',
                ),

                const SizedBox(height: 10),

                _buildSettingsCard(
                  children: [
                    _buildActionTile(
                      context,
                      icon: Icons.lock_outline_rounded,
                      title: _tr(
                        context,
                        'Security & PIN',
                        'الأمان ورمز الدخول',
                      ),
                      subtitle: _tr(
                        context,
                        'Change access passcode',
                        'تغيير رمز الدخول',
                      ),
                      onTap: () {
                        _showComingSoon(context);
                      },
                    ),

                    _divider(),

                    _buildActionTile(
                      context,
                      icon: Icons.admin_panel_settings_outlined,
                      title: _tr(
                        context,
                        'Roles & Authority',
                        'الأدوار والصلاحيات',
                      ),
                      subtitle: _tr(
                        context,
                        'Manage account permissions',
                        'إدارة صلاحيات الحساب',
                      ),
                      onTap: () {
                        _showComingSoon(context);
                      },
                    ),

                    _divider(),

                    _buildActionTile(
                      context,
                      icon: Icons.lock_person_outlined,
                      title: _tr(
                        context,
                        'Lock Terminal',
                        'قفل الجهاز',
                      ),
                      subtitle: _tr(
                        context,
                        'Secure this warehouse terminal',
                        'تأمين جهاز المخزن',
                      ),
                      onTap: () {
                        _showLockDialog(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ==================================================
                // PREFERENCES
                // ==================================================

                _sectionTitle(
                  context,
                  'PREFERENCES',
                  'التفضيلات',
                ),

                const SizedBox(height: 10),

                _buildSettingsCard(
                  children: [

                    // LANGUAGE
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _iconBox(
                                Icons.language_rounded,
                              ),

                              const SizedBox(width: 13),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _tr(
                                        context,
                                        'Language',
                                        'اللغة',
                                      ),
                                      style: const TextStyle(
                                        color:
                                            AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      _tr(
                                        context,
                                        'Choose your app language',
                                        'اختر لغة التطبيق',
                                      ),
                                      style: const TextStyle(
                                        color:
                                            AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          _buildLanguageSelector(
                            context,
                            settings,
                          ),
                        ],
                      ),
                    ),

                    _divider(),

                    // DARK MODE
                    _buildSwitchTile(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: _tr(
                        context,
                        'Dark Mode',
                        'الوضع الداكن',
                      ),
                      subtitle: _tr(
                        context,
                        'Use dark appearance',
                        'استخدام المظهر الداكن',
                      ),
                      value: settings.isDark,
                      onChanged: (value) {
                        settings.setDarkMode(value);
                      },
                    ),

                    _divider(),

                    // NOTIFICATIONS
                    _buildSwitchTile(
                      context,
                      icon: Icons.notifications_none_rounded,
                      title: _tr(
                        context,
                        'Push Notifications',
                        'الإشعارات',
                      ),
                      subtitle: _tr(
                        context,
                        'Alerts for stock & orders',
                        'تنبيهات المخزون والطلبات',
                      ),
                      value: true,
                      onChanged: (_) {},
                    ),

                    _divider(),

                    // GLOVE MODE
                    _buildSwitchTile(
                      context,
                      icon: Icons.back_hand_outlined,
                      title: _tr(
                        context,
                        'Glove Mode',
                        'وضع القفازات',
                      ),
                      subtitle: _tr(
                        context,
                        'Larger touch targets',
                        'أزرار لمس أكبر',
                      ),
                      value: false,
                      onChanged: (_) {},
                    ),

                    _divider(),

                    // SCAN SOUND
                    _buildSwitchTile(
                      context,
                      icon: Icons.volume_up_outlined,
                      title: _tr(
                        context,
                        'Scan Sound Feedback',
                        'صوت تأكيد المسح',
                      ),
                      subtitle: _tr(
                        context,
                        'Beep on successful scan',
                        'إصدار صوت عند نجاح المسح',
                      ),
                      value: true,
                      onChanged: (_) {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ==================================================
                // TERMINAL & HARDWARE
                // ==================================================

                _sectionTitle(
                  context,
                  'TERMINAL & HARDWARE',
                  'الجهاز والمعدات',
                ),

                const SizedBox(height: 10),

                _buildSettingsCard(
                  children: [
                    _buildActionTile(
                      context,
                      icon: Icons.print_outlined,
                      title: _tr(
                        context,
                        'Printer Setup',
                        'إعداد الطابعة',
                      ),
                      subtitle: _tr(
                        context,
                        'Zebra ZD621 Thermal',
                        'طابعة Zebra ZD621 الحرارية',
                      ),
                      onTap: () {
                        _showComingSoon(context);
                      },
                    ),

                    _divider(),

                    _buildActionTile(
                      context,
                      icon: Icons.qr_code_scanner_rounded,
                      title: _tr(
                        context,
                        'Scanner Settings',
                        'إعدادات الماسح',
                      ),
                      subtitle: _tr(
                        context,
                        'Barcode scanner configuration',
                        'إعدادات ماسح الباركود',
                      ),
                      onTap: () {
                        _showComingSoon(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ==================================================
                // SYSTEM
                // ==================================================

                _sectionTitle(
                  context,
                  'SYSTEM',
                  'النظام',
                ),

                const SizedBox(height: 10),

                _buildSettingsCard(
                  children: [
                    _buildActionTile(
                      context,
                      icon: Icons.sync_rounded,
                      title: _tr(
                        context,
                        'Data Sync',
                        'مزامنة البيانات',
                      ),
                      subtitle: _tr(
                        context,
                        'Last synced 12ms ago',
                        'آخر مزامنة منذ 12 مللي ثانية',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success
                              .withValues(alpha: 0.10),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          _tr(
                            context,
                            'Online',
                            'متصل',
                          ),
                          style: const TextStyle(
                            color: AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    _divider(),

                    _buildActionTile(
                      context,
                      icon: Icons.help_outline_rounded,
                      title: _tr(
                        context,
                        'Help & Support',
                        'المساعدة والدعم',
                      ),
                      subtitle: _tr(
                        context,
                        'Guides, FAQ, contact',
                        'الأدلة والأسئلة الشائعة والتواصل',
                      ),
                      onTap: () {
                        _showComingSoon(context);
                      },
                    ),

                    _divider(),

                    _buildActionTile(
                      context,
                      icon: Icons.info_outline_rounded,
                      title: _tr(
                        context,
                        'About LogiTrack',
                        'عن LogiTrack',
                      ),
                      subtitle: _tr(
                        context,
                        'Version 4.8.2 (Build 2025)',
                        'الإصدار 4.8.2 (Build 2025)',
                      ),
                      onTap: () {
                        _showAboutDialog(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ==================================================
                // SERVER STATUS
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Text(
                          _tr(
                            context,
                            'Server: Online • Sync: 12ms • v4.8.2',
                            'الخادم: متصل • المزامنة: 12 مللي ثانية • v4.8.2',
                          ),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // SIGN OUT
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showSignOutDialog(context);
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                    ),
                    label: Text(
                      _tr(
                        context,
                        'Sign Out of Terminal',
                        'تسجيل الخروج من الجهاز',
                      ),
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.error
                            .withValues(alpha: 0.35),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text(
                'SJ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sarah Jenkins',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _tr(
                    context,
                    'Operations Manager',
                    'مدير العمليات',
                  ),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      _tr(
                        context,
                        'Active',
                        'نشط',
                      ),
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 19,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.qr_code_scanner_rounded,
            value: '1,284',
            label: _tr(
              context,
              'Scans Today',
              'عمليات المسح اليوم',
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            icon: Icons.verified_outlined,
            value: '99.8%',
            label: _tr(
              context,
              'Accuracy',
              'الدقة',
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            icon: Icons.location_on_outlined,
            value: 'A-12',
            label: _tr(
              context,
              'Zone',
              'المنطقة',
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  Widget _buildLanguageSelector(
    BuildContext context,
    AppSettings settings,
  ) {
    final isArabic = settings.isArabic;

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _languageButton(
              label: 'English',
              flag: '🇺🇸',
              active: !isArabic,
              onTap: () {
                settings.setLocale('en');
              },
            ),
          ),

          const SizedBox(width: 4),

          Expanded(
            child: _languageButton(
              label: 'العربية',
              flag: '🇸🇦',
              active: isArabic,
              onTap: () {
                settings.setLocale('ar');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageButton({
    required String label,
    required String flag,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: active
          ? AppColors.primary
          : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Center(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                flag,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(width: 7),

              Text(
                label,
                style: TextStyle(
                  color: active
                      ? AppColors.textWhite
                      : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS COMPONENTS
  // ============================================================

  Widget _sectionTitle(
    BuildContext context,
    String en,
    String ar,
  ) {
    return Text(
      _tr(context, en, ar),
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildSettingsCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        children: [
          _iconBox(icon),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isArabic =
        AppSettingsScope.of(context).isArabic;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              _iconBox(icon),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(
                  isArabic
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 9,
      ),
      child: Row(
        children: [
          _iconBox(icon),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 19,
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: 16,
      endIndent: 16,
    );
  }

  // ============================================================
  // WAREHOUSE DIALOG
  // ============================================================

  void _showWarehouseDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,

          title: Text(
            _tr(
              dialogContext,
              'Switch Warehouse',
              'تغيير المخزن',
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _warehouseOption(
                dialogContext,
                title: 'WH-North Bay Hub',
                subtitle: _tr(
                  dialogContext,
                  'Current warehouse',
                  'المخزن الحالي',
                ),
                selected: true,
              ),

              const SizedBox(height: 8),

              _warehouseOption(
                dialogContext,
                title: 'WH-South Distribution',
                subtitle: _tr(
                  dialogContext,
                  'Available warehouse',
                  'مخزن متاح',
                ),
                selected: false,
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                _tr(
                  dialogContext,
                  'Cancel',
                  'إلغاء',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _warehouseOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warehouse_outlined,
            color: selected
                ? AppColors.primary
                : AppColors.textSecondary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          if (selected)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // LOCK DIALOG
  // ============================================================

  void _showLockDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,

          title: Text(
            _tr(
              dialogContext,
              'Lock Terminal',
              'قفل الجهاز',
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Text(
            _tr(
              dialogContext,
              'Are you sure you want to lock this terminal?',
              'هل أنت متأكد أنك تريد قفل هذا الجهاز؟',
            ),
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                _tr(
                  dialogContext,
                  'Cancel',
                  'إلغاء',
                ),
              ),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                _tr(
                  dialogContext,
                  'Lock',
                  'قفل',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SIGN OUT DIALOG
  // ============================================================

  void _showSignOutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,

          title: Text(
            _tr(
              dialogContext,
              'Sign Out',
              'تسجيل الخروج',
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),

          content: Text(
            _tr(
              dialogContext,
              'Are you sure you want to sign out of this terminal?',
              'هل أنت متأكد أنك تريد تسجيل الخروج من هذا الجهاز؟',
            ),
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                _tr(
                  dialogContext,
                  'Cancel',
                  'إلغاء',
                ),
              ),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                _tr(
                  dialogContext,
                  'Sign Out',
                  'تسجيل الخروج',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'LogiTrack',
      applicationVersion: '4.8.2',
      applicationLegalese: _tr(
        context,
        'Warehouse Management System',
        'نظام إدارة المخازن',
      ),
    );
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
          _tr(
            context,
            'This feature will be available soon.',
            'هذه الخاصية ستكون متاحة قريبًا.',
          ),
          style: const TextStyle(
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }
}