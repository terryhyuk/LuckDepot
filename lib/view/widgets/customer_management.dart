import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/stat_card.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/customertable.dart';
import 'package:lucky_depot/view/widgets/stat_card_widget.dart';
import 'package:lucky_depot/vm/customer_controller.dart';

class CustomerManagement extends StatelessWidget {
  CustomerManagement({super.key});

  final CustomerManagementViewModel customerCount = Get.put(CustomerManagementViewModel());

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
                    'Customer Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() => Row(
                    children: [
                      StatCardWidget(
                        data: StatCard(
                          title: 'Total Customers',
                          value: '${customerCount.totalCustomers.value}',
                        ),
                      ),
                      const SizedBox(width: 16),
                      StatCardWidget(
                        data: StatCard(
                          title: 'Total Payment',
                          value: '\$${customerCount.totalPayment.value.toStringAsFixed(0)}',
                        ),
                      ),
                      const SizedBox(width: 16),
                      StatCardWidget(
                        data: StatCard(
                          title: 'Average Purchase',
                          value: '\$${customerCount.averagePurchase.value.toStringAsFixed(0)}',
                        ),
                      ),
                    ],
                  ),
                ),
                  const SizedBox(height: 24),
                  const Expanded(
                    child: CustomerTable(),  // 고객 테이블 위젯 추가 필요
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
