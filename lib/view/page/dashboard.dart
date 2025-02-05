import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/stat_card.dart';
import 'package:lucky_depot/view/widgets/dashboard_chart_widget.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/recent_orders_table.dart';
import 'package:lucky_depot/view/widgets/stat_card_widget.dart';
import 'package:lucky_depot/vm/chartController.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<ChartController>();

    return Scaffold(
      body: Row(
        children: [
          CustomDrawer(),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: Obx(() {
                if (chartController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 상단 통계 카드
                      Row(
                        children: [
                          Expanded(
                            child: StatCardWidget(
                              data: StatCard(
                                title: 'Total Payment',
                                value: '\$${chartController.totalPayment.toStringAsFixed(0)}',
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: StatCardWidget(
                              data: StatCard(
                                title: 'Total Orders',
                                value: chartController.totalOrders.toString(),
                              ),
                              
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 24),
                      // 차트 영역
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const DashboardChartWidget(),  // 수정
                      ),
                      const SizedBox(height: 24),
                      // 최근 주문 목록
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
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
                              'Recent Orders',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 300,
                              child: RecentOrdersTable(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
