/// كل نصوص التطبيق في مكان واحد
class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> values = {
    // ==================== COMMON ====================
    'appName': {'en': 'LogiTrack', 'ar': 'لوجي تراك'},
    'appTagline': {
      'en': 'Enterprise Inventory & Warehouse Mobility',
      'ar': 'إدارة المخزون والمستودعات للمؤسسات',
    },
    'cancel': {'en': 'Cancel', 'ar': 'إلغاء'},
    'confirm': {'en': 'Confirm', 'ar': 'تأكيد'},
    'save': {'en': 'Save', 'ar': 'حفظ'},
    'done': {'en': 'Done', 'ar': 'تم'},
    'next': {'en': 'Next', 'ar': 'التالي'},
    'back': {'en': 'Back', 'ar': 'رجوع'},
    'skip': {'en': 'Skip', 'ar': 'تخطي'},
    'search': {'en': 'Search', 'ar': 'بحث'},
    'all': {'en': 'All', 'ar': 'الكل'},
    'details': {'en': 'Details', 'ar': 'التفاصيل'},
    'viewAll': {'en': 'View All', 'ar': 'عرض الكل'},
    'clear': {'en': 'Clear', 'ar': 'مسح'},
    'remove': {'en': 'Remove', 'ar': 'حذف'},
    'discard': {'en': 'Discard', 'ar': 'تجاهل'},
    'units': {'en': 'Units', 'ar': 'وحدة'},
    'items': {'en': 'items', 'ar': 'صنف'},
    'saving': {'en': 'Saving...', 'ar': 'جاري الحفظ...'},
    'loading': {'en': 'Loading...', 'ar': 'جاري التحميل...'},
    'processing': {'en': 'Processing...', 'ar': 'جاري المعالجة...'},

    // ==================== ONBOARDING ====================
    'onb1Title': {
      'en': 'Smart Inventory\nManagement',
      'ar': 'إدارة مخزون\nذكية',
    },
    'onb1Desc': {
      'en':
          'Manage your products and warehouse inventory easily with live stock tracking.',
      'ar': 'أدر منتجاتك ومخزون المستودع بسهولة مع تتبع لحظي للمخزون.',
    },
    'onb2Title': {
      'en': 'Scan Products\nQuickly',
      'ar': 'امسح المنتجات\nبسرعة',
    },
    'onb2Desc': {
      'en':
          'Scan barcodes and update inventory in seconds with laser terminals.',
      'ar': 'امسح الباركود وحدّث المخزون في ثوانٍ بأجهزة الليزر.',
    },
    'onb3Title': {
      'en': 'Track Your\nWarehouse',
      'ar': 'تتبّع\nمستودعك',
    },
    'onb3Desc': {
      'en':
          'Monitor stock, transactions and warehouse performance with real-time analytics.',
      'ar': 'راقب المخزون والمعاملات والأداء بتحليلات لحظية.',
    },
    'getStarted': {'en': 'Get Started', 'ar': 'ابدأ الآن'},
    'stepOf': {'en': 'Step', 'ar': 'الخطوة'},
    'of': {'en': 'of', 'ar': 'من'},
    'alreadyRegistered': {
      'en': 'Already registered technician? ',
      'ar': 'هل أنت فني مسجل بالفعل؟ ',
    },

