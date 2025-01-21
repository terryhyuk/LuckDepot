import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/coustom_text_form_field.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/coustom_text_form_field_widget.dart';
import 'package:lucky_depot/vm/inventory_management_controller.dart';

class InventoryManagement extends StatelessWidget {
  InventoryManagement({super.key});

  final _controller = Get.put(InventoryManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomDrawer(),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Registration',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Row(
                      children: [
                        // 왼쪽: 상품 등록 폼
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _controller.formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'New Product Registration',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Obx(() => DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            labelText: 'Category',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: _controller.selectedCategory
                                                  .value.isEmpty
                                              ? null
                                              : _controller
                                                  .selectedCategory.value,
                                          hint: const Text('Select category'),
                                          items: _controller.categories
                                              .map((category) {
                                            return DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(category),
                                            );
                                          }).toList(),
                                          onChanged: _controller.updateCategory,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a category';
                                            }
                                            return null;
                                          },
                                        )),
                                    const SizedBox(height: 16),
                                    CustomTextFormFieldWidget(
                                      controller: _controller.nameController,
                                      config: TextFormFieldConfig(
                                        labelText: 'Product Name',
                                        textInputAction: TextInputAction.next,
                                      ),
                                      labelText: '',
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormFieldWidget(
                                      controller:
                                          _controller.descriptionController,
                                      config: TextFormFieldConfig(
                                        labelText: 'Description',
                                        textInputAction: TextInputAction.next,
                                      ),
                                      labelText: '',
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormFieldWidget(
                                      controller: _controller.priceController,
                                      config: TextFormFieldConfig(
                                        labelText: 'Price',
                                        isNumber: true,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      labelText: '',
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormFieldWidget(
                                      controller:
                                          _controller.quantityController,
                                      config: TextFormFieldConfig(
                                        labelText: 'Quantity',
                                        isNumber: true,
                                        textInputAction: TextInputAction.done,
                                      ),
                                      labelText: '',
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _controller.saveProduct(context),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                      ),
                                      child: const Text('Register Product'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // 오른쪽: 등록된 상품 목록
                        Expanded(
                          flex: 2,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Registered Products',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Obx(() => DropdownButton<String>(
                                                hint: const Text(
                                                    'Filter by Category'),
                                                value: _controller
                                                        .selectedCategory
                                                        .value
                                                        .isEmpty
                                                    ? null
                                                    : _controller
                                                        .selectedCategory.value,
                                                items: [
                                                  const DropdownMenuItem<
                                                      String>(
                                                    value: '',
                                                    child:
                                                        Text('All Categories'),
                                                  ),
                                                  ..._controller.categories
                                                      .map((String category) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: category,
                                                      child: Text(category),
                                                    );
                                                  }).toList(),
                                                ],
                                                onChanged:
                                                    _controller.updateCategory,
                                              )),
                                          const SizedBox(width: 16),
                                          SizedBox(
                                            width: 200,
                                            child: TextField(
                                              controller:
                                                  _controller.searchController,
                                              decoration: InputDecoration(
                                                hintText: 'Search products',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                              ),
                                              onChanged:
                                                  _controller.searchProducts,
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
                                      Expanded(
                                          flex: 2, child: Text('Category')),
                                      Expanded(
                                          flex: 3, child: Text('Description')),
                                      Expanded(flex: 1, child: Text('Price')),
                                      Expanded(
                                          flex: 1, child: Text('Quantity')),
                                      Expanded(flex: 1, child: Text('Actions')),
                                    ],
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: Obx(() => ListView.builder(
                                          itemCount: _controller
                                              .filteredProducts.length,
                                          itemBuilder: (context, index) {
                                            final product = _controller
                                                .filteredProducts[index];
                                            return Row(
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(product.name)),
                                                Expanded(
                                                    flex: 2,
                                                    child:
                                                        Text(product.category)),
                                                Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        product.description)),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        '\$${product.price}')),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                        '${product.quantity}')),
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete),
                                                    onPressed: () => _controller
                                                        .deleteProduct(
                                                            context, index),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
