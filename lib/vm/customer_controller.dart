import 'package:get/get.dart';
import 'package:lucky_depot/repository/customer_repository.dart';

class CustomerController extends GetxController {
  final customerRepository = CustomerRepository();
  
  final RxInt totalCustomers = 0.obs;
  final RxDouble totalPayment = 0.0.obs;
  final RxDouble averagePurchase = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerStats();
  }

  fetchCustomerStats() async {
    final stats = await customerRepository.getCustomerStats();
    totalCustomers.value = stats['total_customers'];
    totalPayment.value = stats['total_payment'];
    averagePurchase.value = stats['average_purchase'];
  }
}
