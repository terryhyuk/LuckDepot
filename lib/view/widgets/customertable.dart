import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/customer_controller.dart';

class CustomerTable extends GetView<CustomerController> {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Customer List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Obx(() => DropdownButton<String>(
                      value: controller.selectedSort.value,
                      items: controller.sortOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: controller.updateSort,
                    )),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name or email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        onChanged: controller.searchCustomers,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(flex: 2, child: Text('Name')),
                Expanded(flex: 3, child: Text('Email')),
                Expanded(flex: 2, child: Text('Total Payment')),
                Expanded(flex: 1, child: Text('Orders')),
                Expanded(flex: 2, child: Text('Last Order Date')),
              ],
            ),
            const Divider(),
            Obx(() => Expanded(
              child: ListView.builder(
                itemCount: controller.filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = controller.filteredCustomers[index];
                  return Row(
                    children: [
                      Expanded(flex: 2, child: Text(customer.name)),
                      Expanded(flex: 3, child: Text(customer.email)),
                      Expanded(
                        flex: 2, 
                        child: Text('\$${customer.totalPayment.toStringAsFixed(0)}'),
                      ),
                      Expanded(flex: 1, child: Text('${customer.orderCount}')),
                      Expanded(flex: 2, child: Text(customer.lastOrderDate)),
                    ],
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
