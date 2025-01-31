import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/stat_card.dart';
import 'package:lucky_depot/view/widgets/chart_widget.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/stat_Card_widget.dart';
import 'package:lucky_depot/vm/chartController.dart';
import 'package:lucky_depot/vm/custom_drawer_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ChartController chartController = Get.put(ChartController());

  @override
  void initState() {
    super.initState();
    Get.put(CustomDrawerController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomDrawer(),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
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
                        child: Obx(() => StatCardWidget(
                          data: StatCard(
                            title: 'Total Payment',
                            value: '\$${chartController.totalPayment.toStringAsFixed(0)}',
                          ),
                        )),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Obx(() => StatCardWidget(
                          data: StatCard(
                            title: 'Total Orders',
                            value: chartController.totalOrders.toString(),
                          ),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 차트 영역
                  Expanded(
                    flex: 2,
                    child: ChartWidget(),
                  ),
                  const SizedBox(height: 24),
                  // 최근 주문 목록 (준비중)
                  Expanded(
                    flex: 1,
                    child: Container(
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
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          // 여기에 나중에 주문 목록 추가
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
