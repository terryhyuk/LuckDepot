import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/vm/custom_drawer_controller.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  @override
  void initState() {
    super.initState();
    // 컨트롤러 초기화
    Get.put(CustomDrawerController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomDrawer(),
          // 메인 컨텐츠 영역
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  // 여기에 대시보드 컨텐츠 추가
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
