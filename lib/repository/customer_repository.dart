// lib/repository/customer_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/customer.dart';

class CustomerRepository {
  final String url = 'http://192.168.50.38:8000';

  Future<Map<String, dynamic>> getCustomerStats() async {
    try {
      final response = await http.get(Uri.parse('$url/order/select_all'));
      
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

  Future<List<Customer>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$url/order/select_all'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Customer.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching customer list: $e');
      return [];
    }
  }
}
