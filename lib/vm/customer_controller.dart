import 'package:get/get.dart';
import 'package:lucky_depot/repository/customer_repository.dart';

import 'package:flutter/widgets.dart';
import 'package:lucky_depot/model/customer.dart';

class CustomerController extends GetxController {
  final customerRepository = CustomerRepository();
  final searchController = TextEditingController();

  final Rx<CustomerResponse?> customerResponse = Rx<CustomerResponse?>(null);

  // 통계 데이터
  final RxInt totalCustomers = 0.obs;
  final RxDouble totalPayment = 0.0.obs;
  final RxDouble averagePurchase = 0.0.obs;

  // 테이블 관련 데이터
  final RxString selectedSort = 'Name'.obs;
  final List<String> sortOptions = ['Name', 'Email'];
  final RxList<Customer> customers = <Customer>[].obs;
  final RxList<Customer> filteredCustomers = <Customer>[].obs;
  final RxList<Map<String, dynamic>> recentOrders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerStats();
    fetchRecentOrders();
    loadCustomers();
    
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

    fetchRecentOrders() async {
    try {
      final response = await customerRepository.resentOrder();
      if (response['result'] != null) {
        recentOrders.value = List<Map<String, dynamic>>.from(response['result']);
      }
    } catch (e) {
      print('Error fetching recent orders: $e');
    }
  }


  // 통계 데이터 로드
  fetchCustomerStats() async {
    final stats = await customerRepository.getCustomerStats();
    print(stats);
    totalCustomers.value = stats['sum'];
    averagePurchase.value = stats['avg'];
  }

  // 고객 데이터 로드
  loadCustomers() async {
    try {
      final response = await customerRepository.getCustomerStats();
      customerResponse.value = CustomerResponse.fromJson(response);
      customers.assignAll(customerResponse.value?.customers ?? []);
      filteredCustomers.assignAll(customers);
    } catch (e) {
      print('Error loading customers: $e');
    }
  }

  // 정렬 관련
  updateSort(String? value) {
    if (value != null) {
      selectedSort.value = value;
      sortCustomers();
    }
  }

  sortCustomers() {
    final sorted = List<Customer>.from(filteredCustomers);
    if (selectedSort.value == 'Name') {
      sorted.sort((a, b) => a.name.compareTo(b.name));
    } else if (selectedSort.value == 'Email') {
      sorted.sort((a, b) => a.email.compareTo(b.email));
    }
    filteredCustomers.assignAll(sorted);
  }

  // 검색 관련
  searchCustomers(String query) {
    filterCustomers();
  }

  filterCustomers() {
    if (searchController.text.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      filteredCustomers.value = customers.where((customer) {
        return customer.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            customer.email
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
      }).toList();
    }
    sortCustomers();
  }
}
