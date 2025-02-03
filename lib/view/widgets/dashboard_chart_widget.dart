import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/chartController.dart';

class DashboardChartWidget extends StatelessWidget {
  const DashboardChartWidget({super.key});

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

Widget buildYearlySalesBarChart(ChartController chartController) {
  final yearSales = chartController.yearSales.skip(1).toList(); // 최근 5년치만 표시

  if (yearSales.isEmpty) {
    return const Center(child: Text('No data available'));
  }

  return Container(
    padding: const EdgeInsets.all(16),
    height: 300,
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly, // 간격 균등 조정
        maxY: yearSales
                .map((e) => e['sales'] as int? ?? 0)
                .reduce((a, b) => a > b ? a : b)
                .toDouble() * 1.1,
        barGroups: yearSales.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: (entry.value['sales'] as num?)?.toDouble() ?? 0.0,
                color: Colors.blue,
                width: 25,
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${(value/1000).toInt()}K',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < yearSales.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      yearSales[index]['year'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

Widget buildTopCategoriesPieChart(ChartController chartController) {
  final touchedIndex = ValueNotifier<int>(-1);
  final categories = chartController.getTopCategories();
  
  if (categories.isEmpty) {
    return const Center(child: Text('No data available'));
  }

  final total = categories
      .map((e) => e['count'] as int? ?? 0)
      .reduce((a, b) => a + b);

  return Container(
    padding: const EdgeInsets.all(16),
    height: 300,
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: ValueListenableBuilder<int>(
            valueListenable: touchedIndex,
            builder: (context, touchedIdx, _) {
              return PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 85,
                  sections: categories.asMap().entries.map((entry) {
                    final data = entry.value;
                    final count = data['count'] as int? ?? 0;
                    final percentage = (count / total * 100).toStringAsFixed(1);
                    final isTouched = entry.key == touchedIdx;
                    
                    return PieChartSectionData(
                      value: count.toDouble(),
                      title: isTouched ? '$percentage%' : '',  // 터치시에만 퍼센트 표시
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      radius: isTouched ? 90 : 80,  // 원래 크기 유지
                      color: Colors.primaries[entry.key % Colors.primaries.length],
                      borderSide: const BorderSide(width: 0),
                    );
                  }).toList(),
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
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: Colors.primaries[entry.key % Colors.primaries.length],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _truncateString(entry.value['category'] ?? '', 15),
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
  );
}



  @override
  Widget build(BuildContext context) {
    final chartController = Get.find<ChartController>();
    
    return Obx(() {
      if (chartController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SizedBox(
        height: 400,
        child: Row(
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
                    Expanded(
                      child: buildYearlySalesBarChart(chartController),
                    ),
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
                        'Top Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: buildTopCategoriesPieChart(chartController),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
