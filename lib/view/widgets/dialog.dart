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
      title: 'Add New Product',
      content: 'Enter product details',
      icon: Icons.edit,
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
    final TextEditingController inputController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final ValueNotifier<int> selectedCategoryId = ValueNotifier<int>(1);
    final ValueNotifier<String> selectedImage = ValueNotifier<String>('');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                config.icon,
                color: config.iconColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                config.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(customContent ?? config.content),
              if (type == DialogType.input) ...[
                const SizedBox(height: 16),
                MouseRegion(
                  cursor: SystemMouseCursors.text,
                  child: TextField(
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
                ),
              ],
              if (type == DialogType.addCategory) ...[
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
                ValueListenableBuilder<int>(
                  valueListenable: selectedCategoryId,
                  builder: (context, value, child) {
                    final categories =
                        Get.find<InventoryController>().categories;
                    return DropdownButtonFormField<int>(
                      value: value,
                      items: List.generate(categories.length, (index) {
                        final category = categories[index];
                        return DropdownMenuItem<int>(
                          value: index, // All은 0, Tables는 1, ...
                          child: Text(category),
                        );
                      }),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (newValue) {
                        selectedCategoryId.value = newValue!;
                      },
                    );
                  },
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
                              selectedImage.value = file.name; // 파일 이름만 저장

                              // bytes는 별도로 처리해야 함
                              final bytes = file.bytes;
                              // TODO: bytes 데이터를 처리하는 로직 추가
                            }
                          },
                          child: Text(selectedImage.value.isEmpty
                              ? 'Select Image'
                              : 'Change Image'),
                        ),
                        if (value.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Selected: ${value.split('/').last}'),
                        ],
                      ],
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
              if (config.cancelText != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(120, 40),
                      ),
                      child: Text(config.cancelText!),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (type == DialogType.input &&
                            onInputConfirm != null) {
                          onInputConfirm(inputController.text);
                          if (inputController.text.isNotEmpty) {
                            final quantity = int.tryParse(inputController.text);
                            if (quantity != null && quantity > 0) {
                              show(
                                context,
                                DialogType.success,
                                customContent:
                                    '$quantity items have been added successfully',
                              );
                            }
                          }
                        } else if (type == DialogType.addCategory &&
                            onCategoryConfirm != null) {
                          onCategoryConfirm({
                            'name': nameController.text,
                            'price': priceController.text,
                            'quantity': quantityController.text,
                            'category_id': selectedCategoryId.value.toString(),
                            'image': selectedImage.value,
                          });
                        } else if (onConfirm != null) {
                          onConfirm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 40),
                        backgroundColor: type == DialogType.delete
                            ? Colors.red
                            : Colors.blue,
                      ),
                      child: Text(config.confirmText ?? 'OK'),
                    ),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 40),
                  ),
                  child: Text(config.confirmText ?? 'OK'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
