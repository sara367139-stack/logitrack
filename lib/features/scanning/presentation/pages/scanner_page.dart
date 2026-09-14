import 'package:flutter/material.dart';

import 'package:logitrack/core/models/product_model.dart';
import 'package:logitrack/core/repositories/product_repository.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/app_dialog.dart';
import 'package:logitrack/core/widgets/app_snackbar.dart';
import 'package:logitrack/core/widgets/camera_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _repo = ProductRepository.instance;
  final _notes = TextEditingController();

  int _mode = 0;
  late ProductModel _product;
  late int _count;
  int _varianceReason = 0;
  int _scannedBins = 18;

  static const _reasons = [
    'Damaged during transit / Missing case',
    'Miscount in previous audit',
    'Theft / Shrinkage suspected',
    'Supplier short-shipment',
    'Data entry error',
  ];

  @override
  void initState() {
    super.initState();
    _product = _repo.all.first;
    _count = _product.currentQty - 4;
    _notes.text =
        '4 units packaging crushed on bottom tier / pallet; seals intact.';
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  int get _variance => _count - _product.currentQty;

  double get _variancePercent =>
      _product.currentQty == 0 ? 0 : (_variance / _product.currentQty) * 100;

  // ==================== Actions ====================

  void _onScanned(String code) {
    ProductModel? found;
    for (final p in _repo.all) {
      if (p.barcode == code || p.sku.toLowerCase() == code.toLowerCase()) {
        found = p;
        break;
      }
    }

    if (found == null) {
      AppSnackBar.warning(context, 'Unknown code: $code');
      return;
    }

    setState(() {
      _product = found!;
      _count = found.currentQty;
    });
    AppSnackBar.success(context, 'Scanned: ${found.sku}');
  }

  Future<void> _confirmSave() async {
    final ok = await AppDialog.confirm(
      context,
      title: _variance == 0 ? 'Confirm audit count?' : 'Variance detected!',
      message: _variance == 0
          ? 'Physical count matches system record (${_product.currentQty} units).'
          : 'Physical: $_count • System: ${_product.currentQty}\nVariance: ${_variance > 0 ? '+' : ''}$_variance units (${_variancePercent.toStringAsFixed(2)}%)\n\nThis will update inventory records.',
      confirmLabel: 'Save Audit',
      cancelLabel: 'Re-count',
      icon: _variance == 0
          ? Icons.check_circle_outline_rounded
          : Icons.warning_amber_rounded,
      danger: _variance != 0,
    );

    if (!ok || !mounted) return;

    AppDialog.showLoading(context, 'Syncing to ERP...');
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    AppDialog.hideLoading(context);

    setState(() => _scannedBins = (_scannedBins + 1).clamp(0, 24));

    AppSnackBar.success(
      context,
      'Audit saved • ${_product.bin} updated',
      action: 'Next Bin',
      onAction: _nextLocation,
    );
  }

  void _rescan() {
    setState(() => _count = _product.currentQty);
    AppSnackBar.info(context, 'Re-scanning ${_product.sku}...');
  }

  void _nextLocation() {
    final idx = _repo.all.indexOf(_product);
    final next = _repo.all[(idx + 1) % _repo.all.length];
    setState(() {
      _product = next;
      _count = next.currentQty;
    });
    AppSnackBar.info(context, 'Moved to ${next.bin} • ${next.sku}');
  }

  Future<void> _openReasonSheet() async {
    final picked = await AppDialog.picker<int>(
      context,
      title: 'Variance Classification',
      selected: _varianceReason,
      options: List.generate(
        _reasons.length,
        (i) => PickerOption(value: i, label: _reasons[i]),
      ),
    );

    if (picked != null) setState(() => _varianceReason = picked);
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final progress = _scannedBins / 24;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _Sq(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.qr_code_scanner_rounded,
                size: 17, color: AppColors.primary),
            const SizedBox(width: 7),
            Text(
              'Scanner',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        actions: [
          _Sq(icon: Icons.refresh_rounded, onTap: _rescan),
          const SizedBox(width: 8),
          Container(
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
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 150),
        children: [
          // ==================== Mode Tabs ====================
          Row(
            children: [
              Expanded(
                child: _ModeTab(
                  icon: Icons.bolt_rounded,
                  label: 'Quick Audit',
                  active: _mode == 0,
                  onTap: () => setState(() => _mode = 0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeTab(
                  icon: Icons.repeat_rounded,
                  label: 'Continuous Batch',
                  active: _mode == 1,
                  onTap: () {
                    setState(() => _mode = 1);
                    AppSnackBar.info(context, 'Batch mode enabled');
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ==================== 📷 Camera ====================
          CameraScanner(
            height: 190,
            cooldown: _mode == 1
                ? const Duration(milliseconds: 900)
                : const Duration(seconds: 2),
            onDetect: _onScanned,
          ),

          const SizedBox(height: 12),

          // ==================== Scanned Item ====================
          Container(
            padding: const EdgeInsets.all(13),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'SKU: ${_product.sku}',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: AppColors.green),
                          SizedBox(width: 4),
                          Text(
                            'LIVE SCAN',
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 30,
                      width: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.qr_code_2_rounded,
                          size: 16, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _product.name,
                  style: TextStyle(
                    fontSize: 15.5,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_product.category} • Barcode ${_product.barcode}',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 11),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 13, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${_product.zone}  ›  ${_product.aisle}  ›  ${_product.rack}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _product.bin,
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== Audit Counter ====================
          Container(
            padding: const EdgeInsets.all(13),
            decoration: _card,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _CountBox(
                        label: 'SYSTEM COUNT',
                        value: '${_product.currentQty}',
                        unit: 'Units',
                        sub: 'ERP Recorded',
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CountBox(
                        label: 'DISCREPANCY',
                        value: _variance > 0 ? '+$_variance' : '$_variance',
                        unit: 'Units',
                        sub:
                            '${_variancePercent.toStringAsFixed(2)}% Variance',
                        color:
                            _variance == 0 ? AppColors.green : AppColors.red,
                        soft: _variance != 0,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PHYSICAL AUDIT COUNT',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondaryText,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      'Tap +/- or preset below',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _RoundBtn(
                      icon: Icons.remove_rounded,
                      onTap: () => setState(
                          () => _count = (_count - 1).clamp(0, 999999)),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$_count',
                            style: TextStyle(
                              fontSize: 40,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              color: _variance == 0
                                  ? AppColors.green
                                  : AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Units',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RoundBtn(
                      icon: Icons.add_rounded,
                      filled: true,
                      onTap: () => setState(() => _count++),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    _Preset('+5', () => setState(() => _count += 5)),
                    const SizedBox(width: 8),
                    _Preset('+10', () => setState(() => _count += 10)),
                    const SizedBox(width: 8),
                    _Preset('+50', () => setState(() => _count += 50)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() => _count = _product.currentQty),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Match ERP',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'VARIANCE CLASSIFICATION',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondaryText,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _openReasonSheet,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _reasons[_varianceReason],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 18, color: AppColors.secondaryText),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'AUDITOR OBSERVATION NOTES',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondaryText,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notes,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: AppColors.text,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Add observation notes...',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== Session Progress ====================
          Container(
            padding: const EdgeInsets.all(13),
            decoration: _card,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.history_rounded,
                        size: 17, color: AppColors.primary),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Session Progress: $_scannedBins/24 Bins',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Aisle 4 North Sweep • ${_product.zone}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(progress * 100).round()}% Done',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.background,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ==================== Bottom ====================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _confirmSave,
                  icon: const Icon(Icons.check_circle_outline_rounded,
                      size: 19, color: Colors.white),
                  label: const Text(
                    'Confirm & Save Audit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _variance == 0 ? AppColors.green : AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _GhostBtn(
                      icon: Icons.refresh_rounded,
                      label: 'Re-scan SKU',
                      onTap: _rescan,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GhostBtn(
                      icon: Icons.arrow_forward_rounded,
                      label: 'Next Location',
                      iconRight: true,
                      onTap: _nextLocation,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Widgets ====================

BoxDecoration get _card => BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

class _Sq extends StatelessWidget {
  const _Sq({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 16, color: AppColors.text),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.surface : AppColors.background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 15,
                color: active ? AppColors.primary : AppColors.secondaryText),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: active ? AppColors.text : AppColors.secondaryText,
                ),
              ),
            ),
            if (active) ...[
              const SizedBox(width: 6),
              const Icon(Icons.circle, size: 7, color: AppColors.green),
            ],
          ],
        ),
      ),
    );
  }
}

class _CountBox extends StatelessWidget {
  const _CountBox({
    required this.label,
    required this.value,
    required this.unit,
    required this.sub,
    required this.color,
    this.soft = false,
  });

  final String label;
  final String value;
  final String unit;
  final String sub;
  final Color color;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: soft ? color.withOpacity(0.06) : AppColors.background,
        borderRadius: BorderRadius.circular(11),
        border: soft ? Border.all(color: color.withOpacity(0.25)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: soft ? color : AppColors.secondaryText,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: soft ? color : AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  const _RoundBtn({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: filled ? null : Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 22,
          color: filled ? Colors.white : AppColors.text,
        ),
      ),
    );
  }
}

class _Preset extends StatelessWidget {
  const _Preset(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        width: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }
}

class _GhostBtn extends StatelessWidget {
  const _GhostBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconRight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool iconRight;

  @override
  Widget build(BuildContext context) {
    final content = [
      Icon(icon, size: 15, color: AppColors.text),
      const SizedBox(width: 7),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
      ),
    ];

    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.background,
          side: BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconRight ? content.reversed.toList() : content,
        ),
      ),
    );
  }
}