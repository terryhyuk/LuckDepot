import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/recent_order_controller.dart';

class RecentOrdersTable extends StatelessWidget {
  final RecentOrderController orderController =
      Get.put(RecentOrderController());

  RecentOrdersTable({super.key});

@override
Widget build(BuildContext context) {
  return Obx(() {
    if (orderController.recentOrders.isEmpty) {
      return const Center(child: Text('No recent orders available.'));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: 24.0,
              horizontalMargin: 16.0,
              columns: [
                _buildHeader('Order No.', 'id'),
                _buildHeader('Customer', 'user_name'),
                _buildHeader('Product', 'product_name'),
                _buildHeader('Amount', 'price'),
                _buildHeader('Status', 'status'),
              ],
              rows: orderController.recentOrders.map((order) {
                return DataRow(cells: [
                  DataCell(Text(order['id'].toString())),
                  DataCell(Text(order['user_name'])),
                  DataCell(Text(order['product_name'])),
                  DataCell(Text('\$${order['price']}')),
                  DataCell(_statusBadge(order['status'])),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  });
}


  DataColumn _buildHeader(String label, String columnName) {
    return DataColumn(
      label: Text(label),
      onSort: (_, __) => orderController.sort(columnName),
    );
  }

  Widget _statusBadge(String status) {
    final translatedStatus = {
          '배송전': 'Pending',
          '배송중': 'Shipping',
          '배송완료': 'Delivered',
        }[status] ??
        'Unknown';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        translatedStatus,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Color _getStatusColor(String status) {
    const statusColors = {
      '배송전': Colors.orange,
      '배송중': Colors.blue,
      '배송완료': Colors.green,
    };
    return statusColors[status] ?? Colors.grey;
  }
}
