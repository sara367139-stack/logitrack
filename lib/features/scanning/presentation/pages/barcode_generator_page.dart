import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

class BarcodeGeneratorPage extends StatefulWidget {
  const BarcodeGeneratorPage({super.key});

  @override
  State<BarcodeGeneratorPage> createState() => _BarcodeGeneratorPageState();
}

class _BarcodeGeneratorPageState extends State<BarcodeGeneratorPage> {
  int _symbology = 0;
  int _template = 0;
  int _volume = 25;

  static const _symbologies = ['Code-128 (1D)', 'QR Code (2D)', 'DataMatrix'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: _Sq(Icons.arrow_back_rounded,
              () => Navigator.of(context).maybePop()),
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
          _Sq(Icons.refresh_rounded, () {}),
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
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
        children: [
          // ===== Title =====
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'PRINT OPS V4.2',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                    color: AppColors.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.circle, size: 7, color: AppColors.primary),
                  const SizedBox(width: 5),
                  Text(
                    'Mobile Spooler Ready',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Barcode & QR Code Generator',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Instantly formulate & spool high-density thermal adhesive tags for bin locations, pallets, and SKU stock tracking.',
            style: TextStyle(
              fontSize: 11.5,
              height: 1.5,
              color: AppColors.secondaryText,
            ),
          ),

          const SizedBox(height: 18),

          // ===== Symbology =====
          const _Label('SYMBOLOGY FORMAT'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: List.generate(_symbologies.length, (i) {
                final sel = i == _symbology;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _symbology = i),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 5,
                                )
                              ]
                            : null,
                      ),
                      child: Text(
                        _symbologies[i],
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color:
                              sel ? AppColors.text : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // ===== Preset Template =====
          const _Label('PRESET TEMPLATE'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _TemplateBox(
                  icon: Icons.inventory_2_outlined,
                  label: 'Product SKU',
                  active: _template == 0,
                  onTap: () => setState(() => _template = 0),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _TemplateBox(
                  icon: Icons.grid_view_rounded,
                  label: 'Bin Location',
                  active: _template == 1,
                  onTap: () => setState(() => _template = 1),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _TemplateBox(
                  icon: Icons.layers_outlined,
                  label: 'Pallet SSCC',
                  active: _template == 2,
                  onTap: () => setState(() => _template = 2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===== Payload =====
          Row(
            children: [
              const _Label('PAYLOAD STRING'),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.autorenew_rounded,
                      size: 12, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Auto-Gen',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code_2_rounded,
                    size: 15, color: AppColors.secondaryText),
                const SizedBox(width: 8),
                Text(
                  'BEAR-6205-HD-LOT2025',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          const _Label('SUBTITLE & FLOOR ROUTING'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.notes_rounded,
                    size: 15, color: AppColors.secondaryText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Heavy-Duty Ball Bearings | North Bay Hub',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== Print Preview =====
          Row(
            children: [
              Icon(Icons.print_outlined,
                  size: 17, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Thermal Print Preview',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              Text(
                '4.0" × 2.0" Roll',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // Label preview
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.text, width: 1.4),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.local_shipping_rounded,
                        size: 13, color: AppColors.text),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LogiTrack ',
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          'AEROSPACE GRADE #42',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.text,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'AISLE 04 • BIN 14',
                        style: TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.circle, size: 7, color: AppColors.primary),
                  ],
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: 62,
                  width: double.infinity,
                  child: CustomPaint(painter: _BarPainter()),
                ),
                const SizedBox(height: 7),
                Text(
                  '*BEAR-6205-HD-LOT2025*',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 14),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Heavy-Duty Ball Bearings | North B...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'LOT: 2025-Q1 • EXP: 11/2029',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'NET WEIGHT',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '14.82 KG',
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
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ===== Printer =====
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.bluetooth_rounded,
                      size: 18, color: Colors.white),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zebra ZD621 Thermal',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: AppColors.green),
                          const SizedBox(width: 4),
                          Text(
                            '98% Signal • 4×2 in. Roll (340 rem.)',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.refresh_rounded,
                    size: 17, color: AppColors.secondaryText),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ===== Volume =====
          Row(
            children: [
              Text(
                'Print Volume',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _VolBtn(Icons.remove_rounded,
                        () => setState(() => _volume = (_volume - 1).clamp(1, 999))),
                    Container(
                      width: 44,
                      alignment: Alignment.center,
                      child: Text(
                        '$_volume',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    _VolBtn(Icons.add_rounded,
                        () => setState(() => _volume++)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.print_rounded,
                  size: 19, color: Colors.white),
              label: Text(
                'Spool & Print $_volume Labels',
                style: const TextStyle(
                  fontSize: 15,
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

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.description_outlined,
                        size: 16, color: AppColors.text),
                    label: Text(
                      'Export Vector PDF',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 48,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(Icons.ios_share_rounded,
                    size: 18, color: AppColors.text),
              ),
            ],
          ),
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
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.7,
        color: AppColors.secondaryText,
      ),
    );
  }
}

class _Sq extends StatelessWidget {
  const _Sq(this.icon, this.onTap);

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
        child: Icon(icon, size: 17, color: AppColors.text),
      ),
    );
  }
}

class _TemplateBox extends StatelessWidget {
  const _TemplateBox({
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : AppColors.background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 19,
                color: active ? AppColors.primary : AppColors.secondaryText),
            const SizedBox(height: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                color: active ? AppColors.primary : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolBtn extends StatelessWidget {
  const _VolBtn(this.icon, this.onTap);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        width: 38,
        child: Icon(icon, size: 18, color: AppColors.text),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = AppColors.text;
    final w = [2.0, 1.0, 3.0, 1.5, 2.5, 1.0, 4.0, 1.5, 2.0, 3.5, 1.0, 2.5];

    double x = 2;
    int i = 0;
    while (x < size.width - 4) {
      final bw = w[i % w.length];
      canvas.drawRect(Rect.fromLTWH(x, 0, bw, size.height), p);
      x += bw + w[(i + 5) % w.length];
      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}