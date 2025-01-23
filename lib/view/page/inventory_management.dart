// lib/view/pages/inventory_management.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/dialog.dart';
import 'package:lucky_depot/vm/inventory_controller.dart';

class InventoryManagement extends StatelessWidget {
  InventoryManagement({super.key});

  final inventory = Get.put(InventoryController());

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_document),
                      onPressed: () {
                        CustomDialog.show(
                          context,
                          DialogType.addCategory,
                          onCategoryConfirm: (data) {
                            inventory.addCategory(
                              data['name']!,
                              double.parse(data['price']!),
                              data['image']!,
                              int.parse(data['quantity']!),
                              int.parse(data['category_id']!),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: inventory.categories.length,
                      itemBuilder: (context, index) {
                        final category = inventory.categories[index];
                        return ListTile(
                          title: Text(category),
                          selected:
                              inventory.selectedCategory.value == category,
                          onTap: () => inventory.selectCategory(category),
                        );
                      },
                    ),
                  ),
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
                    child: Obx(
                      () => GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    'http://192.168.50.38:8000/product/view/${product.image}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child:
                                              Icon(Icons.image_not_supported),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${product.quantity}',
                                                style: TextStyle(
                                                  color: product.quantity > 0
                                                      ? Colors.green
                                                      : Colors.red,
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
                                                radius: 12,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red,
                                                    size: 14,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () =>
                                                      CustomDialog.show(
                                                    context,
                                                    DialogType.delete,
                                                    customContent:
                                                        'Are you sure you want to delete "${product.name}"?',
                                                    onConfirm: () =>
                                                        inventory.deleteProduct(
                                                            product.id),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              IconButton(
                                                onPressed: () {
                                                  CustomDialog.show(
                                                    context,
                                                    DialogType.input,
                                                    customContent:
                                                        'Enter quantity to add for "${product.name}"',
                                                    onInputConfirm:
                                                        (String value) {
                                                      if (value.isNotEmpty) {
                                                        final quantity =
                                                            int.tryParse(value);
                                                        if (quantity != null &&
                                                            quantity > 0) {
                                                          inventory
                                                              .updateQuantity(
                                                                  product.id,
                                                                  quantity);
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Colors.blue,
                                                ),
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
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
                      ),
                    ),
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
