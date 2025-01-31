import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductDetailRepository {
  final String url = 'http://192.168.50.38:8000';
  Future<Map<String, dynamic>> getDetailYear() async {
    try {
      final response = await http.get(Uri.parse('$url/detail/year'));

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return {
        'result': [],
      };
    } catch (e) {
      print('Error: $e');
      return {
        'result': [],
      };
    }
  }

  Future<Map<String, dynamic>> getDetailMonth() async {
    try{
      final response = await http.get(Uri.parse('$url/detail/month'));

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return {
        'result': [],
      };
    } catch (e) {
      print('Error: $e');
      return {
        'result': [],
      };
    }
}
Future<Map<String, dynamic>> getDetailWeek() async {
    try{
      final response = await http.get(Uri.parse('$url/detail/week')); 

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return {
        'result': [],
      };
    } catch (e) {
      print('Error: $e');
      return {
        'result': [],
      };
    }
}
}