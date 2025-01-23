// lib/view/pages/inventory_management.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/product.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/vm/inventory_controller.dart';

class InventoryManagement extends StatelessWidget {
  InventoryManagement({super.key});

  final inventory = Get.put(InventoryController());

  _showDeleteConfirmation(BuildContext context, InventoryController viewModel, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Delete Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Are you sure you want to delete "${product.name}"?'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        viewModel.deleteProduct(product.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomDrawer(),
          Container(
            width: 200,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() => ListView.builder(
                    itemCount: inventory.categories.length,
                    itemBuilder: (context, index) {
                      final category = inventory.categories[index];
                      return ListTile(
                        title: Text(category),
                        selected: inventory.selectedCategory.value == category,
                        onTap: () => inventory.selectCategory(category),
                      );
                    },
                  )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Inventory Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: inventory.searchController,
                          decoration: InputDecoration(
                            hintText: 'Search products',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onChanged: inventory.searchProducts,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Obx(() => GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: inventory.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = inventory.filteredProducts[index];
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  'http://192.168.50.38:8000${product.image}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(Icons.image_not_supported),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${product.quantity}',
                                              style: TextStyle(
                                                color: product.quantity > 0 ? Colors.green : Colors.red,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              'pcs',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 12,
                                              child: IconButton(
                                                icon: const Icon(Icons.remove, color: Colors.white, size: 14),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                onPressed: () => _showDeleteConfirmation(context, inventory, product),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle, color: Colors.blue),
                                              iconSize: 20,
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              onPressed: () => inventory.increaseQuantity(product.id),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
