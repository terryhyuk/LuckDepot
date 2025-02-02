import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/topsellingtable.dart';
import 'package:lucky_depot/vm/custom_drawer_controller.dart';
import 'package:lucky_depot/vm/sales_controller.dart';

class SalesAnalytics extends StatefulWidget {
  const SalesAnalytics({super.key});

  @override
  State<SalesAnalytics> createState() => _SalesAnalyticsState();
}

class _SalesAnalyticsState extends State<SalesAnalytics> {
  @override
  void initState() {
    super.initState();
    Get.put(CustomDrawerController());
    Get.put(SalesController());
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Row(
      children: [
        CustomDrawer(),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Analytics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top Selling Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TopSellingTable(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SalesTrendsChart(),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 590,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TopSellingBarChart(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}