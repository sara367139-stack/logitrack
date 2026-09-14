import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logitrack/core/services/storage_service.dart';
import 'package:logitrack/core/theme/app_theme.dart';
import 'package:logitrack/core/utils/validators.dart';
import 'package:logitrack/core/widgets/app_dialog.dart';
import 'package:logitrack/core/widgets/app_snackbar.dart';

class ForgotPinPage extends StatefulWidget {
  const ForgotPinPage({super.key});

  @override
  State<ForgotPinPage> createState() => _ForgotPinPageState();
}

class _ForgotPinPageState extends State<ForgotPinPage> {
  final _formKey = GlobalKey<FormState>();

  final _newPin = TextEditingController();
  final _confirmPin = TextEditingController();

  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpNodes = List.generate(6, (_) => FocusNode());

  int _step = 0;
  int _method = 0;
  bool _loading = false;

  Timer? _timer;
  int _seconds = 60;

  // ==================== Lifecycle ====================

  @override
  void dispose() {
    _timer?.cancel();
    _newPin.dispose();
    _confirmPin.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final n in _otpNodes) {
      n.dispose();
    }
    super.dispose();
  }

  // ==================== Helpers ====================

  String get _otp => _otpCtrls.map((c) => c.text).join();

  String get _maskedEmail {
    final badge = StorageService.userBadge.toLowerCase();
    final first = badge.isNotEmpty ? badge[0] : 's';
    return '$first••••••@logitrack.com';
  }

  String get _methodLabel => switch (_method) {
        0 => _maskedEmail,
        1 => '+1 (•••) •••-8891',
        _ => 'WH-Supervisor',
      };

  // ignore: unused_element
  bool get _pinValid =>
      _newPin.text.length >= 6 &&
      _newPin.text == _confirmPin.text &&
      !_isSequential(_newPin.text) &&
      _newPin.text != StorageService.userBadge;

  bool _isSequential(String s) {
    if (s.length < 2) return false;
    var asc = true, desc = true;
    for (var i = 1; i < s.length; i++) {
      final prev = int.tryParse(s[i - 1]);
      final curr = int.tryParse(s[i]);
      if (prev == null || curr == null) return false;
      if (curr != prev + 1) asc = false;
      if (curr != prev - 1) desc = false;
    }
    return asc || desc;
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        if (mounted) setState(() => _seconds = 0);
      } else {
        if (mounted) setState(() => _seconds--);
      }
    });
  }

  String get _timerLabel {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // ==================== Actions ====================

  Future<void> _next() async {
    FocusScope.of(context).unfocus();

    // Step 0 → إرسال الكود
    if (_step == 0) {
      if (_method == 2) {
        final ok = await AppDialog.confirm(
          context,
          title: 'Request supervisor override?',
          message:
              'A reset request will be sent to your warehouse supervisor for approval.',
          confirmLabel: 'Send Request',
          icon: Icons.badge_outlined,
        );
        if (!ok || !mounted) return;

        AppSnackBar.success(context, 'Request sent to supervisor');
        Navigator.of(context).pop();
        return;
      }

      setState(() => _loading = true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _step = 1;
      });
      _startTimer();
      AppSnackBar.success(context, 'Code sent to $_methodLabel');
      return;
    }

    // Step 1 → التحقق من الكود
    if (_step == 1) {
      if (_otp.length < 6) {
        AppSnackBar.error(context, 'Enter the full 6-digit code');
        return;
      }

      setState(() => _loading = true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _step = 2;
      });
      _timer?.cancel();
      return;
    }

    // Step 2 → تحديث الـ PIN
    if (!_formKey.currentState!.validate()) {
      AppSnackBar.error(context, 'Please fix the highlighted fields');
      return;
    }

    if (_isSequential(_newPin.text)) {
      AppSnackBar.error(context, 'PIN cannot be sequential numbers');
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);

    await AppDialog.success(
      context,
      title: 'PIN Updated',
      message:
          'Your terminal PIN has been changed successfully. Use it on your next sign-in.',
      buttonLabel: 'Back to Sign In',
      onDone: () => Navigator.of(context).pop(),
    );
  }

  void _resend() {
    if (_seconds > 0) return;
    for (final c in _otpCtrls) {
      c.clear();
    }
    _otpNodes.first.requestFocus();
    _startTimer();
    AppSnackBar.info(context, 'New code sent');
  }

  void _onOtpChanged(int i, String v) {
    if (v.isNotEmpty && i < 5) {
      _otpNodes[i + 1].requestFocus();
    } else if (v.isEmpty && i > 0) {
      _otpNodes[i - 1].requestFocus();
    }
    setState(() {});
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: _loading
                ? null
                : () => _step == 0
                    ? Navigator.of(context).pop()
                    : setState(() => _step--),
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(Icons.arrow_back_rounded,
                  size: 16, color: AppColors.text),
            ),
          ),
        ),
        title: Text(
          switch (_step) {
            0 => 'Reset PIN',
            1 => 'Verify Identity',
            _ => 'New PIN',
          },
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(38),
          child: Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: [
                _Dot(0, _step),
                _Ln(_step > 0),
                _Dot(1, _step),
                _Ln(_step > 1),
                _Dot(2, _step),
              ],
            ),
          ),
        ),
      ),
      body: switch (_step) {
        0 => _stepMethod(),
        1 => _stepOtp(),
        _ => _stepNewPin(),
      },
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        color: AppColors.surface,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _loading ? null : _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.55),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      switch (_step) {
                        0 => _method == 2
                            ? 'Request Override'
                            : 'Send Verification Code',
                        1 => 'Verify Code',
                        _ => 'Update PIN',
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Step 1 — Method ====================

  Widget _stepMethod() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.lock_reset_rounded,
              size: 30, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        Text(
          'Forgot your PIN?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose how you want to receive your verification code. We'll send a 6-digit code to confirm your identity.",
          style: TextStyle(
            fontSize: 12.5,
            height: 1.7,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 26),

        _MethodCard(
          icon: Icons.mail_outline_rounded,
          title: 'Work Email',
          sub: _maskedEmail,
          active: _method == 0,
          onTap: _loading ? null : () => setState(() => _method = 0),
        ),
        const SizedBox(height: 11),
        _MethodCard(
          icon: Icons.sms_outlined,
          title: 'SMS to Phone',
          sub: '+1 (•••) •••-8891',
          active: _method == 1,
          onTap: _loading ? null : () => setState(() => _method = 1),
        ),
        const SizedBox(height: 11),
        _MethodCard(
          icon: Icons.badge_outlined,
          title: 'Supervisor Override',
          sub: 'Request PIN reset from WH-Supervisor',
          active: _method == 2,
          onTap: _loading ? null : () => setState(() => _method = 2),
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.orange.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.orange.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 17, color: AppColors.orange),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Terminal will lock for 15 minutes after 3 failed attempts.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.5,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== Step 2 — OTP ====================

  Widget _stepOtp() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.mark_email_read_outlined,
              size: 30, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        Text(
          'Enter verification code',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a 6-digit code to $_methodLabel. It expires in 10 minutes.',
          style: TextStyle(
            fontSize: 12.5,
            height: 1.7,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 28),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) {
            final filled = _otpCtrls[i].text.isNotEmpty;
            // ignore: unused_local_variable
            final focused = _otpNodes[i].hasFocus;

            return SizedBox(
              height: 56,
              width: 48,
              child: TextField(
                controller: _otpCtrls[i],
                focusNode: _otpNodes[i],
                enabled: !_loading,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                autofocus: i == 0,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (v) => _onOtpChanged(i, v),
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: filled
                      ? AppColors.primaryLight
                      : AppColors.background,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: filled ? AppColors.primary : AppColors.border,
                      width: filled ? 1.6 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.8,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive it? ",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
              GestureDetector(
                onTap: _seconds == 0 ? _resend : null,
                child: Text(
                  _seconds == 0 ? 'Resend code' : 'Resend in $_timerLabel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _seconds == 0
                        ? AppColors.primary
                        : AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== Step 3 — New PIN ====================

  Widget _stepNewPin() {
    final len6 = _newPin.text.length >= 6;
    final match =
        _newPin.text.isNotEmpty && _newPin.text == _confirmPin.text;
    final notSeq = _newPin.text.isNotEmpty && !_isSequential(_newPin.text);
    final notBadge = _newPin.text.isNotEmpty &&
        _newPin.text != StorageService.userBadge;

    return Form(
      key: _formKey,
      onChanged: () => setState(() {}),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.password_rounded,
                size: 30, color: AppColors.green),
          ),
          const SizedBox(height: 20),
          Text(
            'Set your new PIN',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a 6-digit PIN you can enter quickly with gloves on.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.7,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 26),

          const _L('NEW PIN'),
          TextFormField(
            controller: _newPin,
            enabled: !_loading,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.pin,
            decoration: const InputDecoration(
              counterText: '',
              hintText: '••••••',
              prefixIcon: Icon(Icons.lock_outline_rounded, size: 19),
            ),
          ),

          const SizedBox(height: 16),

          const _L('CONFIRM NEW PIN'),
          TextFormField(
            controller: _confirmPin,
            enabled: !_loading,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => Validators.confirmPin(v, _newPin.text),
            decoration: const InputDecoration(
              counterText: '',
              hintText: '••••••',
              prefixIcon: Icon(Icons.lock_reset_rounded, size: 19),
            ),
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _Rule('At least 6 digits', len6),
                const SizedBox(height: 9),
                _Rule('Both PINs match', match),
                const SizedBox(height: 9),
                _Rule('No sequential numbers (123456)', notSeq),
                const SizedBox(height: 9),
                _Rule('Not your badge number', notBadge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Widgets ====================

class _Dot extends StatelessWidget {
  const _Dot(this.index, this.current);

  final int index;
  final int current;

  @override
  Widget build(BuildContext context) {
    final done = index <= current;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 22,
      width: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: done ? AppColors.primary : AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: done ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: index < current
          ? const Icon(Icons.check, size: 12, color: Colors.white)
          : Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: done ? Colors.white : AppColors.secondaryText,
              ),
            ),
    );
  }
}

class _Ln extends StatelessWidget {
  const _Ln(this.done);

  final bool done;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: done ? AppColors.primary : AppColors.border,
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
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
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : AppColors.background,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(11),
                border: active ? null : Border.all(color: AppColors.border),
              ),
              child: Icon(
                icon,
                size: 19,
                color: active ? Colors.white : AppColors.secondaryText,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              active
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 19,
              color: active ? AppColors.primary : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}

class _L extends StatelessWidget {
  const _L(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.7,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule(this.text, this.ok);

  final String text;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            ok ? Icons.check_circle_rounded : Icons.circle_outlined,
            key: ValueKey(ok),
            size: 15,
            color: ok ? AppColors.green : AppColors.secondaryText,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ok ? AppColors.text : AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}