    // ==================== AUTH ====================
    'terminalSignIn': {'en': 'Terminal Sign In', 'ar': 'تسجيل دخول الطرفية'},
    'signInSubtitle': {
      'en': 'Scan badge or enter technician credentials',
      'ar': 'امسح البطاقة أو أدخل بيانات الفني',
    },
    'badgeId': {
      'en': 'Badge ID or Operator Email',
      'ar': 'رقم البطاقة أو البريد الإلكتروني',
    },
    'autoDetect': {'en': 'Auto-detect', 'ar': 'كشف تلقائي'},
    'securityPin': {'en': 'Security Passcode / PIN', 'ar': 'رمز الأمان / PIN'},
    'forgotPin': {'en': 'Forgot PIN?', 'ar': 'نسيت الرمز؟'},
    'rememberTerminal': {
      'en': 'Remember terminal assignment on this handheld sled',
      'ar': 'تذكّر تعيين الطرفية على هذا الجهاز',
    },
    'signInButton': {'en': 'Sign In to Terminal', 'ar': 'تسجيل الدخول'},
    'alternativeMethod': {'en': 'ALTERNATIVE METHOD', 'ar': 'طريقة بديلة'},
    'scanStaffBadge': {
      'en': 'Or Scan Staff Badge',
      'ar': 'أو امسح بطاقة الموظف'
    },
    'noAccount': {'en': "Don't have an account? ", 'ar': 'ليس لديك حساب؟ '},
    'register': {'en': 'Register', 'ar': 'تسجيل جديد'},
    'signIn': {'en': 'Sign In', 'ar': 'تسجيل الدخول'},
    'signOut': {'en': 'Sign Out', 'ar': 'تسجيل الخروج'},
    'welcomeBack': {'en': 'Welcome back', 'ar': 'أهلاً بعودتك'},
    'shiftMorning': {
      'en': 'SHIFT 1 • MORNING OPERATIONS',
      'ar': 'الوردية 1 • العمليات الصباحية',
    },
    'terminalReady': {
      'en': 'Terminal Ready for Inbound',
      'ar': 'الطرفية جاهزة للاستقبال',
    },
    'serverOnline': {'en': 'Server: Online', 'ar': 'الخادم: متصل'},

    // ==================== DASHBOARD ====================
    'dashboard': {'en': 'DASHBOARD', 'ar': 'لوحة التحكم'},
    'goodMorning': {'en': 'Good Morning', 'ar': 'صباح الخير'},
    'goodAfternoon': {'en': 'Good Afternoon', 'ar': 'مساء الخير'},
    'goodEvening': {'en': 'Good Evening', 'ar': 'مساء الخير'},
    'totalStock': {'en': 'TOTAL STOCK', 'ar': 'إجمالي المخزون'},
    'lowStockAlert': {'en': 'LOW STOCK ALERT', 'ar': 'تنبيه نفاد المخزون'},
    'expiringSoon': {'en': 'EXPIRING SOON', 'ar': 'ينتهي قريباً'},
    'pendingOrders': {'en': 'PENDING ORDERS', 'ar': 'طلبات معلقة'},
    'needsRestock': {'en': 'Needs restock', 'ar': 'يحتاج تعبئة'},
    'quickActions': {'en': 'QUICK TOUCH ACTIONS', 'ar': 'إجراءات سريعة'},
    'gloveMode': {'en': 'Glove-Mode Active', 'ar': 'وضع القفازات مفعّل'},
    'barcodeScan': {'en': 'BARCODE\nSCAN', 'ar': 'مسح\nالباركود'},
    'stockAudit': {'en': 'STOCK\nAUDIT', 'ar': 'جرد\nالمخزون'},
    'inboundDock': {'en': 'INBOUND\nDOCK', 'ar': 'رصيف\nالاستقبال'},
    'outboundDock': {'en': 'OUTBOUND', 'ar': 'الشحن'},
    'moreModules': {'en': 'MORE MODULES', 'ar': 'وحدات إضافية'},

    // ==================== PRODUCTS ====================
    'inventory': {'en': 'INVENTORY', 'ar': 'المخزون'},
    'products': {'en': 'Products', 'ar': 'المنتجات'},
    'searchProducts': {
      'en': 'Search SKU, item name, barcode...',
      'ar': 'ابحث برقم الصنف أو الاسم أو الباركود...',
    },
    'catalog': {'en': 'CATALOG', 'ar': 'الكتالوج'},
    'addProduct': {'en': 'Add Product', 'ar': 'إضافة منتج'},
    'inStock': {'en': 'In Stock', 'ar': 'متوفر'},
    'lowStock': {'en': 'Low Stock', 'ar': 'مخزون منخفض'},
    'outOfStock': {'en': 'Out of Stock', 'ar': 'نفد المخزون'},
    'optimal': {'en': 'Optimal', 'ar': 'مثالي'},
    'noProductsFound': {'en': 'No products found', 'ar': 'لا توجد منتجات'},
    'sortStockLow': {'en': 'Stock: Low to High', 'ar': 'المخزون: الأقل أولاً'},
    'sortStockHigh': {
      'en': 'Stock: High to Low',
      'ar': 'المخزون: الأكثر أولاً'
    },
    'sortNameAZ': {'en': 'Name: A → Z', 'ar': 'الاسم: أ → ي'},
    'sortPriceHigh': {'en': 'Price: High to Low', 'ar': 'السعر: الأعلى أولاً'},

