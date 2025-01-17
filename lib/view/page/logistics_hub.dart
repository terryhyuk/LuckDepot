import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lucky_depot/constants/hub_location.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/vm/custom_drawer_controller.dart';

class LogisticsHub extends StatefulWidget {
  const LogisticsHub({super.key});

  @override
  State<LogisticsHub> createState() => _LogisticsHubState();
}

class _LogisticsHubState extends State<LogisticsHub> {
  @override
  void initState() {
    super.initState();
    Get.put(CustomDrawerController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 왼쪽 드로워
          CustomDrawer(),
          
          // 메인 컨텐츠
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Logistics Hub',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 지도와 허브 정보를 포함하는 상단 영역
                  Expanded(
                    flex: 2, // 상단 영역이 전체의 2/3 차지
                    child: Row(
                      children: [
                        // 왼쪽 지도
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(20),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: HubLocations.getInitialLocation(),
                                  initialZoom: 7,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  MarkerLayer(
                                    markers: HubLocations.hubs.map((hub) => 
                                      Marker(
                                        point: hub['location'],
                                        width: 80,
                                        height: 80,
                                        child: Column(
                                          children: [
                                            Icon(Icons.location_on, color: Colors.red),
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              color: Colors.white,
                                              child: Text(
                                                hub['name'],
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 24),
                        
                        // 오른쪽 허브 정보
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(20),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              itemCount: HubLocations.hubs.length,
                              itemBuilder: (context, index) {
                                final hub = HubLocations.hubs[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(hub['name']),
                                    subtitle: Text(hub['address']),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 하단 빈 영역
                  Expanded(
                    flex: 1, // 하단 영역이 전체의 1/3 차지
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
