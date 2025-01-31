import 'package:get/get.dart';
import 'package:lucky_depot/repository/product_detail.dart';

class SalesController extends GetxController {
  final ProductDetailRepository repository = ProductDetailRepository();
  final RxList<Map<String, dynamic>> topSellingItems = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> salesTrends = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> salesByProduct = <Map<String, dynamic>>[].obs;
  final RxString selectedPeriod = 'month'.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> changePeriod(String period) async {
    selectedPeriod.value = period;
    await loadData();
  }

  Future<void> loadData() async {
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

    if (data['result'] != null) {
      salesTrends.value = List<Map<String, dynamic>>.from(data['result']);
      salesByProduct.value = List<Map<String, dynamic>>.from(data['result']);
      topSellingItems.value = List<Map<String, dynamic>>.from(data['result'])
        ..sort((a, b) => (b['order_count'] as int).compareTo(a['order_count'] as int));
    }
  }
}
