import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:logitrack/core/theme/app_theme.dart';

class CameraScanner extends StatefulWidget {
  const CameraScanner({
    super.key,
    required this.onDetect,
    this.height = 190,
    this.cooldown = const Duration(seconds: 2),
    this.enableHaptic = true,
  });

  final ValueChanged<String> onDetect;
  final double height;
  final Duration cooldown;
  final bool enableHaptic;

  @override
  State<CameraScanner> createState() => _CameraScannerState();
}

class _CameraScannerState extends State<CameraScanner>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  MobileScannerController? _controller;
  late final AnimationController _anim;

  bool _torch = false;
  bool _hasError = false;
  bool _paused = false;
  String? _lastCode;

  bool get _unsupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  // ==================== Lifecycle ====================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _initCamera();
  }

  void _initCamera() {
    if (_unsupportedPlatform) {
      _hasError = true;
      return;
    }

    try {
      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        formats: const [
          BarcodeFormat.qrCode,
          BarcodeFormat.code128,
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.code39,
          BarcodeFormat.dataMatrix,
        ],
      );
    } catch (_) {
      _hasError = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || _hasError) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (!_paused) _controller!.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _controller!.stop();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _anim.dispose();
    _controller?.dispose();
    super.dispose();
  }

  // ==================== Actions ====================

  void _handle(BarcodeCapture cap) {
    if (_paused || cap.barcodes.isEmpty) return;

    final code = cap.barcodes.first.rawValue;
    if (code == null || code.isEmpty || code == _lastCode) return;

    _lastCode = code;

    if (widget.enableHaptic && !kIsWeb) {
      HapticFeedback.mediumImpact();
    }

    widget.onDetect(code);

    Future.delayed(widget.cooldown, () {
      if (mounted) _lastCode = null;
    });
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller?.toggleTorch();
      if (mounted) setState(() => _torch = !_torch);
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    try {
      await _controller?.switchCamera();
    } catch (_) {}
  }

  Future<void> _togglePause() async {
    if (_controller == null) return;
    try {
      _paused ? await _controller!.start() : await _controller!.stop();
      if (mounted) setState(() => _paused = !_paused);
    } catch (_) {}
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _lastCode = null;
    });
    _controller?.dispose();
    _initCamera();
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF15202F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // ==================== Camera ====================
          if (!_hasError && _controller != null)
            MobileScanner(
              controller: _controller!,
              onDetect: _handle,
              errorBuilder: (context, error, stackTrace) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _hasError = true);
                });
                return const SizedBox.shrink();
              },
            )
          else
            _ErrorView(
              onRetry: _retry,
              unsupportedPlatform: _unsupportedPlatform,
            ),

          // ==================== Dim overlay when paused ====================
          if (_paused && !_hasError)
            Container(
              color: Colors.black.withOpacity(0.55),
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pause_circle_outline_rounded,
                      size: 38, color: Colors.white70),
                  SizedBox(height: 8),
                  Text(
                    'Scanner paused',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

          // ==================== Top bar ====================
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: _hasError
                            ? AppColors.red
                            : _paused
                                ? AppColors.orange
                                : AppColors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _hasError
                            ? 'CAMERA OFF'
                            : _paused
                                ? 'PAUSED'
                                : 'SCANNER ACTIVE',
                        style: const TextStyle(
                          fontSize: 8.5,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (!_hasError) ...[
                  if (!kIsWeb) ...[
                    _CamBtn(
                      icon: _torch
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      active: _torch,
                      onTap: _toggleTorch,
                    ),
                    const SizedBox(width: 7),
                  ],
                  _CamBtn(
                    icon: _paused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    onTap: _togglePause,
                  ),
                  const SizedBox(width: 7),
                  _CamBtn(
                    icon: Icons.cameraswitch_rounded,
                    onTap: _switchCamera,
                  ),
                ],
              ],
            ),
          ),

          // ==================== Frame ====================
          if (!_hasError)
            Center(
              child: SizedBox(
                width: 210,
                height: 105,
                child: CustomPaint(
                  painter: _FramePainter(
                    color: _paused
                        ? Colors.white38
                        : AppColors.primary,
                  ),
                ),
              ),
            ),

          // ==================== Scan line ====================
          if (!_hasError && !_paused)
            Center(
              child: AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, (_anim.value - 0.5) * 90),
                  child: Container(
                    width: 200,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0),
                          AppColors.primary,
                          AppColors.primary.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ==================== Hint ====================
          if (!_hasError && !_paused)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Align barcode within frame',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== Widgets ====================

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry, this.unsupportedPlatform = false});

  final VoidCallback onRetry;
  final bool unsupportedPlatform;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.no_photography_outlined,
              size: 34, color: Colors.white38),
          const SizedBox(height: 10),
          const Text(
            'Camera unavailable',
            style: TextStyle(fontSize: 11, color: Colors.white54),
          ),
          const SizedBox(height: 4),
          Text(
            unsupportedPlatform
                ? 'Scanning is available on Android and iOS'
                : kIsWeb
                ? 'Allow camera access in your browser'
                : 'Check camera permissions in settings',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: Colors.white38),
          ),
          const SizedBox(height: 14),
          if (!unsupportedPlatform)
            InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
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

class _CamBtn extends StatelessWidget {
  const _CamBtn({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: active
              ? AppColors.orange.withOpacity(0.85)
              : Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15, color: Colors.white),
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  _FramePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const len = 24.0;

    // Top-left
    canvas.drawLine(const Offset(0, len), Offset.zero, p);
    canvas.drawLine(Offset.zero, const Offset(len, 0), p);

    // Top-right
    canvas.drawLine(Offset(size.width - len, 0), Offset(size.width, 0), p);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), p);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height - len), Offset(0, size.height), p);
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), p);

    // Bottom-right
    canvas.drawLine(
      Offset(size.width, size.height - len),
      Offset(size.width, size.height),
      p,
    );
    canvas.drawLine(
      Offset(size.width - len, size.height),
      Offset(size.width, size.height),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _FramePainter old) => old.color != color;
}