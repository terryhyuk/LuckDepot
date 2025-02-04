import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerRepository {
  final String url = 'https://port-0-luckydepot-m6q0n8sc55b3c20e.sel4.cloudtype.app';

  Future<Map<String, dynamic>> getCustomerStats() async {
    try {
      final response = await http.get(Uri.parse('$url/order/select_all'));
      
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return {
        'result': [],
        'sum': 0,
        'avg': 0,
      };
    } catch (e) {
      return {
        'result': [],
        'sum': 0,
        'avg': 0,
      };
    }
  }
  
  Future<Map<String, dynamic>> resentOrder()async{
    try {
    final response = await http.get(Uri.parse('$url/detail/home'));
    if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    return{
      'result':[],
      'total_price':0,
      'total_order':0,
    };
    }catch (e){
      return{
      'result':[],
      'total_price':0,
      'total_order':0,
      };
    }
  }

}
