import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

/// Shimmer بسيط بدون مكتبات خارجية
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE9EEF5),
                Color(0xFFF6F8FC),
                Color(0xFFE9EEF5),
              ],
              stops: [
                (_c.value - 0.3).clamp(0.0, 1.0),
                _c.value.clamp(0.0, 1.0),
                (_c.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.height = 14,
    this.width,
    this.radius = 6,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// كارت منتج وهمي أثناء التحميل
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(height: 54, width: 54, radius: 11),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ShimmerBox(height: 16, width: 90),
                          const Spacer(),
                          const ShimmerBox(height: 12, width: 55),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const ShimmerBox(height: 11, width: 110),
                      const SizedBox(height: 8),
                      const ShimmerBox(height: 15, width: double.infinity),
                      const SizedBox(height: 7),
                      const ShimmerBox(height: 12, width: 70),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const ShimmerBox(height: 5, width: double.infinity, radius: 10),
            const SizedBox(height: 14),
            Row(
              children: const [
                ShimmerBox(height: 11, width: 140),
                Spacer(),
                ShimmerBox(height: 11, width: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ليست كاملة من الـ skeletons
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 11),
      itemBuilder: (_, __) => const ProductCardSkeleton(),
    );
  }
}