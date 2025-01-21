// lib/viewmodel/inventory_management_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/product.dart';

class InventoryManagementController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  // Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final searchController = TextEditingController();
  
  // Observable variables
  final RxString selectedCategory = ''.obs;
  final RxList<String> categories = <String>[
    'Tables', 'Chairs', 'Bookcases', 'Storage',
    'Paper', 'Binders', 'Copiers', 'Envelopes', 'Fasteners'
  ].obs;
  
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 초기 데이터 로드
    loadProducts();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void updateCategory(String? category) {
    selectedCategory.value = category ?? '';
    filterProducts();
  }

  void searchProducts(String query) {
    filterProducts();
  }

  void filterProducts() {
    // 검색어와 카테고리에 따른 필터링 로직
  }

  Future<void> loadProducts() async {
    // API에서 상품 목록 로드
  }

  Future<void> saveProduct(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // API를 통한 상품 저장 로직
    }
  }

  Future<void> deleteProduct(BuildContext context, int index) async {
    // API를 통한 상품 삭제 로직
  }
}
