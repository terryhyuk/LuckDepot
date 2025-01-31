import 'package:get/get.dart';
import 'package:lucky_depot/repository/product_detail.dart';

class ChartController extends GetxController {
  final ProductDetailRepository repository = ProductDetailRepository();
  final RxList<Map<String, dynamic>> monthlyData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> categoryData = <Map<String, dynamic>>[].obs;
  final RxDouble totalPayment = 0.0.obs;
  final RxInt totalOrders = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData() async {
    final monthData = await repository.getDetailMonth();
    final yearData = await repository.getDetailYear();
    
    if (monthData['result'] != null) {
      monthlyData.value = List<Map<String, dynamic>>.from(monthData['result']);
      // 총 매출액 계산
      totalPayment.value = monthlyData
          .map((e) => e['total_price'] as int)
          .reduce((a, b) => a + b)
          .toDouble();
      // 총 주문 수 계산
      totalOrders.value = monthlyData
          .map((e) => e['order_count'] as int)
          .reduce((a, b) => a + b);
    }
    if (yearData['result'] != null) {
      categoryData.value = List<Map<String, dynamic>>.from(yearData['result']);
    }
  }
}
