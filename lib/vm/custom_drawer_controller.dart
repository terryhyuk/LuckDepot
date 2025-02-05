import 'package:get/get.dart';

class CustomDrawerController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxString currentRouter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // 초기 라우트 설정
    currentRouter.value = Get.currentRoute;

    // 라우트 변경 감지
    ever(currentRouter, (_) {
      update();
    });
  }

  updateRoute(String route) {
    currentRouter.value = route;
  }

  bool isCurrentRoute(String route) {
    return currentRouter.value == route;
  }

  changeIndex(int index) {
    selectedIndex.value = index;
  }

navigateToPage(int index) {
    changeIndex(index);
    switch (index) {
      case 0:
        updateRoute('/'); // 라우트 업데이트
        Get.toNamed(
          '/',
          preventDuplicates: false,
        );
      case 1:
        updateRoute('/sales');  
        Get.toNamed(
          '/sales',
          preventDuplicates: false,
        );
      case 2:
        updateRoute('/inventory'); 
        Get.toNamed(
          '/inventory',
          preventDuplicates: false,
        );
      case 3:
        updateRoute('/customer'); 
        Get.toNamed(
          '/customer',
          preventDuplicates: false,
        );
      case 4:
        updateRoute('/logistics');
        Get.toNamed(
          '/logistics',
          preventDuplicates: false,
        );
      case 5:
        updateRoute('/delivery_driver');
        Get.toNamed(
          '/delivery_driver',
          preventDuplicates: false,
        );
      case 6:
        updateRoute('/login');
        Get.toNamed(
          '/login',
          preventDuplicates: true,
        );  
    }
  }
}