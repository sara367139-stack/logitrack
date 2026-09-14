import 'package:flutter/material.dart';
import 'package:logitrack/core/services/storage_service.dart';
import 'package:logitrack/core/routing/app_shell.dart';

// Auth & Onboarding
import 'package:logitrack/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:logitrack/features/auth/presentation/pages/login_page.dart';
import 'package:logitrack/features/auth/presentation/pages/register_page.dart';

// Products
import 'package:logitrack/features/products/presentation/pages/product_details_page.dart';
import 'package:logitrack/features/products/presentation/pages/add_product_page.dart';

// Warehouse
import 'package:logitrack/features/warehouse/presentation/pages/warehouse_locations_page.dart';

// Scanning
import 'package:logitrack/features/scanning/presentation/pages/barcode_generator_page.dart';

// Partners
import 'package:logitrack/features/suppliers/presentation/pages/suppliers_page.dart';
import 'package:logitrack/features/purchase_orders/presentation/pages/purchase_orders_page.dart';

// Notifications
import 'package:logitrack/features/notifications/presentation/pages/notifications_page.dart';
import 'package:logitrack/features/notifications/presentation/pages/floor_feed_page.dart';

// Reports
import 'package:logitrack/features/reports/presentation/pages/asset_valuation_page.dart';

// Profile
import 'package:logitrack/features/profile/presentation/pages/profile_page.dart';
import 'package:logitrack/features/profile/presentation/pages/terminal_profile_page.dart';


//
import 'package:logitrack/features/splash/presentation/pages/splash_page.dart';
import 'package:logitrack/features/products/presentation/pages/search_results_page.dart';
import 'package:logitrack/features/operations/presentation/pages/new_movement_page.dart';
import 'package:logitrack/features/operations/presentation/pages/movement_details_page.dart';
import 'package:logitrack/features/purchase_orders/presentation/pages/create_po_page.dart';
import 'package:logitrack/features/suppliers/presentation/pages/supplier_details_page.dart';
import 'package:logitrack/features/auth/presentation/pages/forgot_pin_page.dart';
class AppRouter {
  AppRouter._();

  // ===== Auth =====
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';

  // ===== Shell Tabs =====
  static const String app = '/app';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String audit = '/audit';
  static const String operations = '/operations';
  static const String reports = '/reports';

  // ===== Sub Pages =====
  static const String productDetails = '/product-details';
  static const String addProduct = '/add-product';
  static const String locations = '/locations';
  static const String barcodeGen = '/barcode-generator';
  static const String suppliers = '/suppliers';
  static const String purchaseOrders = '/purchase-orders';
  static const String notifications = '/notifications';
  static const String floorFeed = '/floor-feed';
  static const String valuation = '/valuation';
  static const String profile = '/profile';
  static const String terminalProfile = '/terminal-profile';

    static const String splash = '/splash';
  static const String search = '/search';
  static const String newMovement = '/new-movement';
  static const String movementDetails = '/movement-details';
  static const String createPo = '/create-po';
  static const String supplierDetails = '/supplier-details';
  static const String forgotPin = '/forgot-pin';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ---------- Onboarding ----------
          case onboarding:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => OnboardingPage(
            onFinished: () async {
              await StorageService.setOnboardingSeen();
              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(login, (r) => false);
            },
            onLogin: () async {
              await StorageService.setOnboardingSeen();
              if (!context.mounted) return;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(login, (r) => false);
            },
          ),
        );

      // ---------- Auth ----------
      case login:
        return _r(const LoginPage(), settings);

      case register:
        return _r(const RegisterPage(), settings);

      // ---------- Shell ----------
      case app:
      case dashboard:
        return _r(const AppShell(initialIndex: 0), settings);

      case products:
        return _r(const AppShell(initialIndex: 1), settings);

      case audit:
        return _r(const AppShell(initialIndex: 2), settings);

      case operations:
        return _r(const AppShell(initialIndex: 3), settings);

      case reports:
        return _r(const AppShell(initialIndex: 4), settings);

      // ---------- Products ----------
      case productDetails:
        return _r(const ProductDetailsPage(), settings);

      case addProduct:
        return _r(const AddProductPage(), settings);

      // ---------- Warehouse ----------
      case locations:
        return _r(const WarehouseLocationsPage(), settings);

      // ---------- Scanning ----------
      case barcodeGen:
        return _r(const BarcodeGeneratorPage(), settings);

      // ---------- Partners ----------
      case suppliers:
        return _r(const SuppliersPage(), settings);

      case purchaseOrders:
        return _r(const PurchaseOrdersPage(), settings);

      // ---------- Notifications ----------
      case notifications:
        return _r(const NotificationsPage(), settings);

      case floorFeed:
        return _r(const FloorFeedPage(), settings);

      // ---------- Reports ----------
      case valuation:
        return _r(const AssetValuationPage(), settings);

      // ---------- Profile ----------
      case profile:
        return _r(const ProfilePage(), settings);

      case terminalProfile:
        return _r(const TerminalProfilePage(), settings);
        

        /// ---------- Misc ----------
              case splash:
        return _r(const SplashPage(), settings);

      case search:
        return _r(const SearchResultsPage(), settings);

      case newMovement:
        return _r(const NewMovementPage(), settings);

      case movementDetails:
        return _r(const MovementDetailsPage(), settings);

      case createPo:
        return _r(const CreatePoPage(), settings);

      case supplierDetails:
        return _r(const SupplierDetailsPage(), settings);

      case forgotPin:
        return _r(const ForgotPinPage(), settings);

      // ---------- 404 ----------
      default:
        return _r(PageNotFound(routeName: settings.name), settings);
    }
  }

  static MaterialPageRoute _r(Widget page, RouteSettings s) =>
      MaterialPageRoute(settings: s, builder: (_) => page);

  static Route<dynamic> unknownRoute(RouteSettings settings) =>
      _r(PageNotFound(routeName: settings.name), settings);
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key, this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Route not found: $routeName'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRouter.app, (r) => false),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}