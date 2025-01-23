import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/product_repository.dart';
import '../model/product.dart';

class InventoryController extends GetxController {
  final productRepository = ProductRepository();
  final searchController = TextEditingController();
  
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxList<String> categories = <String>[
    'All',
    'Tables', 'Chairs', 'Bookcases', 'Storage',
    'Paper', 'Binders', 'Copiers', 'Envelopes', 'Fasteners'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  loadProducts() async {
    try {
      final productList = await productRepository.getProducts();
      products.assignAll(productList);
      filterProducts();
    } catch (e) {
      print('Error loading products: $e');
    }
  }

filterProducts() {
  if (searchController.text.isEmpty && (selectedCategory.value.isEmpty || selectedCategory.value == 'All')) {
    filteredProducts.assignAll(products);
  } else {
    filteredProducts.value = products.where((product) {
      final matchesSearch = searchController.text.isEmpty || 
        product.name.toLowerCase().contains(searchController.text.toLowerCase());
      final matchesCategory = selectedCategory.value == 'All' || 
        selectedCategory.value.isEmpty || 
        product.categoryName == selectedCategory.value;
      return matchesSearch && matchesCategory;
    }).toList();
  }
}



  searchProducts(String query) => filterProducts();

  selectCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  increaseQuantity(int productId) async {
    await _updateQuantity(productId, 1, 'increased');
  }

  decreaseQuantity(int productId) async {
    await _updateQuantity(productId, -1, 'decreased');
  }

  _updateQuantity(int productId, int change, String action) async {
    try {
      final success = await productRepository.updateQuantity(productId, change);
      if (success) {
        loadProducts();
        Get.snackbar(
          'Success',
          'Quantity $action',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error ${action} quantity: $e');
      Get.snackbar(
        'Error',
        'Failed to $action quantity',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  deleteProduct(int productId) async {
    try {
      final success = await productRepository.deleteProduct(productId);
      if (success) {
        loadProducts();
        Get.snackbar(
          'Success',
          'Product deleted',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error deleting product: $e');
      Get.snackbar(
        'Error',
        'Failed to delete product',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
