import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../vm/custom_drawer_controller.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final drawerController = Get.put(CustomDrawerController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue.shade50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
              child: Center(
            child: Text(
              'Lucky Depot',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          )),
          Obx(() => ListTile(
                selected: drawerController.selectedIndex.value == 0,
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.space_dashboard),
                title: const Text('Dashboard'),
                onTap: () => drawerController.navigateToPage(0),
              )),
          Obx(() => ListTile(
                selected: drawerController.selectedIndex.value == 1,
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.trending_up),
                title: const Text('Sales Analytics'),
                onTap: () => drawerController.navigateToPage(1),
              )),
          Obx(() => ListTile(
                selected: drawerController.selectedIndex.value == 2,
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.inventory_2),
                title: const Text('Inventory Management'),
                onTap: () => drawerController.navigateToPage(2),
              )),
          Obx(() => ListTile(
                selected: drawerController.selectedIndex.value == 3,
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.people),
                title: const Text('Customer Management'),
                onTap: () => drawerController.navigateToPage(3),
              )),
          Obx(() => ListTile(
                selected: drawerController.selectedIndex.value == 4,
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.local_shipping),
                title: const Text('Logistics Hub'),
                onTap: () => drawerController.navigateToPage(4),
              ),
            ),
        ],
      ),
    );
  }
}
