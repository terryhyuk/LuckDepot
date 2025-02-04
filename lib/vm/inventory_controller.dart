import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/dialog.dart';
import '../repository/product_repository.dart';
import '../model/product.dart';
import 'package:http/http.dart' as http;

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

    final categoryList = await productRepository.getCategories();
    if (categoryList.isNotEmpty) {
      categories.clear();
      categories.add('All');
      categories.addAll(categoryList);
      categories.refresh();  // UI 업데이트
    }

  }

  // 상품 목록 로드
  loadProducts() async {
    final productList = await productRepository.getProducts();
    products.assignAll(productList);
    filterProducts();

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
        CustomDialog.show(
          Get.context!,
          DialogType.success,
          customContent: 'Category added successfully',
        );
      } else {
        CustomDialog.show(
          Get.context!,
          DialogType.error,
          customContent: 'Failed to add category',
        );
      }
    } catch (e) {
      CustomDialog.show(
        Get.context!,
        DialogType.error,
        customContent: 'Failed to add category',
      );
    }
  }

  // 상품 추가 메서드
  Future<void> addProduct(String name, String price, String image, String quantity,
      String categoryId, String imageBytes) async {
    try {
      // 1. 이미지 업로드
      var imageRequest = http.MultipartRequest(
        'POST', 
        Uri.parse('${productRepository.url}/product/image/')
      );
      imageRequest.files.add(
        http.MultipartFile.fromBytes(
          'file',
          base64Decode(imageBytes),
          filename: image
        )
      );
      
      var imageResponse = await imageRequest.send();
      if (imageResponse.statusCode == 200) {
        // 2. 상품 정보 저장
        final success = await productRepository.addProduct(
          name,
          price,
          image,
          quantity,
          categoryId,
          imageBytes,
        );
        
        if (success) {
          await loadProducts();
          CustomDialog.show(
            Get.context!,
            DialogType.success,
            customContent: 'Product added successfully',
          );
        }
      } else {
        CustomDialog.show(
          Get.context!,
          DialogType.error,
          customContent: 'Failed to upload image',
        );
      }
    } catch (e) {
      CustomDialog.show(
        Get.context!,
        DialogType.error,
        customContent: 'Failed to add product',
      );
    }
  }
  
}
