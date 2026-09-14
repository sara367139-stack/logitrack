import 'package:flutter/material.dart';

import 'package:logitrack/core/models/movement_model.dart';
import 'package:logitrack/core/repositories/product_repository.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/app_dialog.dart';
import 'package:logitrack/core/widgets/app_snackbar.dart';

class MoveItem {
  MoveItem({
    required this.sku,
    required this.name,
    required this.qty,
    required this.maxQty,
  });

  final String sku;
  final String name;
  final int maxQty;
  int qty;
}

class NewMovementPage extends StatefulWidget {
  const NewMovementPage({super.key});

  @override
  State<NewMovementPage> createState() => _NewMovementPageState();
}

class _NewMovementPageState extends State<NewMovementPage> {
  final _notesCtrl = TextEditingController();

  MovementType _type = MovementType.outbound;
  int _priority = 1;
  bool _notify = true;
  bool _creating = false;

  DateTime _date = DateTime.now();
  String _timeWindow = '14:00 – 16:00';
  String _origin = 'WH-North Bay (Zone A)';
  String _destination = 'Metro Distribution Center';
  String _dockBay = 'Bay 04';
  String _carrier = 'FedEx Freight';

  final _items = <MoveItem>[];

  static const _timeWindows = [
    '08:00 – 10:00',
    '10:00 – 12:00',
    '14:00 – 16:00',
    '16:00 – 18:00',
  ];
  static const _docks = ['Bay 01', 'Bay 02', 'Bay 04', 'Bay 07', 'Lane 02'];
  static const _carriers = [
    'FedEx Freight',
    'DHL Express',
    'UPS Ground',
    'Internal Fleet',
  ];
  static const _origins = [
    'WH-North Bay (Zone A)',
    'WH-North Bay (Zone B)',
    'Apex Precision Ltd.',
    'Global Fasteners Co.',
  ];
  static const _destinations = [
    'Metro Distribution Center',
    'Apex Assembly Plant',
    'WH-East (Zone C)',
    'WH-South Depot',
  ];

