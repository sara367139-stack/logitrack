import 'package:flutter/material.dart';

import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/services/app_settings.dart';
import 'package:logitrack/core/services/storage_service.dart';
import 'package:logitrack/core/theme/app_colors.dart';
import 'package:logitrack/core/widgets/app_dialog.dart';
import 'package:logitrack/core/widgets/app_snackbar.dart';
import 'package:logitrack/core/widgets/wms_header.dart';

class TerminalProfilePage extends StatefulWidget {
  const TerminalProfilePage({super.key});

  @override
  State<TerminalProfilePage> createState() => _TerminalProfilePageState();
}

class _TerminalProfilePageState extends State<TerminalProfilePage> {
  int _lang = 0;
  int _display = 0;
  bool _imager = true;

  @override
  void initState() {
    super.initState();
    _lang = StorageService.isArabic ? 1 : 0;
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  Future<void> _changeLang(String code) async {
    await AppSettingsScope.of(context).setLocale(code);

    if (!mounted) return;

    setState(() {
      _lang = code == 'ar' ? 1 : 0;
    });

    AppSnackBar.success(
      context,
      code == 'en'
          ? 'Language set to English'
          : 'تم تغيير اللغة للعربية',
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> _signOut() async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Sign out of terminal?',
      message:
          'Your shift session will end. Any unsaved audit counts will be lost.',
      confirmLabel: 'Sign Out',
      cancelLabel: 'Stay',
      icon: Icons.logout_rounded,
      danger: true,
    );

    if (!ok || !mounted) return;

    AppDialog.showLoading(context, 'Signing out...');

    await Future.delayed(
      const Duration(milliseconds: 600),
    );

    await StorageService.logout();

    if (!mounted) return;

    AppDialog.hideLoading(context);

    AppSnackBar.info(
      context,
      'Signed out successfully',
    );

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.login,
      (route) => false,
    );
  }

  // ============================================================
  // LOCK TERMINAL
  // ============================================================

