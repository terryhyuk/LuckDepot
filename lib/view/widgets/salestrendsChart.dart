import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/sales_controller.dart';

class SalesTrendsChart extends StatelessWidget {
  const SalesTrendsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final salesController = Get.find<SalesController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 기간 선택 버튼 행
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildPeriodButton(salesController, 'Week'),
            const SizedBox(width: 8),
            _buildPeriodButton(salesController, 'Month'),
            const SizedBox(width: 8),
            _buildPeriodButton(salesController, 'Year'),
          ],
        ),
        const SizedBox(height: 16),
        // 차트 영역
        Expanded(
          child: Obx(() {
            if (salesController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final salesData = salesController.getSalesData();
            if (salesData.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            return LineChart(
              LineChartData(
                // 격자 설정
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 50000,
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
                // 축 제목 설정
                titlesData: FlTitlesData(
                  // 왼쪽 Y축 (금액)
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
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
                  // 하단 X축 (기간)
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        // 매출이 있는 데이터 포인트만 레이블 표시
                        if (index >= 0 && 
                            index < salesData.length && 
                            salesData[index]['sales'] > 0) {
                          switch (salesController.selectedPeriod.value) {
                            case 'year':
                              return Text(
                                salesData[index]['year'].toString(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                            case 'week':
                              // 요일을 영문으로 표시
                              final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              return Text(
                                weekdays[salesData[index]['weekday'] - 1],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                            default:
                              return Text(
                                '${index + 1}월',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              );
                          }
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
                // 테두리 설정
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                // 라인 차트 데이터
                lineBarsData: [
                  LineChartBarData(
                    // 데이터 포인트
                    spots: salesData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        (entry.value['sales'] as num?)?.toDouble() ?? 0.0,
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    // 데이터 포인트 표시 설정
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        // 매출이 있는 포인트만 동그라미 표시
                        if (spot.y > 0) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.blue,
                          );
                        }
                        return FlDotCirclePainter(
                          radius: 0,
                          color: Colors.transparent,
                          strokeWidth: 0,
                          strokeColor: Colors.transparent,
                        );
                      },
                    ),
                    // 라인 아래 영역 색상
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  // 기간 선택 버튼 위젯
  Widget _buildPeriodButton(SalesController controller, String period) {
    return Obx(() {
      final isSelected = controller.selectedPeriod.value == period.toLowerCase();
      return TextButton(
        onPressed: () => controller.changePeriod(period.toLowerCase()),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    });
  }
}