    // ==================== OPERATIONS ====================
    'operations': {'en': 'OPERATIONS', 'ar': 'العمليات'},
    'inbound': {'en': 'Inbound', 'ar': 'وارد'},
    'outbound': {'en': 'Outbound', 'ar': 'صادر'},
    'transfer': {'en': 'Transfer', 'ar': 'تحويل'},
    'newMovement': {'en': 'NEW MOVEMENT', 'ar': 'حركة جديدة'},
    'completed': {'en': 'Completed', 'ar': 'مكتمل'},
    'inProgress': {'en': 'In Progress', 'ar': 'قيد التنفيذ'},
    'pending': {'en': 'Pending', 'ar': 'معلّق'},
    'cargoManifest': {'en': 'Cargo Manifest', 'ar': 'بيان الشحنة'},
    'routeDetails': {'en': 'Route Details', 'ar': 'تفاصيل المسار'},
    'origin': {'en': 'ORIGIN', 'ar': 'المصدر'},
    'destination': {'en': 'DESTINATION', 'ar': 'الوجهة'},
    'carrier': {'en': 'CARRIER', 'ar': 'الناقل'},
    'dockBay': {'en': 'DOCK BAY', 'ar': 'رصيف التحميل'},

    // ==================== SCANNER ====================
    'scanner': {'en': 'Scanner', 'ar': 'الماسح'},
    'quickAudit': {'en': 'Quick Audit', 'ar': 'جرد سريع'},
    'continuousBatch': {'en': 'Continuous Batch', 'ar': 'جرد متواصل'},
    'scannerActive': {'en': 'SCANNER ACTIVE', 'ar': 'الماسح نشط'},
    'alignBarcode': {
      'en': 'Align barcode within frame',
      'ar': 'وجّه الباركود داخل الإطار',
    },
    'systemCount': {'en': 'SYSTEM COUNT', 'ar': 'عدد النظام'},
    'discrepancy': {'en': 'DISCREPANCY', 'ar': 'الفرق'},
    'physicalCount': {'en': 'PHYSICAL AUDIT COUNT', 'ar': 'العدد الفعلي'},
    'matchErp': {'en': 'Match ERP', 'ar': 'مطابقة النظام'},
    'confirmSaveAudit': {
      'en': 'Confirm & Save Audit',
      'ar': 'تأكيد وحفظ الجرد'
    },
    'rescanSku': {'en': 'Re-scan SKU', 'ar': 'إعادة المسح'},
    'nextLocation': {'en': 'Next Location', 'ar': 'الموقع التالي'},

    // ==================== SUPPLIERS ====================
    'partners': {'en': 'PARTNERS', 'ar': 'الشركاء'},
    'suppliers': {'en': 'Suppliers', 'ar': 'الموردون'},
    'customers': {'en': 'Customers', 'ar': 'العملاء'},
    'viewCatalog': {'en': 'View Catalog', 'ar': 'عرض الكتالوج'},
    'createPo': {'en': 'Create PO', 'ar': 'إنشاء أمر شراء'},
    'fulfillmentScore': {'en': 'FULFILLMENT SCORE', 'ar': 'تقييم الأداء'},
    'activePipeline': {'en': 'ACTIVE PIPELINE', 'ar': 'الطلبات النشطة'},

    // ==================== PURCHASE ORDERS ====================
    'procurement': {'en': 'PROCUREMENT', 'ar': 'المشتريات'},
    'purchaseOrders': {'en': 'Purchase Orders', 'ar': 'أوامر الشراء'},
    'openCommitments': {'en': 'OPEN COMMITMENTS', 'ar': 'الالتزامات المفتوحة'},
    'generateNewPo': {
      'en': 'Generate New Purchase Order',
      'ar': 'إنشاء أمر شراء جديد',
    },
    'subtotal': {'en': 'Subtotal', 'ar': 'المجموع الفرعي'},
    'tax': {'en': 'VAT (14%)', 'ar': 'ضريبة القيمة المضافة (14%)'},
    'shipping': {'en': 'Shipping', 'ar': 'الشحن'},
    'total': {'en': 'TOTAL', 'ar': 'الإجمالي'},
    'included': {'en': 'Included', 'ar': 'مشمول'},
    'paymentTerms': {'en': 'PAYMENT TERMS', 'ar': 'شروط الدفع'},
    'deliveryDate': {'en': 'DELIVERY DATE', 'ar': 'تاريخ التسليم'},
    'lineItems': {'en': 'Line Items', 'ar': 'بنود الطلب'},
    'addLineItem': {'en': 'Add Line Item', 'ar': 'إضافة بند'},
    'submitPo': {'en': 'Submit PO', 'ar': 'إرسال الطلب'},

