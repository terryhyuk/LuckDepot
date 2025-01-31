import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/sales_controller.dart';

class PeriodSelector extends StatelessWidget {
  final SalesController controller = Get.find<SalesController>();

  PeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildPeriodButton('Yearly', 'year'),
        const SizedBox(width: 12),
        _buildPeriodButton('Monthly', 'month'),
        const SizedBox(width: 12),
        _buildPeriodButton('Weekly', 'week'),
      ],
    );
  }

  Widget _buildPeriodButton(String text, String period) {
    return Obx(() => TextButton(
      onPressed: () => controller.changePeriod(period),
      style: TextButton.styleFrom(
        backgroundColor: controller.selectedPeriod.value == period 
            ? Colors.blue 
            : Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: controller.selectedPeriod.value == period 
              ? Colors.white 
              : Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ));
  }
}
