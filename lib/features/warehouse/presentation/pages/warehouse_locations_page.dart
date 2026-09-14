import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/widgets/wms_header.dart';

class BinCell {
  const BinCell({
    required this.code,
    required this.pct,
    required this.label,
    required this.status,
  });

  final String code;
  final String pct;
  final String label;
  final BinStatus status;
}

enum BinStatus { occupied, empty, reserved, selected }

class WarehouseLocationsPage extends StatefulWidget {
  const WarehouseLocationsPage({super.key});

  @override
  State<WarehouseLocationsPage> createState() =>
      _WarehouseLocationsPageState();
}

class _WarehouseLocationsPageState extends State<WarehouseLocationsPage> {
  static const _level3 = [
    BinCell(code: 'A3', pct: '85%', label: 'Fluid Filters', status: BinStatus.occupied),
    BinCell(code: 'B3', pct: '100%', label: 'Ball Bearings', status: BinStatus.selected),
    BinCell(code: 'C3', pct: '0%', label: 'Empty Slot', status: BinStatus.empty),
  ];

  static const _level2 = [
    BinCell(code: 'A2', pct: '40%', label: 'V-Belts 45cm', status: BinStatus.occupied),
    BinCell(code: 'B2', pct: '90%', label: 'Gear Spindles', status: BinStatus.occupied),
    BinCell(code: 'C2', pct: '15%', label: 'O-Ring Seals', status: BinStatus.occupied),
  ];

  static const _level1 = [
    BinCell(code: 'A1', pct: '100%', label: 'Hub Castings', status: BinStatus.occupied),
    BinCell(code: 'B1', pct: '70%', label: 'Roller Rods', status: BinStatus.occupied),
    BinCell(code: 'C1', pct: 'Hold', label: 'Reserved', status: BinStatus.reserved),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WmsHeader(section: 'INVENTORY'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
        children: [
          // ===== WH Header =====
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _card,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(Icons.warehouse_rounded,
                          size: 20, color: AppColors.primary),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WH-North Bay Hub',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Primary Logistics Center • Bay 14',
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
                          horizontal: 11, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.swap_horiz_rounded,
                              size: 13, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Switch',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    _Crumb('North Bay', Icons.warehouse_outlined),
                    _CrumbArrow(),
                    _Crumb('Zone A (Heavy)', Icons.layers_outlined),
                    _CrumbArrow(),
                    _Crumb('Aisle 4', Icons.view_week_outlined),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Rack Matrix =====
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.grid_view_rounded,
                        size: 17, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rack 02 Matrix',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Aisle 4 West Face • Standard Pallet & Bin Grid',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '9 Bins\nTotal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8.5,
                          height: 1.3,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _LevelLabel('LEVEL 3 (TOP TIER)', '3.8m Height'),
                const SizedBox(height: 8),
                _BinRow(cells: _level3),

                const SizedBox(height: 14),
                _LevelLabel('LEVEL 2 (MID REACH)', '2.2m Height'),
                const SizedBox(height: 8),
                _BinRow(cells: _level2),

                const SizedBox(height: 14),
                _LevelLabel('LEVEL 1 (GROUND DECK)', '0.4m Pallet Base'),
                const SizedBox(height: 8),
                _BinRow(cells: _level1),

                const SizedBox(height: 16),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Legend('Occupied', AppColors.primary),
                    _Legend('Empty', AppColors.border),
                    _Legend('Reserved', AppColors.red),
                    _Legend('Selected', AppColors.green),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Bin Details =====
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Shelf/Bin B3 Details',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'SELECTED',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.history_rounded,
                        size: 16, color: AppColors.secondaryText),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Direct Access Rack Bay • Level 3',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.secondaryText,
                  ),
                ),

                const SizedBox(height: 13),

                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(Icons.settings_rounded,
                            size: 20, color: AppColors.secondaryText),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SKU: BEAR-6205-HD',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Heavy-Duty Ball Bearings ...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Supplier: Timken Tech • Lot #8842-X',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                Row(
                  children: [
                    Text(
                      'Current Occupancy',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '280 / 300 Max Capacity  (93.3%)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.933,
                    minHeight: 6,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Text(
                      '20 Units Available Space',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Near Full Capacity',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BIN IDENTIFICATION BARCODE',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.secondaryText,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'BIN-NB-A4-R02-B3',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 11, color: AppColors.green),
                                const SizedBox(width: 4),
                                Text(
                                  'Verified Tag & NFC Linked',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: AppColors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 46,
                        width: 46,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: CustomPaint(painter: _MiniQr()),
                      ),
                    ],
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
                      Icon(Icons.thermostat_rounded,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Ambient 20°C • Dry Shelf Storage • Max 450 k...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_scanner_rounded,
                  size: 19, color: Colors.white),
              label: const Text(
                'Scan to Relocate / Putaway',
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
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.print_outlined,
                  size: 17, color: AppColors.text),
              label: Text(
                'Print Bin Shelf Barcode',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration get _card => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    );

class _Crumb extends StatelessWidget {
  const _Crumb(this.label, this.icon);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _CrumbArrow extends StatelessWidget {
  const _CrumbArrow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.chevron_right_rounded,
          size: 15, color: AppColors.secondaryText),
    );
  }
}

class _LevelLabel extends StatelessWidget {
  const _LevelLabel(this.label, this.height);

  final String label;
  final String height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            color: AppColors.secondaryText,
            letterSpacing: 0.7,
          ),
        ),
        const Spacer(),
        Text(
          height,
          style: TextStyle(
            fontSize: 8.5,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _BinRow extends StatelessWidget {
  const _BinRow({required this.cells});

  final List<BinCell> cells;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: cells
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _Bin(cell: c),
                ),
              ))
          .toList(),
    );
  }
}

class _Bin extends StatelessWidget {
  const _Bin({required this.cell});

  final BinCell cell;

  @override
  Widget build(BuildContext context) {
    late Color bg, border, fg, bar;

    switch (cell.status) {
      case BinStatus.selected:
        bg = AppColors.primaryLight;
        border = AppColors.primary;
        fg = AppColors.primary;
        bar = AppColors.primary;
        break;
      case BinStatus.empty:
        bg = Colors.white;
        border = AppColors.border;
        fg = AppColors.secondaryText;
        bar = AppColors.border;
        break;
      case BinStatus.reserved:
        bg = Colors.white;
        border = AppColors.border;
        fg = AppColors.red;
        bar = AppColors.red;
        break;
      case BinStatus.occupied:
        bg = Colors.white;
        border = AppColors.border;
        fg = AppColors.text;
        bar = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: border,
          width: cell.status == BinStatus.selected ? 1.8 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                cell.code,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: fg,
                ),
              ),
              const Spacer(),
              Text(
                cell.pct,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: cell.status == BinStatus.reserved
                      ? AppColors.red
                      : AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: bar,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            cell.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              fontStyle: cell.status == BinStatus.empty
                  ? FontStyle.italic
                  : FontStyle.normal,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class _MiniQr extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.text;
    const n = 9;
    final cell = size.width / n;
    const pattern = [
      '111101111',
      '100100001',
      '101101101',
      '101100101',
      '100010001',
      '111011111',
      '000110100',
      '101001011',
      '111010111',
    ];
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if (pattern[r][c] == '1') {
          canvas.drawRect(
              Rect.fromLTWH(c * cell, r * cell, cell, cell), p);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}