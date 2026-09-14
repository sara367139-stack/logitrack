import 'package:flutter/material.dart';
import 'package:logitrack/core/routing/app_shell.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/brand_mark.dart';

class SplashLoginPage extends StatefulWidget {
  const SplashLoginPage({super.key});

  @override
  State<SplashLoginPage> createState() => _SplashLoginPageState();
}

class _SplashLoginPageState extends State<SplashLoginPage> {
  bool rememberDevice = true;
  bool obscurePin = true;

  void _login() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const AppShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: Column(
                    children: [
                      _topBar(),
                      const SizedBox(height: 27),
                      const BrandMark(size: 58),
                      const SizedBox(height: 12),
                      Text(
                        'LogiTrack',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enterprise Inventory & Warehouse Mobility',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _warehouseBanner(),
                      const SizedBox(height: 16),
                      _loginCard(),
                      const SizedBox(height: 18),
                      _serverStatus(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        const BrandMark(size: 28),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'WH-North Bay Hub',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'EN | SA AR',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        CircleAvatar(
          radius: 15,
          backgroundColor: const Color(0xFFE3ECFA),
          child: Icon(
            Icons.person_rounded,
            size: 17,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _warehouseBanner() {
    return Container(
      height: 94,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF243A50),
            Color(0xFF5E7889),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SHIFT 1 · MORNING OPERATIONS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Terminal Ready for Inbound',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.warehouse_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terminal Sign In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Scan badge or enter technician credentials.',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Badge ID or Operator Email',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                Text(
                  'Auto-detect',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const TextField(
              decoration: InputDecoration(
                hintText: 'e.g. WH-OP-8924',
                prefixIcon: Icon(
                  Icons.badge_outlined,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Text(
                  'Security Passcode / PIN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                Text(
                  'Forgot PIN?',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextField(
              obscureText: obscurePin,
              decoration: InputDecoration(
                hintText: 'Enter PIN',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePin = !obscurePin;
                    });
                  },
                  icon: Icon(
                    obscurePin
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: rememberDevice,
                    onChanged: (value) {
                      setState(() {
                        rememberDevice = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Remember terminal assignment on this handheld device',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _login,
                icon: const Icon(
                  Icons.login_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Sign In to Terminal',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Center(
              child: Text(
                'ALTERNATIVE METHOD',
                style: TextStyle(
                  fontSize: 8,
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Or Scan Staff Badge',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serverStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle,
            size: 7,
            color: AppColors.green,
          ),
          const SizedBox(width: 7),
          Text(
            'Server: Online · Sync: 12ms · v4.8.2',
            style: TextStyle(
              fontSize: 9,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}