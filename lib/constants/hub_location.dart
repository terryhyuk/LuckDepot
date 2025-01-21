import 'package:latlong2/latlong.dart';

class HubLocations {
  static final List<Map<String, dynamic>> hubs = [
    {
      'name': '서울 허브',
      'location': const LatLng(37.5665, 126.9780),
      'address': '서울특별시 중구 세종대로 110',
    },
    // 필요한 만큼 허브 추가
  ];

  // 초기 중심 위치를 가져오는 메서드
  static LatLng getInitialLocation() {
    return hubs.first['location'];
  }

  // 모든 허브 위치를 가져오는 메서드
  static List<LatLng> getAllLocations() {
    return hubs.map((hub) => hub['location'] as LatLng).toList();
  }
}
