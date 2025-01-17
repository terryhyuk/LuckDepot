import 'package:get/get.dart';

class CustomDrawerController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  changeIndex(int index) {
    selectedIndex.value = index;
  }

  navigateToPage(int index) {
    changeIndex(index);
    switch (index) {
      case 0:
        Get.toNamed(
          '/',
          preventDuplicates: false,
        );
      case 1:
        Get.toNamed(
          '/sales',
          preventDuplicates: false,
        );
      case 2:
        Get.toNamed(
          '/inventory',
          preventDuplicates: false,
        );
      case 3:
        Get.toNamed(
          '/customer',
          preventDuplicates: false,
        );
      case 4:
        Get.toNamed(
          '/logistics',
          preventDuplicates: false,
        );
    }
  }
}
