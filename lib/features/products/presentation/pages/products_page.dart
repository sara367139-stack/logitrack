import 'package:flutter/material.dart';

import 'package:logitrack/core/models/purchase_order_model.dart';
import 'package:logitrack/core/repositories/po_repository.dart';
import 'package:logitrack/core/routing/app_router.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/empty_state.dart';
import 'package:logitrack/core/widgets/wms_header.dart';

class PurchaseOrdersPage extends StatefulWidget {
  const PurchaseOrdersPage({super.key});

  @override
  State<PurchaseOrdersPage> createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> {
  final _repo = PoRepository.instance;
  final _searchCtrl = TextEditingController();

  String _search = '';
  int _filter = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ✅ تم إصلاح الدالة لتعمل على Dart 2+ ودون replaceAllMapped
  String _money(double v) {
    final val = v.abs();
    final integer = val.toInt();
    final decimal = ((val - integer) * 100).round().toString().padLeft(2, '0');
    if (integer == 0) return '0.$decimal';
    String out = '';
    String s = integer.toString();
    for (int i = 0; i < s.length; i++) {
      if ((s.length - i) % 3 == 0 && i != 0) out += ',';
      out += s[i];
    }
    return v < 0 ? '-$out.$decimal' : '$out.$decimal';
  }

  @override
  Widget build(BuildContext context) {
    final orders = _repo.query(search: _search, filterIndex: _filter);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WmsHeader(section: 'PROCUREMENT'),
      body: Column(
        children: [
          // ===== Title =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Purchase Orders',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Q4 PROCUREMENT',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
              children: [
                // ===== Commitments =====
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF16233A), Color(0xFF23364F)],
                    ),
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
                        child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 20,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'OPEN COMMITMENTS',
                              style: TextStyle(
                                fontSize: 8.5,
                                letterSpacing: 0.9,
                                fontWeight: FontWeight.w900,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '\$${_money(_repo.openCommitments)}',
                              style: const TextStyle(
                                fontSize: 22,
                                height: 1,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 7, color: AppColors.green),
                          const SizedBox(width: 5),
                          Text(
                            '${_repo.inboundDue} Inbound Due',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ===== Search =====
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _search = v),
                          decoration: InputDecoration(
                            hintText: 'Search PO Number, Supplier, Item',
                            prefixIcon:
                                const Icon(Icons.search_rounded, size: 19),
                            fillColor: Colors.white,
                            suffixIcon: _search.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.close_rounded,
                                        size: 17),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() => _search = '');
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.filter_list_rounded,
                          size: 19, color: AppColors.text),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ===== Filters =====
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: PoRepository.filterLabels.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final sel = i == _filter;
                      final count = _repo.countFor(i);

                      return GestureDetector(
                        onTap: () => setState(() => _filter = i),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  sel ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                PoRepository.filterLabels[i],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: sel
                                      ? Colors.white
                                      : AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: sel
                                      ? Colors.white.withOpacity(0.22)
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: sel
                                        ? Colors.white
                                        : AppColors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // ===== List =====
                if (orders.isEmpty)
                  SizedBox(
                    height: 300,
                    child: EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'No purchase orders',
                      message: _search.isNotEmpty
                          ? 'Nothing matched "$_search".'
                          : 'No orders in this status.',
                      actionLabel:
                          _search.isNotEmpty ? 'Clear Search' : null,
                      onAction: () {
                        _searchCtrl.clear();
                        setState(() {
                          _search = '';
                          _filter = 0;
                        });
                      },
                    ),
                  )
                else
                  ...orders.map(
                    (po) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: po.isActive
                          ? _PoCardActive(po: po)
                          : _PoCard(po: po),
                    ),
                  ),

                const SizedBox(height: 4),

                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRouter.createPo),
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        size: 19, color: Colors.white),
                    label: const Text(
                      'Generate New Purchase Order',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= Active Card =================

class _PoCardActive extends StatelessWidget {
  const _PoCardActive({required this.po});

  final PurchaseOrderModel po;

  // ✅ تم إصلاح منطق عرض الساعة (منتصف الليل أصبح 12 AM، والظهر 12 PM)
  String _date(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    int hour = d.hour;
    String ap = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) hour = 12; // منتصف الليل
    else if (hour > 12) hour -= 12; // بعد الظهر
    final min = d.minute.toString().padLeft(2, '0');
    return '${months[d.month - 1]} ${d.day}, $hour:$min $ap';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
              ),
            ),
            Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        po.code,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: po.status.color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_shipping_outlined,
                                size: 10, color: po.status.color),
                            const SizedBox(width: 4),
                            Text(
                              po.status.label,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: po.status.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        po.amountLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          po.supplierName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Text(
                        po.itemsLabel,
                        style: TextStyle(
                          fontSize: 9.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Stepper
                  Row(
                    children: [
                      _Step('DRAFT', po.status.step >= 0),
                      _StepLine(po.status.step >= 1),
                      _Step('APPROVED', po.status.step >= 1),
                      _StepLine(po.status.step >= 2),
                      _Step('TRANSIT', po.status.step >= 2,
                          current: po.status.step == 2),
                      _StepLine(po.status.step >= 3),
                      _Step('RECEIVED', po.status.step >= 3),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Est. Arrival: ${_date(po.expectedAt)}',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              po.carrier,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                              ),
                            ),
                            const Text(
                              'Live',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      SizedBox(
                        height: 42,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AppRouter.movementDetails),
                          icon: Icon(Icons.visibility_outlined,
                              size: 14, color: AppColors.text),
                          label: Text(
                            'Manifest',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            side: BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AppRouter.audit),
                            icon: const Icon(Icons.qr_code_scanner_rounded,
                                size: 16, color: Colors.white),
                            label: const Text(
                              'Receive Dock Scan',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= Regular Card =================

class _PoCard extends StatelessWidget {
  const _PoCard({required this.po});

  final PurchaseOrderModel po;

  String _shortDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDone = po.status == PoStatus.reconciled ||
        po.status == PoStatus.received;

    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRouter.movementDetails),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 7,
                    runSpacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        po.code,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: po.status.color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                size: 6, color: po.status.color),
                            const SizedBox(width: 4),
                            Text(
                              po.status.label,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: po.status.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      po.amountLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      po.itemsLabel,
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              po.supplierName,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 11),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 13, color: AppColors.primary),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      isDone
                          ? 'Delivered: ${_shortDate(po.expectedAt)}'
                          : 'Target Dispatch: ${_shortDate(po.expectedAt)}',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Text(
                    po.priority,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 11),

            Row(
              children: [
                Icon(
                  isDone
                      ? Icons.check_circle_outline_rounded
                      : Icons.send_rounded,
                  size: 13,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    po.note ?? '${po.carrier} • ${po.dockBay}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRouter.movementDetails),
                    icon: Icon(
                      isDone
                          ? Icons.description_outlined
                          : Icons.replay_rounded,
                      size: 13,
                      color: AppColors.text,
                    ),
                    label: Text(
                      isDone ? 'Audit Slip' : 'Resend Ping',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Stepper =================

class _Step extends StatelessWidget {
  const _Step(this.label, this.done, {this.current = false});

  final String label;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: done ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: done ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: done
              ? const Icon(Icons.check, size: 9, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
            color: current
                ? AppColors.primary
                : (done ? AppColors.text : AppColors.secondaryText),
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine(this.done);

  final bool done;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16, left: 3, right: 3),
        color: done ? AppColors.primary : AppColors.border,
      ),
    );
  }
}