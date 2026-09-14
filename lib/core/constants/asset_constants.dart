class AppImages {
  AppImages._();

  static const String _base = 'assets/images/onboarding';

  static const String smartInventory = '$_base/smart_inventory.png';
  static const String scanProducts = '$_base/scan_products.png';
  static const String trackWarehouse = '$_base/track_warehouse.png';

  /// كل صور الـ onboarding بالترتيب
  static const List<String> onboarding = [
    smartInventory,
    scanProducts,
    trackWarehouse,
  ];
}