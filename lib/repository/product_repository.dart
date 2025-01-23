// lib/repository/product_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class ProductRepository {
  final String url = 'http://192.168.50.38:8000';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$url/product/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['result'] != null && responseData['result'] is List) {
          final List<dynamic> data = responseData['result'];
          return data.map((json) => Product.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$url/product/$productId'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // 새 상품 추가
  addProduct(String name, double price, String image, int quantity,
      int categoryId) async {
    try {
      final response = await http.post(
        Uri.parse('$url/product/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': price,
          'image': image,
          'quantity': quantity,
          'category_id': categoryId
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // 수량 업데이트
  updateQuantity(int productId, int quantity) async {
  try {
    final response = await http.put(
      Uri.parse('$url/product/$productId/?quantity=$quantity'),
      headers: {'Content-Type': 'application/json'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${utf8.decode(response.bodyBytes)}');  // utf8.decode 사용
    return response.statusCode == 200;
  } catch (e) {
    print('Error updating quantity: $e');
    return false;
  }
}

// 카테고리 추가
addCategory(String name, double price, String image, int quantity, int categoryId) async {
  try {
    final response = await http.post(
      Uri.parse('$url/product/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'price': price,
        'image': image,
        'quantity': quantity,
        'category_id': categoryId,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${utf8.decode(response.bodyBytes)}');
    return response.statusCode == 200;
  } catch (e) {
    print('Error adding product: $e');
    return false;
  }
}
}
