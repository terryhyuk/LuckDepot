import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/coustom_text_form_field.dart';
import 'package:lucky_depot/vm/custom_drawer_controller.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  late List<String> categories = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // 컨트롤러 초기화
    Get.put(CustomDrawerController());
    categories = [
      'Tables',
      'Chairs',
      'Bookcases',
      'Storage',
      'Paper',
      'Binders',
      'Copiers',
      'Envelopes',
      'Fasteners'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 왼쪽 메인 드로워
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
                                    // 카테고리 선택 드롭다운
                                    DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Category',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: selectedCategory,
                                      items: categories.map((String category) {
                                        return DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(category),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedCategory = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a category';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      controller: TextEditingController(),
                                      labelText: 'Product Name',
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      controller: TextEditingController(),
                                      labelText: 'Description',
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      controller: TextEditingController(),
                                      labelText: 'Price',
                                      isNumber: true,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      controller: TextEditingController(),
                                      labelText: 'Quantity',
                                      isNumber: true,
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () {},
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
                                      // 카테고리 필터 드롭다운
                                      DropdownButton<String>(
                                        hint: const Text('Filter by Category'),
                                        value: selectedCategory,
                                        items: [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text('All Categories'),
                                          ),
                                          ...categories.map((String category) {
                                            return DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(category),
                                            );
                                          }).toList(),
                                        ],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedCategory = newValue;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: 0,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          child: ListTile(
                                            title: const Text('Product Name'),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Category'),
                                                const Text('Description'),
                                                const Text('Price: \$0'),
                                                const Text('Quantity: 0'),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                      },
                                    ),
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