    // ==================== REPORTS ====================
    'reports': {'en': 'Reports', 'ar': 'التقارير'},
    'analytics': {'en': 'ANALYTICS', 'ar': 'التحليلات'},
    'performanceReports': {'en': 'Performance Reports', 'ar': 'تقارير الأداء'},
    'today': {'en': 'Today', 'ar': 'اليوم'},
    'sevenDays': {'en': '7 Days', 'ar': '7 أيام'},
    'thirtyDays': {'en': '30 Days', 'ar': '30 يوم'},
    'quarter': {'en': 'Quarter', 'ar': 'ربع سنوي'},
    'exportPdf': {'en': 'Export PDF', 'ar': 'تصدير PDF'},
    'exportExcel': {'en': 'Export Excel', 'ar': 'تصدير Excel'},
    'operationalKpis': {
      'en': 'Operational KPIs • Updated 9:41 AM',
      'ar': 'مؤشرات التشغيل • آخر تحديث 9:41 ص',
    },
    'overallFulfillmentRate': {
      'en': 'OVERALL FULFILLMENT RATE',
      'ar': 'معدل الإنجاز الإجمالي',
    },
    'ordersLabel': {'en': 'ORDERS', 'ar': 'الطلبات'},
    'avgCycle': {'en': 'AVG CYCLE', 'ar': 'متوسط الدورة'},
    'inboundVolume': {'en': 'INBOUND VOLUME', 'ar': 'حجم الوارد'},
    'outboundVolume': {'en': 'OUTBOUND VOLUME', 'ar': 'حجم الصادر'},
    'stockVariance': {'en': 'STOCK VARIANCE', 'ar': 'فرق المخزون'},
    'dockTurnaround': {'en': 'DOCK TURNAROUND', 'ar': 'زمن دوران الرصيف'},
    'pkgsReceived': {'en': 'pkgs received', 'ar': 'طرد مستلم'},
    'pkgsDispatched': {'en': 'pkgs dispatched', 'ar': 'طرد مشحون'},
    'discrepancies': {'en': 'discrepancies', 'ar': 'فرق'},
    'avgPerTruck': {'en': 'avg per truck', 'ar': 'متوسط الشاحنة'},
    'throughputTrend': {'en': 'Throughput Trend', 'ar': 'اتجاه الإنتاجية'},
    'dailyProcessingVolume': {
      'en': 'Daily processing volume',
      'ar': 'حجم المعالجة اليومي',
    },
    'categoryDistribution': {
      'en': 'Category Distribution',
      'ar': 'توزيع الفئات'
    },
    'stockValueByFamily': {
      'en': 'Stock value by product family',
      'ar': 'قيمة المخزون حسب عائلة المنتج',
    },
    'topMovingSkus': {'en': 'Top Moving SKUs', 'ar': 'الأصناف الأكثر حركة'},
    'bearingsMechanical': {
      'en': 'Bearings & Mechanical',
      'ar': 'المحامل والميكانيكا',
    },
    'electronicsIcs': {
      'en': 'Electronics & ICs',
      'ar': 'الإلكترونيات والدوائر'
    },
    'chemicalsFluids': {
      'en': 'Chemicals & Fluids',
      'ar': 'الكيماويات والسوائل'
    },
    'packagingConsumables': {
      'en': 'Packaging & Consumables',
      'ar': 'مواد التعبئة والمستهلكات',
    },
    'heavyDutyBallBearings': {
      'en': 'Heavy-Duty Ball Bearings',
      'ar': 'محامل كروية للخدمة الشاقة',
    },
    'corrugatedBoxes': {
      'en': 'Corrugated Boxes 12x12',
      'ar': 'صناديق مموجة 12×12'
    },
    'microcontrollerBoards': {
      'en': 'Microcontroller Boards',
      'ar': 'لوحات المتحكمات الدقيقة',
    },
    'highTempSilicone': {
      'en': 'High-Temp Silicone',
      'ar': 'سيليكون مقاوم للحرارة'
    },
    'mon': {'en': 'Mon', 'ar': 'الإثنين'},
    'tue': {'en': 'Tue', 'ar': 'الثلاثاء'},
    'wed': {'en': 'Wed', 'ar': 'الأربعاء'},
    'thu': {'en': 'Thu', 'ar': 'الخميس'},
    'fri': {'en': 'Fri', 'ar': 'الجمعة'},
    'sat': {'en': 'Sat', 'ar': 'السبت'},
    'sun': {'en': 'Sun', 'ar': 'الأحد'},
    'activeShift': {'en': 'Active', 'ar': 'نشطة'},
    'valued': {'en': 'Valued', 'ar': 'القيمة'},
    'reorder': {'en': 'Reorder', 'ar': 'إعادة الطلب'},
    'batches': {'en': 'Batches', 'ar': 'دفعات'},
    'criticalFifo': {'en': 'Critical FIFO', 'ar': 'أولوية انتهاء الصلاحية'},
    'queue': {'en': 'Queue', 'ar': 'قائمة الانتظار'},
    'quickTouchActions': {'en': 'QUICK TOUCH ACTIONS', 'ar': 'إجراءات سريعة'},
    'gloveModeActive': {'en': 'Glove-Mode Active', 'ar': 'وضع القفازات مفعّل'},
    'rapidAudit': {'en': 'Rapid Audit', 'ar': 'جرد سريع'},
    'zoneChecks': {'en': 'Zone Checks', 'ar': 'فحص المناطق'},
    'receivePallets': {'en': 'Receive Pallets', 'ar': 'استلام الطبالي'},
    'dispatchBay': {'en': 'Dispatch Bay', 'ar': 'رصيف الشحن'},
    'weeklyThroughput': {
      'en': 'Weekly Throughput',
      'ar': 'الإنتاجية الأسبوعية'
    },
    'inboundOutboundVolume': {
      'en': 'Inbound vs Outbound volume',
      'ar': 'حجم الوارد مقابل الصادر',
    },
    'urgentAttention': {'en': 'URGENT ATTENTION', 'ar': 'تحتاج انتباه عاجل'},
    'viewAllAlerts': {'en': 'View All Alerts', 'ar': 'عرض كل التنبيهات'},
    'suppliersCustomers': {
      'en': 'Suppliers & Customers',
      'ar': 'الموردون والعملاء'
    },
    'partnersContactsCatalogs': {
      'en': 'Partners, contacts & catalogs',
      'ar': 'الشركاء وجهات الاتصال والكتالوجات',
    },
    'warehouseLocations': {'en': 'Warehouse Locations', 'ar': 'مواقع المستودع'},
    'rackMatrixBins': {
      'en': 'Rack matrix & bin details',
      'ar': 'مصفوفة الرفوف وتفاصيل الخانات'
    },
    'barcodeGenerator': {'en': 'Barcode Generator', 'ar': 'مولّد الباركود'},
    'printThermalLabels': {
      'en': 'Print thermal labels',
      'ar': 'طباعة ملصقات حرارية'
    },
    'assetValuation': {'en': 'Asset Valuation', 'ar': 'تقييم الأصول'},
    'totalPortfolio': {'en': 'total portfolio', 'ar': 'إجمالي المحفظة'},
    'accountLanguageHardware': {
      'en': 'Account, language, hardware',
      'ar': 'الحساب واللغة والأجهزة',
    },

