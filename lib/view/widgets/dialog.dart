import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/vm/inventory_controller.dart';

enum DialogType {
  success,
  delete,
  deleteSuccess,
  input,
  error,
  addCategory,
  addProduct,
}

class DialogConfig {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;
  final String? cancelText;
  final String? confirmText;

  DialogConfig({
    required this.title,
    required this.content,
    required this.icon,
    this.iconColor = Colors.green,
    this.cancelText,
    this.confirmText,
  });
}

class CustomDialog {
  static final Map<DialogType, DialogConfig> _dialogConfigs = {
    DialogType.success: DialogConfig(
      title: 'Success',
      content: 'Operation completed successfully',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    ),
    DialogType.delete: DialogConfig(
      title: 'Confirm Delete',
      content: 'Are you sure you want to delete this item?',
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      cancelText: 'Cancel',
      confirmText: 'Delete',
    ),
    DialogType.deleteSuccess: DialogConfig(
      title: 'Success',
      content: 'Item has been deleted successfully',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    ),
    DialogType.input: DialogConfig(
      title: 'Add Quantity',
      content: 'Enter the quantity to add',
      icon: Icons.add_circle_outline,
      iconColor: Colors.blue,
      cancelText: 'Cancel',
      confirmText: 'Add',
    ),
    DialogType.error: DialogConfig(
      title: 'Error',
      content: 'An error occurred',
      icon: Icons.error_outline,
      iconColor: Colors.red,
      confirmText: 'OK',
    ),
    DialogType.addCategory: DialogConfig(
      title: 'Add New Category',
      content: 'Enter category name',
      icon: Icons.category,
      iconColor: Colors.blue,
      cancelText: 'Cancel',
      confirmText: 'Add',
    ),
    DialogType.addProduct: DialogConfig(
      title: 'Add New Product',
      content: 'Enter product details',
      icon: Icons.add_shopping_cart,
      iconColor: Colors.blue,
      cancelText: 'Cancel',
      confirmText: 'Add',
    ),
  };

  static void show(
    BuildContext context,
    DialogType type, {
    String? customContent,
    Function(String)? onInputConfirm,
    Function(Map<String, String>)? onCategoryConfirm,
    VoidCallback? onConfirm,
  }) {
    final config = _dialogConfigs[type]!;
    
    // Controllers
    final TextEditingController categoryNameController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController inputController = TextEditingController();
    
    // Value Notifiers
    final ValueNotifier<String> selectedImage = ValueNotifier<String>('');
    final ValueNotifier<Uint8List?> imageBytes = ValueNotifier<Uint8List?>(null);
    
    // Category selection
    final categories = Get.find<InventoryController>().categories;
    final initialCategory = categories.where((c) => c != 'All').firstOrNull ?? categories[1];
    final ValueNotifier<String> selectedCategory = ValueNotifier<String>(initialCategory);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: type == DialogType.addProduct ? 1000 : 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    config.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 20,
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              if (type == DialogType.addCategory) ...[
                TextField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // 현재 카테고리 목록 표시
                const Text('Current Categories:', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.builder(
                    itemCount: categories.length - 1,  // 'All' 제외
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(categories[index + 1]),
                      );
                    },
                  ),
                ),
              ],

              if (type == DialogType.addProduct) ...[
                DropdownButtonFormField<String>(
                  value: selectedCategory.value,
                  items: categories
                      .where((category) => category != 'All')
                      .map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Category',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      selectedCategory.value = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<String>(
                  valueListenable: selectedImage,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              allowMultiple: false,
                            );
                            
                            if (result != null) {
                              final file = result.files.first;
                              selectedImage.value = file.name;
                              imageBytes.value = file.bytes;
                            }
                          },
                          child: Text(value.isEmpty ? 'Select Image' : 'Change Image'),
                        ),
                        if (value.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: imageBytes.value != null
                                ? Image.memory(
                                    imageBytes.value!,
                                    fit: BoxFit.contain,
                                  )
                                : const Center(
                                    child: Text('No image selected'),
                                  ),
                          ),
                          const SizedBox(height: 8),
                          Text('Selected: ${value.split('/').last}'),
                        ],
                      ],
                    );
                  },
                ),
              ],

              if (type == DialogType.input) ...[
                TextField(
                  controller: inputController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 40),
                    ),
                    child: Text(config.cancelText ?? 'Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (type == DialogType.addCategory) {
                        if (onCategoryConfirm != null) {
                          onCategoryConfirm({
                            'categoryName': categoryNameController.text,
                          });
                        }
                      } else if (type == DialogType.addProduct) {
                        if (onCategoryConfirm != null) {
                          onCategoryConfirm({
                            'name': nameController.text,
                            'price': priceController.text,
                            'image': selectedImage.value,
                            'quantity': quantityController.text,
                            'category_id': '${categories.indexOf(selectedCategory.value)}',
                            'imageBytes': base64Encode(imageBytes.value ?? Uint8List(0)),
                          });
                        }
                      } else if (type == DialogType.input && onInputConfirm != null) {
                        onInputConfirm(inputController.text);
                      } else if (onConfirm != null) {
                        onConfirm();
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 40),
                      backgroundColor: type == DialogType.delete ? Colors.red : Colors.blue,
                    ),
                    child: Text(config.confirmText ?? 'OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
