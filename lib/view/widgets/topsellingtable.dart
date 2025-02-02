import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucky_depot/view/widgets/periodSelector.dart';
import 'package:lucky_depot/vm/sales_controller.dart';

class TopSellingTable extends StatelessWidget {
  final SalesController controller = Get.find<SalesController>();

  TopSellingTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: DataTable(
          columnSpacing: 24.0,
          horizontalMargin: 16.0,
          columns: const [
            DataColumn(
              label:
                  Text('Rank', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Product Name',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Sales Volume',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Revenue',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: controller.topSellingItems.take(5).map((item) {
            final index = controller.topSellingItems.indexOf(item);
            return DataRow(
              cells: [
                DataCell(SizedBox(width: 40, child: Text('${index + 1}'))),
                DataCell(Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(item['name']))),
                DataCell(Text('${item['order_count']}')),
                DataCell(Text('\$${item['total_price']}')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SalesTrendsChart extends StatelessWidget {
  final SalesController controller = Get.find<SalesController>();
  final NumberFormat currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  SalesTrendsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sales Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            PeriodSelector(),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: controller.salesTrends.isEmpty
                        ? 400000
                        : controller.salesTrends
                                .map((e) => e['sales'] as int? ?? 0)
                                .reduce((a, b) => a > b ? a : b)
                                .toDouble() *
                            1.2,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 50000,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              currencyFormatter.format(value),
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
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 &&
                                index < controller.salesTrends.length) {
                              final weekdays = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ];
                              final weekday = controller.salesTrends[index]
                                      ['weekday'] as int? ??
                                  0;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  weekdays[weekday % 7],
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
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                        left: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots:
                            controller.salesTrends.asMap().entries.map((entry) {
                          return FlSpot(
                            entry.key.toDouble(),
                            (entry.value['sales'] as num?)?.toDouble() ?? 0.0,
                          );
                        }).toList(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: Colors.blue,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: 500,
              child: Obx(() => Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 16),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: controller.topSellingItems.isEmpty
                            ? 100
                            : controller.topSellingItems
                                    .take(5)
                                    .map((e) => e['order_count'] as int)
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble() *
                                1.2,
                        barGroups: controller.topSellingItems
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
                                width: 60,
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
                                final items =
                                    controller.topSellingItems.take(5).toList();
                                final index = value.toInt();
                                if (index < items.length) {
                                  String name = items[index]['name'];
                                  if (name.length > 20) {
                                    name = '${name.substring(0, 17)}...';
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
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
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
