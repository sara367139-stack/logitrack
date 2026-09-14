
import 'package:flutter/material.dart';

import 'package:logitrack/core/constants/app_constants.dart';
import 'package:logitrack/core/routing/app_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _badge = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pin = TextEditingController();
  final _confirmPin = TextEditingController();

  int _role = 0;
  int _warehouse = 0;

  bool _obscurePin = true;
  bool _obscureConfirm = true;
  bool _agree = false;

  static const List<(String, IconData)> _roles = [
    ('Operator', Icons.person_outline_rounded),
    ('Technician', Icons.build_outlined),
    ('Supervisor', Icons.verified_user_outlined),
  ];

  static const List<String> _warehouses = [
    'WH-North Bay Hub',
    'WH-East Annex',
    'WH-South Depot',
  ];

  @override
  void initState() {
    super.initState();

    _pin.addListener(_onPinChanged);
    _confirmPin.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pin.removeListener(_onPinChanged);
    _confirmPin.removeListener(_onPinChanged);

    _name.dispose();
    _badge.dispose();
    _email.dispose();
    _phone.dispose();
    _pin.dispose();
    _confirmPin.dispose();

    super.dispose();
  }

  bool get _isPinValid {
    return RegExp(r'^\d{6}$').hasMatch(_pin.text);
  }

  bool get _pinsMatch {
    return _pin.text.isNotEmpty &&
        _pin.text == _confirmPin.text;
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms to continue'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _SuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 46,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 16,
                color: AppColors.text,
              ),
            ),
          ),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            24,
          ),
          children: [
            // ================= Header =================
            Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register New Technician',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Request terminal access for warehouse operations',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ================= Personal Information =================
            _Section(
              icon: Icons.badge_outlined,
              title: 'Personal Information',
              children: [
                const _Label(
                  'FULL NAME',
                  required: true,
                ),
                TextFormField(
                  controller: _name,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Sarah Jenkins',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      size: 19,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().length < 3) {
                      return 'Enter your full name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                const _Label(
                  'BADGE ID',
                  required: true,
                ),
                TextFormField(
                  controller: _badge,
                  textCapitalization:
                      TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'e.g. WH-OP-8924',
                    prefixIcon: Icon(
                      Icons.qr_code_2_rounded,
                      size: 19,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Badge ID is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                const _Label(
                  'WORK EMAIL',
                  required: true,
                ),
                TextFormField(
                  controller: _email,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'name@company.com',
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      size: 19,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Email is required';
                    }

                    final email = value.trim();

                    final emailRegex = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    );

                    if (!emailRegex.hasMatch(email)) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                const _Label('PHONE NUMBER'),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '+20 100 000 0000',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= Role & Warehouse =================
            _Section(
              icon: Icons.work_outline_rounded,
              title: 'Role & Assignment',
              children: [
                const _Label(
                  'SELECT ROLE',
                  required: true,
                ),

                const SizedBox(height: 2),

                Row(
                  children: List.generate(
                    _roles.length,
                    (index) {
                      final selected = index == _role;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index <
                                    _roles.length - 1
                                ? 9
                                : 0,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _role = index;
                              });
                            },
                            borderRadius:
                                BorderRadius.circular(11),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primaryLight
                                    : AppColors.background,
                                borderRadius:
                                    BorderRadius.circular(11),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width:
                                      selected ? 1.6 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _roles[index].$2,
                                    size: 19,
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors
                                            .secondaryText,
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    _roles[index].$1,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight:
                                          FontWeight.w900,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors
                                              .secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                const _Label(
                  'ASSIGNED WAREHOUSE',
                  required: true,
                ),

                Container(
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F9),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _warehouse,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: AppColors.secondaryText,
                      ),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                      items: List.generate(
                        _warehouses.length,
                        (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.warehouse_outlined,
                                  size: 16,
                                  color:
                                      AppColors.primary,
                                ),
                                const SizedBox(width: 9),
                                Text(_warehouses[index]),
                              ],
                            ),
                          );
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          _warehouse = value ?? 0;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= Security =================
            _Section(
              icon: Icons.lock_outline_rounded,
              title: 'Security PIN',
              children: [
                const _Label(
                  'CREATE PIN (6 DIGITS)',
                  required: true,
                ),

                TextFormField(
                  controller: _pin,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '••••••',
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 19,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePin =
                              !_obscurePin;
                        });
                      },
                      icon: Icon(
                        _obscurePin
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 19,
                        color:
                            AppColors.secondaryText,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^\d{6}$')
                            .hasMatch(value)) {
                      return 'PIN must be exactly 6 digits';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                const _Label(
                  'CONFIRM PIN',
                  required: true,
                ),

                TextFormField(
                  controller: _confirmPin,
                  obscureText: _obscureConfirm,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '••••••',
                    prefixIcon: const Icon(
                      Icons.lock_reset_rounded,
                      size: 19,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirm =
                              !_obscureConfirm;
                        });
                      },
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 19,
                        color:
                            AppColors.secondaryText,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Please confirm your PIN';
                    }

                    if (value != _pin.text) {
                      return 'PINs do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        BorderRadius.circular(11),
                  ),
                  child: Column(
                    children: [
                      _Rule(
                        'At least 6 digits',
                        _isPinValid,
                      ),
                      const SizedBox(height: 8),
                      _Rule(
                        'PINs match',
                        _pinsMatch,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ================= Terms =================
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 22,
                  width: 22,
                  child: Checkbox(
                    value: _agree,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _agree = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.6,
                        color:
                            AppColors.secondaryText,
                      ),
                      children: const [
                        TextSpan(
                          text: 'I agree to the ',
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w900,
                            color:
                                AppColors.primary,
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                        ),
                        TextSpan(
                          text:
                              'Warehouse Safety Policy',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w900,
                            color:
                                AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================= Submit =================
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(
                  Icons.check_rounded,
                  size: 19,
                  color: Colors.white,
                ),
                label: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= Sign In =================
            Center(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 12.5,
                      color:
                          AppColors.secondaryText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .maybePop();
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            FontWeight.w900,
                        color:
                            AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= Approval Info =================
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color:
                          AppColors.secondaryText,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Account requires supervisor approval',
                      style: TextStyle(
                        fontSize: 10.5,
                        color:
                            AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Section Widget
// ============================================================

class _Section extends StatelessWidget {
  const _Section({
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color:
                      AppColors.primaryLight,
                  borderRadius:
                      BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color:
                      AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w900,
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

// ============================================================
// Label Widget
// ============================================================

class _Label extends StatelessWidget {
  const _Label(
    this.text, {
    this.required = false,
  });

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              fontWeight:
                  FontWeight.w900,
              letterSpacing: 0.7,
              color:
                  AppColors.secondaryText,
            ),
          ),
          if (required) ...[
            const SizedBox(width: 3),
            const Text(
              '*',
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w900,
                color: AppColors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// PIN Rule Widget
// ============================================================

class _Rule extends StatelessWidget {
  const _Rule(
    this.text,
    this.ok,
  );

  final String text;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          ok
              ? Icons.check_circle_rounded
              : Icons.circle_outlined,
          size: 15,
          color: ok
              ? AppColors.green
              : AppColors.secondaryText,
        ),
        const SizedBox(width: 9),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight:
                FontWeight.w700,
            color: ok
                ? AppColors.text
                : AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// Success Dialog
// ============================================================

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: AppColors.green
                    .withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 34,
                color:
                    AppColors.green,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Account Created',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
                color:
                    AppColors.text,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Your ${AppConstants.appName} account has been submitted for supervisor approval. You will be notified once activated.',
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.6,
                color:
                    AppColors.secondaryText,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                    AppRouter.login,
                    (route) => false,
                  );
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
                child: const Text(
                  'Back to Sign In',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppColors {
  static const primary = Color(0xFF0D5BDD);
  static const primaryLight = Color(0xFFE8F0FF);
  static const background = Color(0xFFF6F8FC);
  static const text = Color(0xFF10233F);
  static const secondaryText = Color(0xFF718096);
  static const border = Color(0xFFE3EAF3);
  static const green = Color(0xFF0AA879);
  static const orange = Color(0xFFF2A900);
  static const red = Color(0xFFE64B4B);
}
