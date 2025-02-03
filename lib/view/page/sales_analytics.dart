import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/salesTrendschart.dart';
import 'package:lucky_depot/view/widgets/topSellingBarChart.dart';
import 'package:lucky_depot/view/widgets/topsellingtable.dart';
import 'package:lucky_depot/vm/custom_drawer_controller.dart';
import 'package:lucky_depot/vm/sales_controller.dart';

class SalesAnalytics extends StatelessWidget {
  const SalesAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomDrawerController drawerController = Get.find<CustomDrawerController>();
    final SalesController salesController = Get.put(SalesController());

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
                    // Top Selling Items Table
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
                    // Sales Trends Chart
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
                      child: const SalesTrendsChart(),  // 타이틀이 이미 차트 내부에 있으므로 수정
                    ),
                    const SizedBox(height: 24),
                    // Top Products Bar Chart
                    Container(
                      height: 500,
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
