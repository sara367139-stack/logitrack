class Validators {
  Validators._();

  // ===== Generic =====
  static String? required(String? v, [String field = 'This field']) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? minLength(String? v, int min, [String field = 'Field']) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    if (v.trim().length < min) return '$field must be at least $min chars';
    return null;
  }

  // ===== Auth =====
  static String? badge(String? v) {
    if (v == null || v.trim().isEmpty) return 'Badge ID is required';
    if (v.trim().length < 4) return 'Badge ID is too short';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final re = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!re.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? emailOrBadge(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Badge ID or email is required';
    }
    if (v.contains('@')) return email(v);
    return badge(v);
  }

  static String? pin(String? v) {
    if (v == null || v.trim().isEmpty) return 'PIN is required';
    if (v.length < 6) return 'PIN must be 6 digits';
    if (!RegExp(r'^\d+$').hasMatch(v)) return 'PIN must be numbers only';
    return null;
  }

  static String? confirmPin(String? v, String original) {
    if (v == null || v.isEmpty) return 'Please confirm your PIN';
    if (v != original) return 'PINs do not match';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    if (v.trim().length < 8) return 'Enter a valid phone number';
    return null;
  }

  // ===== Product =====
  static String? sku(String? v) {
    if (v == null || v.trim().isEmpty) return 'SKU is required';
    if (v.trim().length < 4) return 'SKU is too short';
    return null;
  }

  static String? price(String? v) {
    if (v == null || v.trim().isEmpty) return 'Price is required';
    final n = double.tryParse(v.trim());
    if (n == null) return 'Enter a valid number';
    if (n <= 0) return 'Price must be greater than 0';
    return null;
  }

  static String? quantity(String? v, {bool allowZero = true}) {
    if (v == null || v.trim().isEmpty) return 'Quantity is required';
    final n = int.tryParse(v.trim());
    if (n == null) return 'Enter a whole number';
    if (!allowZero && n <= 0) return 'Must be greater than 0';
    if (n < 0) return 'Cannot be negative';
    return null;
  }

  static String? optionalNumber(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
    return null;
  }
}