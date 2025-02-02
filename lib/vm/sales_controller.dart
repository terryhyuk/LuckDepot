import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/repository/product_detail.dart';

class SalesController extends GetxController {
  final ProductDetailRepository repository = ProductDetailRepository();
  final RxList<Map<String, dynamic>> topSellingItems = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> salesTrends = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> salesByProduct = <Map<String, dynamic>>[].obs;
  final RxString selectedPeriod = 'month'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  changePeriod(String period) async {
    selectedPeriod.value = period;
    await loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading(true);
      Map<String, dynamic> data;
      switch (selectedPeriod.value) {
        case 'year':
          data = await repository.getDetailYear();
          break;
        case 'week':
          data = await repository.getDetailWeek();
          break;
        default:
          data = await repository.getDetailMonth();
      }

      salesTrends.value = (data['weekday_sales'] as List<dynamic>? ?? [])
          .map((item) => {
                'weekday': item['weekday'] as int? ?? 0,
                'sales': item['sales'] as int? ?? 0,
              })
          .toList();

      salesByProduct.value = (data['products'] as List<dynamic>? ?? [])
          .map((item) => item as Map<String, dynamic>)
          .toList();

      topSellingItems.value = List<Map<String, dynamic>>.from(salesByProduct)
        ..sort((a, b) {
          final aCount = a['order_count'] as int? ?? 0;
          final bCount = b['order_count'] as int? ?? 0;
          return bCount.compareTo(aCount);
        });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
