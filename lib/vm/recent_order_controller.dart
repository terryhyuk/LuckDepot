import 'package:get/get.dart';
import 'package:lucky_depot/repository/customer_repository.dart';

class RecentOrderController extends GetxController {
  final CustomerRepository _repository = Get.find();
  final RxList<Map<String, dynamic>> recentOrders = <Map<String, dynamic>>[].obs;
  final RxString selectedSortColumn = 'date'.obs;
  final RxBool isAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentOrders();
  }

  fetchRecentOrders() async {
    try {
      final response = await _repository.resentOrder();
      recentOrders.value = List<Map<String, dynamic>>.from(response['result']);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: ${e.toString()}');
    }
  }

  sort(String columnName) {
    if (selectedSortColumn.value == columnName) {
      isAscending.toggle();
    } else {
      selectedSortColumn.value = columnName;
      isAscending.value = true;
    }

    recentOrders.sort((a, b) => isAscending.value
        ? a[columnName].compareTo(b[columnName])
        : b[columnName].compareTo(a[columnName]));
  }
}
