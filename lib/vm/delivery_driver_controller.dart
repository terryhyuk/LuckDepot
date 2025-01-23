import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/driver.dart';
import 'package:lucky_depot/model/driver_repository.dart';
import 'package:lucky_depot/view/widgets/dialog.dart';

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
        CustomDialog.show(
          context, 
          DialogType.success,
          customContent: 'Driver has been registered successfully'
        );
      }
    }
  }

  deleteDriver(BuildContext context, int index) async {
    if (context.mounted) {
      CustomDialog.show(
        context, 
        DialogType.delete,
        customContent: 'Are you sure you want to delete this driver?',
        onConfirm: () async {
          await _repository.deleteDriver(index);
          if (context.mounted) {
            CustomDialog.show(
              context, 
              DialogType.success,
              customContent: 'Driver has been deleted successfully'
            );
          }
        },
      );
    }
  }

  ValueListenable getDriverListenable() {
    return _repository.getDriverListenable();
  }
}
