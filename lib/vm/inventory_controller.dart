import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/dialog.dart';
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
    'Tables',
    'Chairs',
    'Bookcases',
    'Storage',
    'Paper',
    'Binders',
    'Copiers',
    'Envelopes',
    'Fasteners'
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
    if (searchController.text.isEmpty &&
        (selectedCategory.value.isEmpty || selectedCategory.value == 'All')) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.value = products.where((product) {
        final matchesSearch = searchController.text.isEmpty ||
            product.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
        final matchesCategory = selectedCategory.value == 'All' ||
            selectedCategory.value.isEmpty ||
            product.category == selectedCategory.value;
        return matchesSearch && matchesCategory;
      }).toList();
    }
  }

  searchProducts(String query) => filterProducts();

  selectCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  updateQuantity(int productId, int quantity) async {
    try {
      final success =
          await productRepository.updateQuantity(productId, quantity);
      if (success) {
        loadProducts();
      }
    } catch (e) {
      print('Error updating quantity: $e');
      CustomDialog.show(
        Get.context!,
        DialogType.error,
        customContent: 'Failed to update quantity',
      );
    }
  }

  deleteProduct(int productId) async {
    try {
      final success = await productRepository.deleteProduct(productId);
      if (success) {
        loadProducts();
        CustomDialog.show(
          Get.context!,
          DialogType.deleteSuccess,
          customContent: 'Product has been deleted successfully',
        );
      }
    } catch (e) {
      print('Error deleting product: $e');
      CustomDialog.show(
        Get.context!,
        DialogType.error,
        customContent: 'Failed to delete product',
      );
    }
  }

  addCategory(String name, double price, String image, int quantity,
      int categoryId) async {
    try {
      final success = await productRepository.addCategory(
        name,
        price,
        image,
        quantity,
        categoryId,
      );
      if (success) {
        // 새 카테고리 추가 (아직 리스트에 없는 경우에만)
        final categoryName =
            getCategoryName(categoryId); // categoryId에 해당하는 카테고리명 가져오기
        if (!categories.contains(categoryName)) {
          categories.add(categoryName);
        }
        loadProducts();
        CustomDialog.show(
          Get.context!,
          DialogType.success,
          customContent: 'Product added successfully',
        );
      }
    } catch (e) {
      print('Error adding product: $e');
      CustomDialog.show(
        Get.context!,
        DialogType.error,
        customContent: 'Failed to add product',
      );
    }
  }

// categoryId로 카테고리명 가져오는 메서드
  String getCategoryName(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'Tables';
      case 2:
        return 'Chairs';
      case 3:
        return 'Bookcases';
      case 4:
        return 'Storage';
      case 5:
        return 'Paper';
      case 6:
        return 'Binders';
      case 7:
        return 'Copiers';
      case 8:
        return 'Envelopes';
      case 9:
        return 'Fasteners';
      default:
        return '';
    }
  }
}