  @override
  void initState() {
    super.initState();
    // ابدأي بمنتج افتراضي من الـ Repository
    final first = ProductRepository.instance.all.first;
    _items.add(MoveItem(
      sku: first.sku,
      name: first.name,
      qty: (first.currentQty * 0.3).round().clamp(1, first.currentQty),
      maxQty: first.currentQty,
    ));
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  int get _totalUnits => _items.fold(0, (s, i) => s + i.qty);

  String _dateLabel(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  // ==================== Actions ====================

  void _switchType(MovementType t) {
    setState(() {
      _type = t;
      switch (t) {
        case MovementType.inbound:
          _origin = 'Apex Precision Ltd.';
          _destination = 'WH-North Bay (Zone A)';
          break;
        case MovementType.outbound:
          _origin = 'WH-North Bay (Zone A)';
          _destination = 'Metro Distribution Center';
          break;
        case MovementType.transfer:
          _origin = 'WH-North Bay (Zone A)';
          _destination = 'WH-East (Zone C)';
          break;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _addItem() async {
    final products = ProductRepository.instance.all;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: SizedBox(
          height: 420,
          child: Column(
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
                'Add to Manifest',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final p = products[i];
                    final exists = _items.any((it) => it.sku == p.sku);
                    final empty = p.currentQty == 0;

                    return ListTile(
                      dense: true,
                      enabled: !exists && !empty,
                      leading: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(p.icon,
                            size: 17, color: AppColors.secondaryText),
                      ),
                      title: Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: (exists || empty)
                              ? AppColors.secondaryText
                              : AppColors.text,
                        ),
                      ),
                      subtitle: Text(
                        '${p.sku} • ${p.currentQty} available • ${p.bin}',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: empty
                              ? AppColors.red
                              : AppColors.secondaryText,
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
                          : empty
                              ? const Text(
                                  'Empty',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.red,
                                  ),
                                )
                              : Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                      onTap: (exists || empty)
                          ? null
                          : () {
                              setState(() {
                                _items.add(MoveItem(
                                  sku: p.sku,
                                  name: p.name,
                                  qty: (p.currentQty * 0.3)
                                      .round()
                                      .clamp(1, p.currentQty),
                                  maxQty: p.currentQty,
                                ));
                              });
                              Navigator.pop(context);
                              AppSnackBar.success(
                                  context, '${p.name} added');
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _removeItem(int index) async {
    final item = _items[index];
    final ok = await AppDialog.confirm(
      context,
      title: 'Remove item?',
      message: '${item.name} will be removed from the manifest.',
      confirmLabel: 'Remove',
      icon: Icons.remove_circle_outline_rounded,
      danger: true,
    );

    if (ok && mounted) {
      setState(() => _items.removeAt(index));
      AppSnackBar.info(context, 'Item removed');
    }
  }

  Future<void> _create() async {
    if (_items.isEmpty) {
      AppSnackBar.error(context, 'Add at least one item to the manifest');
      return;
    }

    final ok = await AppDialog.confirm(
      context,
      title: 'Create ${_type.label.toLowerCase()} movement?',
      message:
          '$_origin → $_destination\n$_totalUnits units • ${_items.length} SKU\n${_dateLabel(_date)} • $_timeWindow',
      confirmLabel: 'Create',
      cancelLabel: 'Review',
      icon: _type.icon,
    );

    if (!ok || !mounted) return;

    setState(() => _creating = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _creating = false);

    await AppDialog.success(
      context,
      title: 'Movement Created',
      message: _notify
          ? '#DISP-9022 scheduled. Floor team has been notified.'
          : '#DISP-9022 scheduled successfully.',
      buttonLabel: 'Done',
      onDone: () => Navigator.of(context).pop(),
    );
  }

  Future<void> _cancel() async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Discard movement?',
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
          child: _Sq(
            Icons.close_rounded,
            _creating ? null : _cancel,
          ),
        ),
        title: Text(
          'New Movement',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _creating
                ? null
                : () => AppSnackBar.info(context, 'Draft saved locally'),
            child: Text(
              'Save Draft',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          // ==================== Movement Type ====================
          const _Label('MOVEMENT TYPE'),
          const SizedBox(height: 9),
          Row(
            children: MovementType.values.map((t) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: t == MovementType.transfer ? 0 : 9),
                  child: _TypeBox(
                    icon: t.icon,
                    title:
                        t == MovementType.outbound ? 'Outbound' : t.label,
                    sub: t == MovementType.inbound
                        ? 'Receive'
                        : t == MovementType.outbound
                            ? 'Dispatch'
                            : 'Internal',
                    active: _type == t,
                    onTap: _creating ? null : () => _switchType(t),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // ==================== Route ====================
          _Card(
            icon: Icons.route_rounded,
            title: 'Route Details',
            children: [
              const _FieldLabel('ORIGIN', required: true),
              _Dropdown(
                icon: Icons.warehouse_outlined,
                value: _origin,
                items: _origins,
                enabled: !_creating,
                onChanged: (v) => setState(() => _origin = v),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(Icons.arrow_downward_rounded,
                      size: 16, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              const _FieldLabel('DESTINATION', required: true),
              _Dropdown(
                icon: Icons.place_outlined,
                value: _destination,
                items: _destinations,
                enabled: !_creating,
                onChanged: (v) => setState(() => _destination = v),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('DOCK BAY'),
                        _Dropdown(
                          icon: Icons.garage_outlined,
                          value: _dockBay,
                          items: _docks,
                          enabled: !_creating,
                          onChanged: (v) => setState(() => _dockBay = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('CARRIER'),
                        _Dropdown(
                          icon: Icons.local_shipping_outlined,
                          value: _carrier,
                          items: _carriers,
                          enabled: !_creating,
                          onChanged: (v) => setState(() => _carrier = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ==================== Manifest ====================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _cardDeco,
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
                      child: Icon(Icons.inventory_2_outlined,
                          size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Cargo Manifest',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_items.length} SKU',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (_items.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 26),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 34, color: AppColors.secondaryText),
                        const SizedBox(height: 10),
                        Text(
                          'Manifest is empty',
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
                  ..._items.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: _ItemRow(
                            item: e.value,
                            enabled: !_creating,
                            onRemove: () => _removeItem(e.key),
                            onQtyChange: (q) =>
                                setState(() => e.value.qty = q),
                          ),
                        ),
                      ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: _creating ? null : _addItem,
                          icon: Icon(Icons.add_rounded,
                              size: 17, color: AppColors.primary),
                          label: Text(
                            'Add Item',
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
                    ),
                    const SizedBox(width: 9),
                    InkWell(
                      onTap: _creating
                          ? null
                          : () => AppSnackBar.info(
                              context, 'Scan to add coming soon'),
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        height: 44,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(Icons.qr_code_scanner_rounded,
                            size: 19, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'TOTAL UNITS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$_totalUnits units',
                      style: TextStyle(
                        fontSize: 15,
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

          // ==================== Schedule ====================
          _Card(
            icon: Icons.event_available_outlined,
            title: 'Schedule & Priority',
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('DATE'),
                        InkWell(
                          onTap: _creating ? null : _pickDate,
                          borderRadius: BorderRadius.circular(10),
                          child: _StaticField(
                            icon: Icons.calendar_today_outlined,
                            value: _dateLabel(_date),
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
                        const _FieldLabel('TIME WINDOW'),
                        _Dropdown(
                          icon: Icons.schedule_rounded,
                          value: _timeWindow,
                          items: _timeWindows,
                          enabled: !_creating,
                          onChanged: (v) =>
                              setState(() => _timeWindow = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _FieldLabel('PRIORITY LEVEL'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _PriorityBtn(
                      label: 'Standard',
                      color: AppColors.secondaryText,
                      active: _priority == 0,
                      onTap: _creating
                          ? null
                          : () => setState(() => _priority = 0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PriorityBtn(
                      label: 'Priority A1',
                      color: AppColors.orange,
                      active: _priority == 1,
                      onTap: _creating
                          ? null
                          : () => setState(() => _priority = 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PriorityBtn(
                      label: 'Critical',
                      color: AppColors.red,
                      active: _priority == 2,
                      onTap: _creating
                          ? null
                          : () => setState(() => _priority = 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _FieldLabel('OPERATOR NOTES'),
              TextField(
                controller: _notesCtrl,
                enabled: !_creating,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Handling instructions, special requirements...',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ==================== Notify ====================
          Container(
            padding: const EdgeInsets.all(13),
            decoration: _cardDeco,
            child: Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: _notify
                        ? AppColors.primaryLight
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    size: 17,
                    color: _notify
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
                        'Notify Floor Team',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Push alert to assigned dock operators',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _notify,
                  onChanged:
                      _creating ? null : (v) => setState(() => _notify = v),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          if (_priority == 2) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.red.withOpacity(0.25)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.priority_high_rounded,
                      size: 18, color: AppColors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Critical movements bypass queue and alert supervisors immediately.',
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.red,
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
                  onPressed: _creating ? null : _cancel,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.background,
                    side: BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
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
                    onPressed: _creating ? null : _create,
                    icon: _creating
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded,
                            size: 18, color: Colors.white),
                    label: Text(
                      _creating ? 'Creating...' : 'Create Movement',
                      style: const TextStyle(
                        fontSize: 14,
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

BoxDecoration get _cardDeco => BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.onRemove,
    required this.onQtyChange,
    this.enabled = true,
  });

  final MoveItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQtyChange;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final atMax = item.qty >= item.maxQty;

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
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(Icons.inventory_2_outlined,
                    size: 16, color: AppColors.secondaryText),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.sku,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
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
          const SizedBox(height: 9),
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
                      onTap: enabled && item.qty > 1
                          ? () => onQtyChange(
                              (item.qty - 10) > 0 ? item.qty - 10 : 1)
                          : null,
                      child: SizedBox(
                        height: 30,
                        width: 28,
                        child: Icon(
                          Icons.remove_rounded,
                          size: 14,
                          color: item.qty > 1
                              ? AppColors.text
                              : AppColors.border,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 46,
                      child: Text(
                        '${item.qty}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: enabled && !atMax
                          ? () => onQtyChange(
                              (item.qty + 10).clamp(1, item.maxQty))
                          : null,
                      child: SizedBox(
                        height: 30,
                        width: 28,
                        child: Icon(
                          Icons.add_rounded,
                          size: 14,
                          color:
                              atMax ? AppColors.border : AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'max ${item.maxQty}',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: atMax ? AppColors.orange : AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                '${item.qty} units',
                style: TextStyle(
                  fontSize: 12,
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

class _Card extends StatelessWidget {
  const _Card({
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
      decoration: _cardDeco,
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

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        color: AppColors.secondaryText,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});

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

class _StaticField extends StatelessWidget {
  const _StaticField({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.secondaryText),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: AppColors.secondaryText),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.secondaryText),
          const SizedBox(width: 9),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(value) ? value : items.first,
                isExpanded: true,
                isDense: true,
                dropdownColor: AppColors.surface,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    size: 18, color: AppColors.secondaryText),
                style: TextStyle(
                  fontSize: 12,
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

class _TypeBox extends StatelessWidget {
  const _TypeBox({
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 21,
                color: active ? Colors.white : AppColors.secondaryText),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: active ? Colors.white : AppColors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: TextStyle(
                fontSize: 8.5,
                color: active ? Colors.white70 : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityBtn extends StatelessWidget {
  const _PriorityBtn({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Color color;
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
          color: active ? color.withOpacity(0.12) : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? color : AppColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: active ? color : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}

class _Sq extends StatelessWidget {
  const _Sq(this.icon, this.onTap);

  final IconData icon;
  final VoidCallback? onTap;

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
        child: Icon(icon, size: 17, color: AppColors.text),
      ),
    );
  }
}