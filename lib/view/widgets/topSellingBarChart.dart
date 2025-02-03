import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/sales_controller.dart';

class TopSellingBarChart extends StatelessWidget {
  final SalesController controller = Get.find<SalesController>();

  TopSellingBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top 5 Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 16),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: controller.topProducts.isEmpty
                      ? 100
                      : controller.topProducts
                              .take(5)
                              .map((e) => e['order_count'] as int)
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble() *
                          1.2,
                  barGroups: controller.topProducts
                      .take(5)
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value['order_count'].toDouble(),
                          gradient: LinearGradient(
                            colors: [Colors.blue[300]!, Colors.blue],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 40,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          final items = controller.topProducts.take(5).toList();
                          final index = value.toInt();
                          if (index < items.length) {
                            String name = items[index]['name'];
                            if (name.length > 15) {
                              final splitIndex = name.indexOf(' ', 15);
                              if (splitIndex != -1) {
                                name = '${name.substring(0, splitIndex)}\n${name.substring(splitIndex + 1)}';
                              } else {
                                name = '${name.substring(0, 15)}\n${name.substring(15)}';
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
