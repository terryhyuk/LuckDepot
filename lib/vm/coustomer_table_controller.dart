import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/customer.dart';

class CustomerTableController extends GetxController {
  final RxString selectedSort = 'Name'.obs;
  final List<String> sortOptions = ['Name', 'Email'];
  final searchController = TextEditingController();
  
  final RxList<Customer> customers = <Customer>[].obs;
  final RxList<Customer> filteredCustomers = <Customer>[].obs;

  @override
  onInit() {
    super.onInit();
    loadCustomers();
  }

  @override
  onClose() {
    searchController.dispose();
    super.onClose();
  }

  updateSort(String? value) {
    if (value != null) {
      selectedSort.value = value;
      sortCustomers();
    }
  }

  searchCustomers(String query) {
    filterCustomers();
  }

  sortCustomers() {
    // 정렬 로직
  }

  filterCustomers() {
    // 검색 로직
  }

  loadCustomers() async {
    // API에서 고객 데이터 로드
  }
}