    // ==================== NOTIFICATIONS ====================
    'floorFeed': {'en': 'Floor Feed', 'ar': 'سجل الأرضية'},
    'notifications': {'en': 'Notifications', 'ar': 'الإشعارات'},
    'unread': {'en': 'Unread', 'ar': 'غير مقروء'},
    'markAllRead': {'en': 'Mark all read', 'ar': 'تعليم الكل كمقروء'},
    'yesterday': {'en': 'YESTERDAY', 'ar': 'أمس'},
    'earlier': {'en': 'EARLIER', 'ar': 'سابقاً'},
    'alerts': {'en': 'Alerts', 'ar': 'التنبيهات'},
    'orders': {'en': 'Orders', 'ar': 'الطلبات'},
    'audit': {'en': 'Audit', 'ar': 'الجرد'},
    'floorAccuracyRate': {
      'en': 'Floor Accuracy Rate',
      'ar': 'معدل دقة التشغيل'
    },
    'shiftTarget': {'en': 'Shift Target', 'ar': 'هدف الوردية'},
    'warningsPending': {'en': 'warnings pending', 'ar': 'تحذيرات معلقة'},
    'allOperationalFeedsUpToDate': {
      'en': 'ALL OPERATIONAL FEEDS UP TO DATE',
      'ar': 'جميع سجلات التشغيل محدثة',
    },
    'noNotifications': {'en': 'No notifications', 'ar': 'لا توجد إشعارات'},
    'caughtUpCategory': {
      'en': 'You are all caught up in this category.',
      'ar': 'لا توجد إشعارات جديدة في هذا التصنيف.',
    },
    'critical': {'en': 'Critical', 'ar': 'حرج'},
    'warnings': {'en': 'Warnings', 'ar': 'تحذيرات'},
    'updates': {'en': 'Updates', 'ar': 'تحديثات'},
    'dismiss': {'en': 'Dismiss', 'ar': 'إغلاق'},
    'notificationFilters': {'en': 'All', 'ar': 'الكل'},

