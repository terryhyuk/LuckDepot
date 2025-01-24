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
    loadCategories();  // 카테고리 목록 로드 추가
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // 카테고리 목록 로드
  loadCategories() async {
    try {
      final categoryList = await productRepository.getCategories();
      if (categoryList.isNotEmpty) {
        categories.clear();
        categories.add('All');
        categories.addAll(categoryList);
        categories.refresh();  // UI 업데이트
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // 상품 목록 로드
  loadProducts() async {
    try {
      final productList = await productRepository.getProducts();
      products.assignAll(productList);
      filterProducts();
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  // 상품 필터링 (검색 및 카테고리)
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
      final success = await productRepository.updateQuantity(productId, quantity);
      if (success) {
        await loadProducts();  // await 추가
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
        await loadProducts();  // await 추가
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

  addNewCategory(String categoryName) async {
    try {
      final success = await productRepository.addNewCategory(categoryName);
      if (success) {
        await loadCategories();  // 카테고리 목록 새로고침
        return true;
      }
      return false;
    } catch (e) {
      print('Error adding new category: $e');
      return false;
    }
  }

  // 상품 추가 메서드 수정
  addProduct(String name, String price, String image, String quantity,
      String categoryId, String imageBytes) async {
    try {
      final success = await productRepository.addProduct(
        name,
        price,
        image,
        quantity,
        categoryId,
        imageBytes,
      );
      if (success) {
        await loadProducts();    // 상품 목록 새로고침
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

  // 카테고리와 상품을 함께 추가하는 메서드
  addCategoryAndProduct(String categoryName, String name, String price, 
      String image, String quantity, String categoryId, String imageBytes) async {
    try {
      // 1. 새 카테고리 추가
      if (categoryId == '1') {  // 새 카테고리인 경우
        final categorySuccess = await addNewCategory(categoryName);
        if (!categorySuccess) {
          CustomDialog.show(
            Get.context!,
            DialogType.error,
            customContent: 'Failed to add category',
          );
          return;
        }
      }

      // 2. 상품 추가
      await addProduct(
        name,
        price,
        image,
        quantity,
        categoryId,
        imageBytes,
      );
    } catch (e) {
      print('Error in addCategoryAndProduct: $e');
      CustomDialog.show(
        Get.context!,
        DialogType.error,
        customContent: 'Failed to add category and product',
      );
    }
  }
  
}
