import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/driver.dart';
import 'package:lucky_depot/model/driver_repository.dart';

enum DialogType {
  success,
  delete,
  deleteSuccess
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

class DeliveryDriverController extends GetxController {
  final DriverRepository _repository = DriverRepository();
  final formKey = GlobalKey<FormState>();
  
  // Controllers
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final isRegular = false.obs;

  final Map<DialogType, DialogConfig> _dialogConfigs = {
    DialogType.success: DialogConfig(
      title: 'Success',
      content: 'Driver has been registered successfully',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    ),
    DialogType.delete: DialogConfig(
      title: 'Confirm Delete',
      content: 'Are you sure you want to delete this driver?',
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      cancelText: 'Cancel',
      confirmText: 'Delete',
    ),
    DialogType.deleteSuccess: DialogConfig(
      title: 'Success',
      content: 'Driver has been deleted successfully',
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
    ),
  };

  @override
  onClose() {
    nameController.dispose();
    idController.dispose();
    passwordController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  clearForm() {
    nameController.clear();
    idController.clear();
    passwordController.clear();
    emailController.clear();
    phoneController.clear();
    isRegular.value = false;
  }

  showCustomDialog(BuildContext context, DialogType type, {VoidCallback? onConfirm}) {
    final config = _dialogConfigs[type]!;
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
              Text(config.content),
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
                        onConfirm?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 40),
                        backgroundColor: Colors.red,
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

  saveDriver(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final driver = Driver(
        driverNum: (_repository.getDriverListenable()).value.length + 1,
        name: nameController.text,
        id: idController.text,
        password: passwordController.text,
        email: emailController.text,
        phone: int.parse(phoneController.text),
        isRegular: isRegular.value,
      );

      await _repository.addDriver(driver);
      clearForm();

      if (context.mounted) {
        showCustomDialog(context, DialogType.success);
      }
    }
  }

  deleteDriver(BuildContext context, int index) async {
    if (context.mounted) {
      showCustomDialog(
        context, 
        DialogType.delete,
        onConfirm: () async {
          await _repository.deleteDriver(index);
          if (context.mounted) {
            showCustomDialog(context, DialogType.deleteSuccess);
          }
        },
      );
    }
  }

  ValueListenable getDriverListenable() {
    return _repository.getDriverListenable();
  }
}