  Future<void> _lockTerminal() async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Lock terminal?',
      message: 'You will need your PIN to resume the session.',
      confirmLabel: 'Lock Now',
      icon: Icons.lock_outline_rounded,
    );

    if (ok && mounted) {
      AppSnackBar.info(
        context,
        'Terminal locked',
      );
    }
  }

  // ============================================================
  // SWITCH WAREHOUSE
  // ============================================================

  Future<void> _switchWarehouse() async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Switch warehouse?',
      message:
          'Active tasks in ${StorageService.warehouse} will be paused.',
      confirmLabel: 'Switch',
      icon: Icons.swap_horiz_rounded,
    );

    if (ok && mounted) {
      AppSnackBar.success(
        context,
        'Switched to WH-East Annex',
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isArabic = StorageService.isArabic;

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const WmsHeader(
          section: 'TERMINAL',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            12,
            14,
            24,
          ),
          children: [
            // ======================================================
            // PROFILE HEADER
            // ======================================================

            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 62,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                        top: 10,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.18,
                            ),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 6,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Shift A • Live Session',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -26),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 58,
                                width: 58,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 28,
                                  color: AppColors.primary,
                                ),
                              ),

                              const Spacer(),

                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 4,
                                ),
                                child: Row(
                                  children: [
                                    const _SmallBtn(
                                      icon:
                                          Icons.badge_outlined,
                                      label: 'ID Card',
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 30,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.background,
                                        borderRadius:
                                            BorderRadius.circular(
                                          8,
                                        ),
                                        border: Border.all(
                                          color:
                                              AppColors.border,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 15,
                                        color:
                                            AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 11),

                          Row(
                            children: [
                              Text(
                                StorageService.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color:
                                      AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Lead Lvl 3',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Align(
                            alignment:
                                AlignmentDirectional.centerStart,
                            child: const Text(
                              'Warehouse Operations Lead (Shift A)',
                              style: TextStyle(
                                fontSize: 10.5,
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Align(
                            alignment:
                                AlignmentDirectional.centerStart,
                            child: Text(
                              'TRM-NB-04 • Badge #${StorageService.userBadge}',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Container(
                            padding:
                                const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.background,
                              borderRadius:
                                  BorderRadius.circular(11),
                            ),
                            child: const Row(
                              children: [
                                _Stat(
                                  'SCANS TODAY',
                                  '428',
                                ),
                                _VDiv(),
                                _Stat(
                                  'ACCURACY',
                                  '99.8%',
                                ),
                                _VDiv(),
                                _Stat(
                                  'ZONE',
                                  'A-HighBay',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            // ======================================================
            // ERGONOMICS
            // ======================================================

            _Card(
              icon: Icons.accessibility_new_rounded,
              title: 'Ergonomics & Layout',
              sub:
                  'Tailored for fast single-hand floor handling',
              children: [
                const _MicroLabel(
                  'INTERFACE ORIENTATION & LANGUAGE',
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _Choice(
                        label: 'English (LTR)',
                        active: _lang == 0,
                        onTap: () {
                          _changeLang('en');
                        },
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: _Choice(
                        label: 'العربية (RTL)',
                        active: _lang == 1,
                        onTap: () {
                          _changeLang('ar');
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Text(
                      'Terminal Viewport:',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      _lang == 0
                          ? 'Standard LTR Layout'
                          : 'تخطيط RTL',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const _MicroLabel(
                  'DISPLAY & GLARE OPTIMIZATION',
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: _DisplayBox(
                        icon:
                            Icons.wb_sunny_outlined,
                        title:
                            'Warehouse\nDaylight',
                        sub: 'Active',
                        active: _display == 0,
                        onTap: () {
                          setState(() {
                            _display = 0;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: _DisplayBox(
                        icon:
                            Icons.nightlight_outlined,
                        title: 'OLED Dark',
                        sub: 'Dim Aisles',
                        active: _display == 1,
                        onTap: () {
                          setState(() {
                            _display = 1;
                          });

                          AppSnackBar.info(
                            context,
                            'Dark mode coming soon',
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: _DisplayBox(
                        icon:
                            Icons.back_hand_outlined,
                        title:
                            'Glove Hi-\nContrast',
                        sub: '+30% Target',
                        active: _display == 2,
                        onTap: () {
                          setState(() {
                            _display = 2;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                const Row(
                  children: [
                    Expanded(
                      child: _UnitBox(
                        label: 'UNITS',
                        value: 'Metric (kg, m³)',
                        icon:
                            Icons.straighten_rounded,
                        trailing: 'Imp',
                      ),
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: _UnitBox(
                        label: 'CURRENCY',
                        value: '\$ USD',
                        icon:
                            Icons.attach_money_rounded,
                        trailing: 'Fixed',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ======================================================
            // HARDWARE
            // ======================================================

            _Card(
              icon: Icons.memory_rounded,
              title: 'Terminal Hardware',
              sub: 'Peripherals & Local Edge Cache',
              badge: '3 / 3 Ready',
              children: [
                _HwRow(
                  icon:
                      Icons.qr_code_scanner_rounded,
                  title: 'Zebra Built-in Imager',
                  sub:
                      'Active • Beep + Haptic on Scan',
                  trailing: Switch.adaptive(
                    value: _imager,
                    onChanged: (v) {
                      setState(() {
                        _imager = v;
                      });

                      AppSnackBar.info(
                        context,
                        v
                            ? 'Imager enabled'
                            : 'Imager disabled',
                      );
                    },
                    activeThumbColor:
                        AppColors.primary,
                    activeTrackColor:
                        AppColors.primary.withValues(
                      alpha: 0.35,
                    ),
                  ),
                ),

                const SizedBox(height: 9),

                _HwRow(
                  icon: Icons.print_outlined,
                  title: 'Zebra ZD621 Bluetooth',
                  sub:
                      '● Connected • 4×6" Labels',
                  subColor: AppColors.success,
                  trailing: GestureDetector(
                    onTap: () {
                      AppSnackBar.success(
                        context,
                        'Test label sent',
                      );
                    },
                    child: const _Chip(
                      'Test Feed',
                    ),
                  ),
                ),

                const SizedBox(height: 9),

                _HwRow(
                  icon: Icons.storage_rounded,
                  title: 'Always Cache Bins Offline',
                  sub:
                      '14.2 MB cached • 1,240 Bin IDs',
                  trailing: GestureDetector(
                    onTap: () {
                      AppSnackBar.success(
                        context,
                        'Cache refreshed',
                      );
                    },
                    child: Container(
                      height: 30,
                      width: 32,
                      decoration: BoxDecoration(
                        color:
                            AppColors.background,
                        borderRadius:
                            BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ======================================================
            // ROLES
            // ======================================================

            _Card(
              icon:
                  Icons.verified_user_outlined,
              title: 'Roles & Authority',
              sub:
                  'Level 3 Specialist privileges on terminal',
              badge: 'L3',
              children: const [
                _Perm(
                  allowed: true,
                  title: 'Cycle Counts & Audits',
                  sub:
                      'Unlimited spot-check and discrepancy logging',
                ),

                SizedBox(height: 11),

                _Perm(
                  allowed: true,
                  title:
                      'Inbound & Outbound Dispatches',
                  sub:
                      'Can digitally manifest and sign freight bills',
                ),

                SizedBox(height: 11),

                _Perm(
                  allowed: true,
                  title:
                      'Purchase Order Reorders',
                  sub:
                      'Authorized for replenishment under \$25,000',
                ),

                SizedBox(height: 11),

                _Perm(
                  allowed: false,
                  title:
                      'Master Stock Deprecations',
                  sub:
                      'Requires Admin Override PIN (WH-Supervisor)',
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ======================================================
            // ACTIONS
            // ======================================================

            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  _ActionRow(
                    icon:
                        Icons.swap_horiz_rounded,
                    label:
                        'Switch Warehouse Facility',
                    trailing:
                        StorageService.warehouse,
                    onTap: _switchWarehouse,
                  ),

                  Divider(
                    height: 1,
                    indent: 50,
                    color: AppColors.border,
                  ),

                  _ActionRow(
                    icon:
                        Icons.lock_outline_rounded,
                    label:
                        'Lock Handheld Terminal',
                    trailing: 'PIN LOCK',
                    onTap: _lockTerminal,
                    last: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ======================================================
            // SIGN OUT
            // ======================================================

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _signOut,
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 17,
                  color: AppColors.error,
                ),
                label: const Text(
                  'Sign Out (TRM-NB-04)',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.error,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.error.withValues(
                    alpha: 0.10,
                  ),
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// STAT
// ================================================================

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// VERTICAL DIVIDER
// ================================================================

class _VDiv extends StatelessWidget {
  const _VDiv();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 26,
      color: AppColors.border,
    );
  }
}

// ================================================================
// SMALL BUTTON
// ================================================================

class _SmallBtn extends StatelessWidget {
  const _SmallBtn({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding:
          const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.badge_outlined,
            size: 13,
            color: AppColors.textPrimary,
          ),

          const SizedBox(width: 5),

          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// CARD
// ================================================================

class _Card extends StatelessWidget {
  const _Card({
    required this.icon,
    required this.title,
    required this.sub,
    required this.children,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String sub;
  final List<Widget> children;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withValues(alpha: 0.10),
                  borderRadius:
                      BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color:
                            AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      sub,
                      style: const TextStyle(
                        fontSize: 9.5,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        AppColors.success.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color:
                          AppColors.success,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }
}

// ================================================================
// MICRO LABEL
// ================================================================

class _MicroLabel extends StatelessWidget {
  const _MicroLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 8.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.7,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ================================================================
// LANGUAGE CHOICE
// ================================================================

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(10),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(
                  alpha: 0.10,
                )
              : AppColors.background,
          borderRadius:
              BorderRadius.circular(10),
          border: Border.all(
            color: active
                ? AppColors.primary
                : AppColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: active
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ================================================================
// DISPLAY BOX
// ================================================================

class _DisplayBox extends StatelessWidget {
  const _DisplayBox({
    required this.icon,
    required this.title,
    required this.sub,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String sub;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(11),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(
                  alpha: 0.10,
                )
              : AppColors.background,
          borderRadius:
              BorderRadius.circular(11),
          border: Border.all(
            color: active
                ? AppColors.primary
                : AppColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: active
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),

            const SizedBox(height: 7),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9.5,
                height: 1.2,
                fontWeight: FontWeight.w900,
                color: active
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              sub,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: active
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// UNIT BOX
// ================================================================

class _UnitBox extends StatelessWidget {
  const _UnitBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.trailing,
  });

  final String label;
  final String value;
  final IconData icon;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                  color:
                      AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              Icon(
                icon,
                size: 12,
                color:
                    AppColors.textSecondary,
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color:
                        AppColors.textPrimary,
                  ),
                ),
              ),

              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color:
                      AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================================================================
// HARDWARE ROW
// ================================================================

class _HwRow extends StatelessWidget {
  const _HwRow({
    required this.icon,
    required this.title,
    required this.sub,
    required this.trailing,
    this.subColor,
  });

  final IconData icon;
  final String title;
  final String sub;
  final Widget trailing;
  final Color? subColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius:
            BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(9),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
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
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    color:
                        AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 9,
                    color: subColor ??
                        AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          trailing,
        ],
      ),
    );
  }
}

// ================================================================
// CHIP
// ================================================================

class _Chip extends StatelessWidget {
  const _Chip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ================================================================
// PERMISSION
// ================================================================

class _Perm extends StatelessWidget {
  const _Perm({
    required this.allowed,
    required this.title,
    required this.sub,
  });

  final bool allowed;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          allowed
              ? Icons.check_circle_outline_rounded
              : Icons.lock_outline_rounded,
          size: 16,
          color: allowed
              ? AppColors.success
              : AppColors.error,
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color:
                      AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                sub,
                style: const TextStyle(
                  fontSize: 9.5,
                  height: 1.4,
                  color:
                      AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ================================================================
// ACTION ROW
// ================================================================

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String trailing;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: AppColors.primary,
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color:
                      AppColors.textPrimary,
                ),
              ),
            ),

            Flexible(
              child: Text(
                trailing,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color:
                      AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 4),

            Icon(
              Icons.chevron_right_rounded,
              size: 17,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}