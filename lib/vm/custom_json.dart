// lib/model/customer_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomJson {
  final String baseUrl = 'your_api_endpoint';

  Future<Map<String, dynamic>> getCustomerStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customer/stats'));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'total_customers': 0,
          'total_payment': 0.0,
          'average_purchase': 0.0,
        };
      }
    } catch (e) {
      print('Error fetching customer stats: $e');
      return {
        'total_customers': 0,
        'total_payment': 0.0,
        'average_purchase': 0.0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getCustomerList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/customers'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching customer list: $e');
      return [];
    }
  }
}