    // ==================== PROFILE ====================
    'terminal': {'en': 'TERMINAL', 'ar': 'الطرفية'},
    'profileSettings': {'en': 'Profile & Settings', 'ar': 'الملف والإعدادات'},
    'ergonomics': {'en': 'Ergonomics & Layout', 'ar': 'التخطيط والراحة'},
    'language': {'en': 'LANGUAGE', 'ar': 'اللغة'},
    'terminalHardware': {'en': 'Terminal Hardware', 'ar': 'أجهزة الطرفية'},
    'rolesAuthority': {'en': 'Roles & Authority', 'ar': 'الأدوار والصلاحيات'},
    'switchWarehouse': {
      'en': 'Switch Warehouse Facility',
      'ar': 'تبديل المستودع'
    },
    'lockTerminal': {'en': 'Lock Handheld Terminal', 'ar': 'قفل الجهاز'},
    'scansToday': {'en': 'SCANS TODAY', 'ar': 'عمليات المسح اليوم'},
    'accuracy': {'en': 'ACCURACY', 'ar': 'الدقة'},
    'zone': {'en': 'ZONE', 'ar': 'المنطقة'},

    // ==================== NAV ====================
    'navHome': {'en': 'Home', 'ar': 'الرئيسية'},
    'navProducts': {'en': 'Products', 'ar': 'المنتجات'},
    'navAudit': {'en': 'Audit', 'ar': 'الجرد'},
    'navOperations': {'en': 'Operations', 'ar': 'العمليات'},
    'navReports': {'en': 'Reports', 'ar': 'التقارير'},

    // ==================== MESSAGES ====================
    'fixErrors': {
      'en': 'Please fix the highlighted fields',
      'ar': 'يرجى تصحيح الحقول المحددة',
    },
    'signOutConfirm': {
      'en': 'Sign out of terminal?',
      'ar': 'تسجيل الخروج من الطرفية؟',
    },
    'signOutMessage': {
      'en': 'Your shift session will end. Unsaved audits will be lost.',
      'ar': 'ستنتهي جلسة الوردية. سيتم فقدان الجرد غير المحفوظ.',
    },
    'discardChanges': {'en': 'Discard changes?', 'ar': 'تجاهل التغييرات؟'},
    'noResults': {'en': 'No results found', 'ar': 'لا توجد نتائج'},

    // ==================== THEME ====================
    'theme': {'en': 'APP THEME', 'ar': 'مظهر التطبيق'},
    'lightMode': {'en': 'Light', 'ar': 'فاتح'},
    'darkMode': {'en': 'Dark', 'ar': 'داكن'},
    'themeChanged': {'en': 'Theme updated', 'ar': 'تم تغيير المظهر'},

    // ==================== CAMERA ====================
    'cameraUnavailable': {
      'en': 'Camera unavailable',
      'ar': 'الكاميرا غير متاحة'
    },
    'scanned': {'en': 'Scanned', 'ar': 'تم المسح'},
    'unknownCode': {'en': 'Unknown code', 'ar': 'كود غير معروف'},

    // ==================== CHARTS ====================
    'inLabel': {'en': 'In', 'ar': 'وارد'},
    'outLabel': {'en': 'Out', 'ar': 'صادر'},
    'peak': {'en': 'Peak', 'ar': 'الذروة'},
  };
}
