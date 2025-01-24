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
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        child: Row(
          children: [
            CustomDrawer(),
            Container(
              width: 250,
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
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              CustomDialog.show(
                                context,
                                DialogType.addCategory,
                                onCategoryConfirm: (data) {
                                  if (data.isNotEmpty) {
                                    inventory.addNewCategory(
                                        data['categoryName'] ?? '');
                                  }
                                },
                              );
                            },
                            child: const Text('Add Category'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (inventory.selectedCategory.value != 'All') {
                                CustomDialog.show(
                                  context,
                                  DialogType.addProduct,
                                  onCategoryConfirm: (data) {
                                    if (data.isNotEmpty) {
                                      inventory.addProduct(
                                        data['name'] ?? '',
                                        data['price'] ?? '0',
                                        data['image'] ?? '',
                                        data['quantity'] ?? '0',
                                        data['category_id'] ?? '0',
                                        data['imageBytes'] ?? '',
                                      );
                                    }
                                  },
                                );
                              }
                            },
                            child: const Text('Add Product'),
                          ),
                        ],
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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        const Text(
                          'Inventory Management',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            controller: inventory.searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: inventory.searchProducts,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: inventory.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = inventory.filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    width: 1000,
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Product Details',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              splashRadius: 20,
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        const SizedBox(height: 16),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                'http://192.168.50.38:8000/product/view/${product.image}',
                                                width: 300,
                                                height: 300,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  return Container(
                                                    width: 300,
                                                    height: 300,
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          size: 48),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 24),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.name,
                                                    style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    'Price: \$${product.price.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Quantity: ${product.quantity}',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              product.quantity > 0
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                        ),
                                                      ),
                                                      const Text(' pcs',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    'Category: ${product.category}',
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 24),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton.icon(
                                                        onPressed: () =>
                                                            CustomDialog.show(
                                                          context,
                                                          DialogType.input,
                                                          customContent:
                                                              'Enter quantity to add for "${product.name}"',
                                                          onInputConfirm:
                                                              (String value) {
                                                            if (value
                                                                .isNotEmpty) {
                                                              final quantity =
                                                                  int.tryParse(
                                                                      value);
                                                              if (quantity !=
                                                                      null &&
                                                                  quantity > 0) {
                                                                inventory
                                                                    .updateQuantity(
                                                                        product
                                                                            .id,
                                                                        quantity);
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            }
                                                          },
                                                        ),
                                                        icon:
                                                            const Icon(Icons.add),
                                                        label: const Text(
                                                            'Add Quantity'),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      ElevatedButton.icon(
                                                        onPressed: () =>
                                                            CustomDialog.show(
                                                          context,
                                                          DialogType.delete,
                                                          customContent:
                                                              'Are you sure you want to delete "${product.name}"?',
                                                          onConfirm: () {
                                                            inventory
                                                                .deleteProduct(
                                                                    product.id);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        label: const Text(
                                                            'Delete Product'),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      OutlinedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child:
                                                            const Text('Cancel'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Card(
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Image.network(
                                            'http://192.168.50.38:8000/product/view/${product.image}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Quantity: ${product.quantity}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
