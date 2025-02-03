import 'package:get/get.dart';
import 'package:lucky_depot/repository/customer_repository.dart';
import 'package:lucky_depot/repository/product_detail.dart';

class ChartController extends GetxController {
  final ProductDetailRepository repository =
      Get.find<ProductDetailRepository>();
  final CustomerRepository customerRepository = Get.find<CustomerRepository>();

  final RxList<Map<String, dynamic>> monthlyData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> yearSales = <Map<String, dynamic>>[].obs;
  final RxDouble totalPayment = 0.0.obs;
  final RxInt totalOrders = 0.obs;
  final RxBool isLoading = true.obs;

  // 최근 6개월 매출 데이터
  RxList<Map<String, dynamic>> recentMonthSales = <Map<String, dynamic>>[].obs;

  // 카테고리별 매출 데이터
  RxList<Map<String, dynamic>> categoryStats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

loadData() async {
  try {
    isLoading(true);

    // CustomerRepository에서 통계 데이터 가져오기
    final customerStats = await customerRepository.getCustomerStats();
    print('Customer Stats: $customerStats');
    totalPayment.value = (customerStats['sum'] as num?)?.toDouble() ?? 0.0;

    // order_count 합계 계산
    if (customerStats['result'] != null) {
      final customers = customerStats['result'] as List;
      totalOrders.value = customers.fold<int>(
        0,
        (sum, customer) => sum + (customer['order_count'] as int? ?? 0),
      );
    }

    final monthData = await repository.getDetailMonth();
    print('Month Data: $monthData');

    // 월간 데이터 처리
    if (monthData['products'] != null) {
      monthlyData.value = List<Map<String, dynamic>>.from(monthData['products']);
      
      // 최근 6개월 매출 데이터 처리
      recentMonthSales.value = monthlyData
          .take(6)
          .map((item) => {
                'name': item['name'] ?? '',
                'sales': item['total_price'] ?? 0,
              })
          .toList();
      print('Recent Sales: ${recentMonthSales.value}');
    }

    final yearData = await repository.getDetailYear();
    print('Year Data: $yearData');

    // 연간 매출 데이터 처리
    if (yearData['year_sales'] != null) {
      yearSales.value = List<Map<String, dynamic>>.from(yearData['year_sales']);
      print('Year Sales after setting: ${yearSales.value}');
    }

    // 제품 및 카테고리 데이터 처리
    if (yearData['products'] != null) {
      products.value = List<Map<String, dynamic>>.from(yearData['products']);

      // 제품별 통계 처리
      final productStats = <String, int>{};
      for (var product in products) {
        final name = product['name'] as String? ?? 'Other';
        final count = product['order_count'] as int? ?? 0;
        productStats[name] = (productStats[name] ?? 0) + count;
      }

      // 상위 6개 제품 추출
      categoryStats.value = productStats.entries
          .map((e) => {
                'category': e.key,
                'count': e.value,
              })
          .toList()
        ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

      if (categoryStats.length > 6) {
        categoryStats.value = categoryStats.take(6).toList();
      }
      
      print('Category Stats: ${categoryStats.value}');
    }

  } catch (e) {
    print('Error loading data: $e');
    Get.snackbar('Error', 'Failed to load data');
  } finally {
    isLoading(false);
  }
}



  // 최근 6개월 매출 데이터 getter
  List<Map<String, dynamic>> getRecentMonthSales() {
    return recentMonthSales.toList();
  }

  // 카테고리별 매출 상위 6개 데이터 getter
  List<Map<String, dynamic>> getTopCategories() {
    return categoryStats.take(6).toList();
  }

  // 연간 매출 데이터 getter
  List<Map<String, dynamic>> getYearSales() {
    return yearSales.toList();
  }

  // 상위 판매 제품 데이터 getter
  List<Map<String, dynamic>> getTopProducts() {
    return products
        .take(5)
        .map((product) => {
              'name': product['name'],
              'sales': product['total_price'],
              'count': product['order_count'],
            })
        .toList();
  }
}
