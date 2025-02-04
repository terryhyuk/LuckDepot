import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDetailRepository {
  final String baseUrl = 'http://192.168.50.38:8000';

  Future<Map<String, dynamic>> getDetailYear() async =>
      _fetchData('/detail/year');
  Future<Map<String, dynamic>> getDetailMonth() async =>
      _fetchData('/detail/month');
  Future<Map<String, dynamic>> getDetailWeek() async =>
      _fetchData('/detail/week');

  Future<Map<String, dynamic>> _fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        return _parseResponse(decodedData, endpoint);
      }
      return _defaultResponse();
    } catch (e) {
      return _defaultResponse();
    }
  }

Map<String, dynamic> _parseResponse(dynamic decodedData, String endpoint) {
  switch (endpoint) {
    case '/detail/year':
      final result = decodedData['result'] as Map<String, dynamic>;
      return {
        'products': result['products'] as List? ?? [],
        'year_sales': result['year_sales'] as List? ?? [],
      };
    case '/detail/week':
      return {
        'products': (decodedData['result']['products'] as List? ?? []),
        'weekday_sales': (decodedData['result']['weekday_sales'] as List? ?? []),
      };
case '/detail/month':
  final result = decodedData['result'] as Map<String, dynamic>;
  return {
    'products': result['products'] as List? ?? [],
    'month_sales': result['month_sales'] as List? ?? [],
  };
    default:
      return _defaultResponse();
  }
}

  Map<String, dynamic> _defaultResponse() {
    return {
      'products': [],
      'year_sales': [],
      'weekday_sales': [],
      'month_sales': [],
    };
  }
}
