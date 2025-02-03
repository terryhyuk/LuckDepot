import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          rows: controller.topProducts.take(5).map((item) {
            final index = controller.topProducts.indexOf(item);
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


