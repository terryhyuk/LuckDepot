import 'package:get/get.dart';
import 'package:lucky_depot/repository/product_detail.dart';

class SalesController extends GetxController {
  final ProductDetailRepository repository =
      Get.find<ProductDetailRepository>();

  final RxString selectedPeriod = 'year'.obs;
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> salesData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> topProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> changePeriod(String period) async {
    if (selectedPeriod.value != period) {
      selectedPeriod.value = period;
      await loadData();
    }
  }

  loadData() async {
    try {
      isLoading(true);

      switch (selectedPeriod.value) {
        case 'year':
          final response = await repository.getDetailYear();
          salesData.value =
              List<Map<String, dynamic>>.from(response['year_sales'] ?? []);
          topProducts.value =
              List<Map<String, dynamic>>.from(response['products'] ?? []);
          break;
        case 'month':
          final response = await repository.getDetailMonth();
          salesData.value =
              List<Map<String, dynamic>>.from(response['month_sales'] ?? []);
          topProducts.value =
              List<Map<String, dynamic>>.from(response['products'] ?? []);
          break;

        case 'week':
          final response = await repository.getDetailWeek();
          final weekdaySales =
              List<Map<String, dynamic>>.from(response['weekday_sales'] ?? []);
          salesData.value = weekdaySales.map((data) {
            return {
              'weekday': _convertWeekdayToNumber(data['weekday']),
              'sales': data['sales']
            };
          }).toList();
          topProducts.value =
              List<Map<String, dynamic>>.from(response['products'] ?? []);
          break;
      }
    } catch (e) {
      salesData.clear();
      topProducts.clear();
    } finally {
      isLoading(false);
    }
  }

  int _convertWeekdayToNumber(String weekday) {
    switch (weekday) {
      case '월':
        return 1;
      case '화':
        return 2;
      case '수':
        return 3;
      case '목':
        return 4;
      case '금':
        return 5;
      case '토':
        return 6;
      case '일':
        return 7;
      default:
        return 0;
    }
  }

  String _getWeekdayName(int number) {
    switch (number) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> getTopProducts() => topProducts.take(5).toList();
  List<Map<String, dynamic>> getSalesData() => salesData.toList();
  bool hasData() => topProducts.isNotEmpty || salesData.isNotEmpty;
  String getWeekdayName(int number) => _getWeekdayName(number);
}
