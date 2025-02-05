import 'dart:convert';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucky_depot/model/hub.dart';
import 'package:http/http.dart' as http;

class HubController extends GetxController {
 
  final RxList<Hub> hubs = <Hub>[].obs;
  final String baseURL = 'https://port-0-luckydepot-m6q0n8sc55b3c20e.sel4.cloudtype.app/hub/';



  @override
  void onInit() {
    super.onInit();
    getHubs();
  }


  // 초기 중심 위치를 가져오는 메서드
  LatLng getInitialLocation() {
    return LatLng(hubs.first.lat, hubs.first.lng);
  }


  // 허브 데이터 가져오기
  getHubs() async {
    var url = Uri.parse(baseURL);
    var response = await http.get(url);
    
    if (response.statusCode == 200) {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      
      List<dynamic> results = dataConvertedJSON['result'];
      hubs.value = results.map((e) => Hub.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load hublist: ${response.statusCode}');
    }
}
}