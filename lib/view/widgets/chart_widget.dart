import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/chartController.dart';

class ChartWidget extends StatelessWidget {
  final ChartController chartController = Get.put(ChartController());

  ChartWidget({super.key});

  // 막대 차트
  Widget buildBarChart() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: chartController.monthlyData.isEmpty
                  ? 400000
                  : chartController.monthlyData
                      .map((e) => e['total_price'] as int)
                      .reduce((a, b) => a > b ? a : b)
                      .toDouble(),
              barGroups:
                  chartController.monthlyData.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value['total_price'].toDouble(),
                      color: Colors.blue,
                      width: 40,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      // 현재 달부터 역순으로 6개월 표시
                      final now = DateTime.now();
                      final month = now.month - value.toInt();
                      final adjustedMonth = month <= 0 ? month + 12 : month;

                      // 월 이름 배열
                      const monthNames = [
                        'Jan','Feb','Mar','Apr','May',
                        'Jun','Jul','Aug','Sep','Oct',
                        'Nov','Dec'
                      ];

                      return Text(
                        monthNames[adjustedMonth - 1],
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ));
  }

  // 파이차트
  Widget buildPieChart() {
    final touchedIndex = ValueNotifier<int>(-1);

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ValueListenableBuilder<int>(
                valueListenable: touchedIndex,
                builder: (context, value, _) {
                  return PieChart(
                    PieChartData(
                      sections: chartController.categoryData.map((data) {
                        final index =
                            chartController.categoryData.indexOf(data);
                        final total = chartController.categoryData
                            .map((e) => e['order_count'] as int)
                            .reduce((a, b) => a + b);
                        final percentage =
                            ((data['order_count'] as int) / total * 100)
                                .toStringAsFixed(1);
                        final isTouched = index == value;

                        return PieChartSectionData(
                          value: data['order_count'].toDouble(),
                          title: isTouched ? '$percentage%' : '',
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          radius: isTouched ? 90 : 80,
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                          borderSide: const BorderSide(width: 0),
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 100,
                      centerSpaceColor: Colors.white,
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse?.touchedSection == null) {
                            touchedIndex.value = -1;
                            return;
                          }
                          touchedIndex.value = pieTouchResponse!
                              .touchedSection!.touchedSectionIndex;
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // 범례
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: chartController.categoryData.map((data) {
                    final index = chartController.categoryData.indexOf(data);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors
                                  .primaries[index % Colors.primaries.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _truncateString(data['name'], 15),
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data['order_count']}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    'Monthly Sales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: buildBarChart()),
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
                    'Sales by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: buildPieChart()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
