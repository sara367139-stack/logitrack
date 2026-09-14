import 'package:flutter/material.dart';

import 'package:logitrack/core/models/supplier_model.dart';
import 'package:logitrack/core/repositories/supplier_repository.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/app_dialog.dart';
import 'package:logitrack/core/widgets/app_snackbar.dart';

class PoLine {
  PoLine({
    required this.sku,
    required this.name,
    required this.qty,
    required this.price,
  });

  final String sku;
  final String name;
  int qty;
  final double price;

  double get total => qty * price;
}

class CreatePoPage extends StatefulWidget {
  const CreatePoPage({super.key, this.supplierName});

  final String? supplierName;

  @override
  State<CreatePoPage> createState() => _CreatePoPageState();
}

class _CreatePoPageState extends State<CreatePoPage> {
  final _repo = SupplierRepository.instance;

  late SupplierModel _supplier;
  int _terms = 1;
  bool _autoApprove = false;
  bool _submitting = false;

  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 14));
  String _deliverTo = 'North Bay Hub';

  final _lines = <PoLine>[
    PoLine(
      sku: 'BEAR-6205-HD',
      name: 'Heavy-Duty Ball Bearings',
      qty: 500,
      price: 11.20,
    ),
    PoLine(
      sku: 'BEAR-6301-LT',
      name: 'Light-Duty Bearings 6301',
      qty: 300,
      price: 8.40,
    ),
  ];

  static const _catalog = [
    ('BEAR-6002-STD', 'Standard Bearing 6002', 200, 6.75),
    ('PACK-BX12-25', 'Corrugated Boxes 12x12', 100, 32.00),
    ('ELEC-CAP-470', 'Electrolytic Capacitor 470uF', 1000, 1.35),
  ];

  static const _termsList = ['Net 15', 'Net 30', 'Net 45'];
  static const _warehouses = ['North Bay Hub', 'East Annex', 'South Depot'];

  @override
  void initState() {
    super.initState();
    _supplier = _repo.all.first;
  }

  double get _subtotal => _lines.fold(0, (s, l) => s + l.total);
  double get _tax => _subtotal * 0.14;
  double get _total => _subtotal + _tax;
  int get _totalUnits => _lines.fold(0, (s, l) => s + l.qty);

  String _money(double v) {
    final parts = v.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }

  String _dateLabel(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  // ==================== Actions ====================

  Future<void> _pickSupplier() async {
    final suppliers = _repo.byType(PartnerType.supplier);

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Supplier',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ...suppliers.map(
              (s) => ListTile(
                dense: true,
                leading: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(s.icon,
                      size: 17, color: AppColors.secondaryText),
                ),
                title: Text(
                  s.name,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: s.id == _supplier.id
                        ? FontWeight.w900
                        : FontWeight.w700,
                    color: s.id == _supplier.id
                        ? AppColors.primary
                        : AppColors.text,
                  ),
                ),
                subtitle: Text(
                  '${s.code} • ${s.paymentTerms} • ${s.leadTimeDays}d lead',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.secondaryText,
                  ),
                ),
                trailing: s.id == _supplier.id
                    ? Icon(Icons.check_circle_rounded,
                        size: 19, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => _supplier = s);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _addLine() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add Line Item',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ..._catalog.map((item) {
              final exists = _lines.any((l) => l.sku == item.$1);
              return ListTile(
                dense: true,
                enabled: !exists,
                leading: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(Icons.inventory_2_outlined,
                      size: 17, color: AppColors.secondaryText),
                ),
                title: Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color:
                        exists ? AppColors.secondaryText : AppColors.text,
                  ),
                ),
                subtitle: Text(
                  '${item.$1} • \$${item.$4.toStringAsFixed(2)} / unit',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.secondaryText,
                  ),
                ),
                trailing: exists
                    ? const Text(
                        'Added',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.green,
                        ),
                      )
                    : Icon(Icons.add_circle_outline_rounded,
                        size: 20, color: AppColors.primary),
                onTap: exists
                    ? null
                    : () {
                        setState(() {
                          _lines.add(PoLine(
                            sku: item.$1,
                            name: item.$2,
                            qty: item.$3,
                            price: item.$4,
                          ));
                        });
                        Navigator.pop(context);
                        AppSnackBar.success(context, '${item.$2} added');
                      },
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _removeLine(int index) async {
    final line = _lines[index];
    final ok = await AppDialog.confirm(
      context,
      title: 'Remove item?',
      message: '${line.name} will be removed from this PO.',
      confirmLabel: 'Remove',
      icon: Icons.remove_circle_outline_rounded,
      danger: true,
    );

    if (ok && mounted) {
      setState(() => _lines.removeAt(index));
      AppSnackBar.info(context, 'Item removed');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) setState(() => _deliveryDate = picked);
  }

  Future<void> _submit() async {
    if (_lines.isEmpty) {
      AppSnackBar.error(context, 'Add at least one line item');
      return;
    }

    final ok = await AppDialog.confirm(
      context,
      title: 'Submit purchase order?',
      message:
          'Supplier: ${_supplier.name}\nTotal: \$${_money(_total)} • $_totalUnits units\nTerms: ${_termsList[_terms]}',
      confirmLabel: 'Submit PO',
      cancelLabel: 'Review',
      icon: Icons.send_rounded,
    );

    if (!ok || !mounted) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _submitting = false);

    await AppDialog.success(
      context,
      title: 'PO Submitted',
      message: _autoApprove
          ? 'PO-2025-0893 auto-approved and sent to ${_supplier.name}.'
          : 'PO-2025-0893 sent for supervisor approval.',
      buttonLabel: 'Done',
      onDone: () => Navigator.of(context).pop(),
    );
  }

  Future<void> _cancel() async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Discard purchase order?',
      message: 'This draft will not be saved.',
      confirmLabel: 'Discard',
      cancelLabel: 'Keep Editing',
      icon: Icons.delete_outline_rounded,
      danger: true,
    );

    if (ok && mounted) Navigator.of(context).pop();
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: _submitting ? null : _cancel,
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(Icons.close_rounded,
                  size: 17, color: AppColors.text),
            ),
          ),
        ),
        title: Text(
          'Create Purchase Order',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'DRAFT',
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          // ==================== PO Number ====================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.heroGradient),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.receipt_long_rounded,
                      size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PO NUMBER (AUTO)',
                        style: TextStyle(
                          fontSize: 8.5,
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'PO-2025-0893',
                        style: TextStyle(
                          fontSize: 19,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _dateLabel(DateTime.now()),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== Supplier ====================
          _Sec(
            icon: Icons.factory_outlined,
            title: 'Supplier Information',
            children: [
              const _FLabel('SUPPLIER', required: true),
              InkWell(
                onTap: _submitting ? null : _pickSupplier,
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(_supplier.icon,
                            size: 19, color: AppColors.secondaryText),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _supplier.code,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _supplier.tier.color
                                        .withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _supplier.tier.label,
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                      color: _supplier.tier.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _supplier.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.swap_horiz_rounded,
                          size: 18, color: AppColors.primary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),
              const _FLabel('PAYMENT TERMS'),
              const SizedBox(height: 8),
              Row(
                children: List.generate(_termsList.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: i < _termsList.length - 1 ? 8 : 0),
                      child: _Chip3(
                        label: _termsList[i],
                        active: _terms == i,
                        onTap: _submitting
                            ? null
                            : () => setState(() => _terms = i),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FLabel('DELIVERY DATE'),
                        InkWell(
                          onTap: _submitting ? null : _pickDate,
                          borderRadius: BorderRadius.circular(10),
                          child: _Pick(
                            icon: Icons.event_outlined,
                            value: _dateLabel(_deliveryDate),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FLabel('DELIVER TO'),
                        _PickDropdown(
                          icon: Icons.warehouse_outlined,
                          value: _deliverTo,
                          items: _warehouses,
                          enabled: !_submitting,
                          onChanged: (v) => setState(() => _deliverTo = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ==================== Line Items ====================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _dec,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(Icons.list_alt_rounded,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Line Items',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_lines.length} items • $_totalUnits units',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (_lines.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 26),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 34, color: AppColors.secondaryText),
                        const SizedBox(height: 10),
                        Text(
                          'No items added yet',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ..._lines.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: _LineCard(
                            line: e.value,
                            enabled: !_submitting,
                            onRemove: () => _removeLine(e.key),
                            onQtyChange: (q) =>
                                setState(() => e.value.qty = q),
                          ),
                        ),
                      ),

                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _submitting ? null : _addLine,
                    icon: Icon(Icons.add_rounded,
                        size: 17, color: AppColors.primary),
                    label: Text(
                      'Add Line Item',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== Totals ====================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _dec,
            child: Column(
              children: [
                _TotalRow('Subtotal', '\$${_money(_subtotal)}'),
                const SizedBox(height: 10),
                _TotalRow('VAT (14%)', '\$${_money(_tax)}'),
                const SizedBox(height: 10),
                const _TotalRow('Shipping', 'Included',
                    valueColor: AppColors.green),
                const SizedBox(height: 12),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${_money(_total)}',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ==================== Auto Approve ====================
          Container(
            padding: const EdgeInsets.all(13),
            decoration: _dec,
            child: Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: _autoApprove
                        ? AppColors.primaryLight
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.verified_outlined,
                    size: 17,
                    color: _autoApprove
                        ? AppColors.primary
                        : AppColors.secondaryText,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-Approve (Under \$25k)',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Skip supervisor review for this PO',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _autoApprove,
                  onChanged: _submitting || _total >= 25000
                      ? null
                      : (v) => setState(() => _autoApprove = v),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          if (_total >= 25000) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.orange.withOpacity(0.25)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 17, color: AppColors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Orders above \$25,000 require supervisor approval.',
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),

      // ==================== Bottom ====================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: _submitting
                      ? null
                      : () => AppSnackBar.info(
                          context, 'PDF preview coming soon'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    side: BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Preview',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: _submitting
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded,
                            size: 17, color: Colors.white),
                    label: Text(
                      _submitting
                          ? 'Submitting...'
                          : 'Submit PO • \$${_total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          AppColors.primary.withOpacity(0.55),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Shared ====================

BoxDecoration get _dec => BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

class _LineCard extends StatelessWidget {
  const _LineCard({
    required this.line,
    required this.onRemove,
    required this.onQtyChange,
    this.enabled = true,
  });

  final PoLine line;
  final VoidCallback onRemove;
  final ValueChanged<int> onQtyChange;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.sku,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      line.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: enabled ? onRemove : null,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(Icons.remove_circle_outline_rounded,
                      size: 18, color: AppColors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: enabled && line.qty > 1
                          ? () => onQtyChange(
                              line.qty - 50 > 0 ? line.qty - 50 : 1)
                          : null,
                      child: SizedBox(
                        height: 30,
                        width: 28,
                        child: Icon(Icons.remove_rounded,
                            size: 14, color: AppColors.text),
                      ),
                    ),
                    SizedBox(
                      width: 42,
                      child: Text(
                        '${line.qty}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap:
                          enabled ? () => onQtyChange(line.qty + 50) : null,
                      child: SizedBox(
                        height: 30,
                        width: 28,
                        child: Icon(Icons.add_rounded,
                            size: 14, color: AppColors.text),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _Mini('UNIT', '\$${line.price.toStringAsFixed(2)}'),
              const Spacer(),
              Text(
                '\$${line.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow(this.label, this.value, {this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: AppColors.secondaryText,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            color: valueColor ?? AppColors.text,
          ),
        ),
      ],
    );
  }
}

class _Sec extends StatelessWidget {
  const _Sec({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _dec,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
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

class _FLabel extends StatelessWidget {
  const _FLabel(this.text, {this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
              color: AppColors.secondaryText,
            ),
          ),
          if (required) ...[
            const SizedBox(width: 3),
            const Text(
              '*',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pick extends StatelessWidget {
  const _Pick({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.secondaryText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 17, color: AppColors.secondaryText),
        ],
      ),
    );
  }
}

class _PickDropdown extends StatelessWidget {
  const _PickDropdown({
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppColors.secondaryText),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(value) ? value : items.first,
                isExpanded: true,
                isDense: true,
                dropdownColor: AppColors.surface,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    size: 17, color: AppColors.secondaryText),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
                items: items
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: enabled
                    ? (v) {
                        if (v != null) onChanged(v);
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip3 extends StatelessWidget {
  const _Chip3({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: active ? Colors.white : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}