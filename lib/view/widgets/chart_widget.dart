import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/chartController.dart';

class ChartWidget extends StatelessWidget {
  final ChartController chartController = Get.find();

  ChartWidget({super.key});

  Widget buildYearlySalesBarChart() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: chartController.yearSales.isEmpty
              ? const Center(child: Text('No data available'))
              : BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: chartController.yearSales
                            .map((e) => e['sales'] as int)
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble() +
                        50000, // 여유 공간 추가
                    barGroups: chartController.yearSales.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value['sales'].toDouble(),
                            color: Colors.blue,
                            width: 40,
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < chartController.yearSales.length) {
                              return Text(
                                '20${chartController.yearSales[index]['year']}',
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }

  Widget buildTopCategoriesPieChart() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: chartController.products.isEmpty
              ? const Center(child: Text('No data available'))
              : Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: chartController.products.take(5).map((data) {
                            final index = chartController.products.indexOf(data);
                            final total = chartController.products
                                .map((e) => e['order_count'] as int)
                                .reduce((a, b) => a + b);
                            final percentage =
                                ((data['order_count'] as int) / total * 100).toStringAsFixed(1);
                            return PieChartSectionData(
                              value: data['order_count'].toDouble(),
                              title: '$percentage%',
                              color: Colors.primaries[index % Colors.primaries.length],
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: chartController.products.take(5).map((data) {
                          final index = chartController.products.indexOf(data);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  color: Colors.primaries[index % Colors.primaries.length],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _truncateString(data['name'], 15),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
        ));
  }

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Yearly Sales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: buildYearlySalesBarChart()),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Top 5 Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: buildTopCategoriesPieChart()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
