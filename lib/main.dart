import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucky_depot/model/driver.dart';
import 'package:lucky_depot/model/driver_repository.dart';
import 'package:lucky_depot/model/truck.dart';
import 'package:lucky_depot/repository/customer_repository.dart';
import 'package:lucky_depot/repository/product_detail.dart';
import 'package:lucky_depot/repository/product_repository.dart';
import 'package:lucky_depot/view/page/login.dart';
import 'package:lucky_depot/view/widgets/customer_management.dart';
import 'package:lucky_depot/view/page/dashboard.dart';
import 'package:lucky_depot/view/page/delivery_driver.dart';
import 'package:lucky_depot/view/page/inventory_management.dart';
import 'package:lucky_depot/view/page/logistics_hub.dart';
import 'package:lucky_depot/view/page/sales_analytics.dart';
import 'package:lucky_depot/vm/chartController.dart';
import 'package:lucky_depot/vm/custom_drawer_controller.dart';
import 'package:lucky_depot/vm/customer_controller.dart';
import 'package:lucky_depot/vm/delivery_driver_controller.dart';
import 'package:lucky_depot/vm/inventory_controller.dart';
import 'package:lucky_depot/vm/recent_order_controller.dart';
import 'package:lucky_depot/vm/sales_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DriverAdapter());
  Hive.registerAdapter(TruckAdapter());
  await Hive.openBox<Driver>('drivers');
  await Hive.openBox<Truck>('trucks');

  // 리포지토리 초기화
Get.put(CustomerRepository());
Get.put(ProductRepository());
Get.put(ProductDetailRepository());
Get.put(DriverRepository());

// 컨트롤러 초기화
Get.put(CustomDrawerController());
Get.put(ChartController());
Get.put(DeliveryDriverController());  // 한 번만 초기화
Get.put(CustomerController());
Get.put(InventoryController());
Get.put(SalesController());
Get.put(RecentOrderController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) =>
          ResponsiveBreakpoints.builder(child: child!, breakpoints: [
        const Breakpoint(start: 0, end: 450, name: MOBILE),
        const Breakpoint(start: 451, end: 800, name: TABLET),
        const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ]),
      title: 'Lucky Depot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      defaultTransition: Transition.noTransition,
      getPages: [
        GetPage(
          name: '/',
          page: () => const Dashboard(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/sales',
          page: () => const SalesAnalytics(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/inventory',
          page: () => InventoryManagement(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/customer',
          page: () => CustomerManagement(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/logistics',
          page: () => const LogisticsHub(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/delivery_driver',
          page: () => DeliveryDriver(),
          transition: Transition.noTransition,
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
