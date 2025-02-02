import 'package:get/get.dart';
import 'package:lucky_depot/repository/product_detail.dart';

class ChartController extends GetxController {
  final ProductDetailRepository repository = ProductDetailRepository();
  final RxList<Map<String, dynamic>> monthlyData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> yearSales = <Map<String, dynamic>>[].obs;
  final RxDouble totalPayment = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading(true);
      final monthData = await repository.getDetailMonth();
      final yearData = await repository.getDetailYear();

      // 월간 데이터 처리
      monthlyData.value = List<Map<String, dynamic>>.from(
        monthData['result'] as List<dynamic>? ?? [],
      );

      // 총 주문 수 및 결제액 계산
      if (monthlyData.isNotEmpty) {
        totalPayment.value = monthlyData
            .map((e) => (e['total_price'] as int? ?? 0))
            .reduce((a, b) => a + b)
            .toDouble();
        totalOrders.value = monthlyData
            .map((e) => (e['order_count'] as int? ?? 0))
            .reduce((a, b) => a + b);
      } else {
        totalPayment.value = 0.0;
        totalOrders.value = 0;
      }

      // 연간 데이터 처리
      final yearResult = yearData['result'] as Map<String, dynamic>? ?? {};
      products.value = List<Map<String, dynamic>>.from(
        yearResult['products'] as List<dynamic>? ?? [],
      );
      yearSales.value = List<Map<String, dynamic>>.from(
        yearResult['year_sales'] as List<dynamic>? ?? [],
      );
    } catch (e) {
      print('Error loading data: $e');
      Get.snackbar('Error', 'Failed to load data');
    } finally {
      isLoading(false);
    }
  }
}
