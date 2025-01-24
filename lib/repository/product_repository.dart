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

  Future<bool> deleteProduct(int productId) async {
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
  addProduct(String name, String price, String image, String quantity,
    String categoryId, String imageBytes) async {
  try {
    // 1. 이미지 업로드
    var imageRequest = http.MultipartRequest(
      'POST', 
      Uri.parse('$url/product/image/')  // 올바른 이미지 업로드 엔드포인트
    );
    imageRequest.files.add(
      http.MultipartFile.fromBytes(
        'file',
        base64Decode(imageBytes),
        filename: image
      )
    );
    
    var imageResponse = await imageRequest.send();
    print('Image upload status: ${imageResponse.statusCode}');
    
    if (imageResponse.statusCode == 200) {
      // 2. 상품 정보 저장
      final response = await http.post(
        Uri.parse('$url/product/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'price': int.parse(price),
          'image': image,
          'quantity': int.parse(quantity),
          'category_id': int.parse(categoryId)
        }),
      );
      
      print('Product creation status: ${response.statusCode}');
      return response.statusCode == 201;
    }
    return false;
  } catch (e) {
    print('Error adding product: $e');
    return false;
  }
}


  // 수량 업데이트
  updateQuantity(int productId, int additionalQuantity) async {
    try {
      // 현재 상품 정보 가져오기
      final productResponse = await http.get(Uri.parse('$url/product/$productId'));
      if (productResponse.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(productResponse.body);
        if (responseData['result'] != null) {
          final currentQuantity = responseData['result']['quantity'] as int;
          final newQuantity = currentQuantity + additionalQuantity;

          final response = await http.put(
            Uri.parse('$url/product/$productId/?quantity=$newQuantity'),
            headers: {'Content-Type': 'application/json'},
          );
          print('Response status: ${response.statusCode}');
          print('Response body: ${utf8.decode(response.bodyBytes)}');
          return response.statusCode == 200;
        }
      }
      return false;
    } catch (e) {
      print('Error updating quantity: $e');
      return false;
    }
  }

  // 카테고리 추가
  addNewCategory(String categoryName) async {
    try {
      final response = await http.post(
        Uri.parse('$url/category/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': categoryName
        }),
      );
      print('Category Response status: ${response.statusCode}');
      print('Category Response body: ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      print('Error adding category: $e');
      return false;
    }
  }

  // 카테고리 목록 조회
  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$url/category/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['result'] != null && responseData['result'] is List) {
          final List<dynamic> data = responseData['result'];
          return data.map((item) => item['name'].toString()).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
