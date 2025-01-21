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
                selected: drawerController.isCurrentRoute('/'),
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.space_dashboard),
                title: const Text('Dashboard'),
                onTap: () => drawerController.navigateToPage(0),
              )),
          Obx(() => ListTile(
                selected: drawerController.isCurrentRoute('/sales'),
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.trending_up),
                title: const Text('Sales Analytics'),
                onTap: () => drawerController.navigateToPage(1),
              )),
          Obx(() => ListTile(
                selected: drawerController.isCurrentRoute('/inventory'),
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.inventory_2),
                title: const Text('Inventory Management'),
                onTap: () => drawerController.navigateToPage(2),
              )),
          Obx(() => ListTile(
                selected: drawerController.isCurrentRoute('/customer'),
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.people),
                title: const Text('Customer Management'),
                onTap: () => drawerController.navigateToPage(3),
              )),
          Obx(() => ListTile(
                selected: drawerController.isCurrentRoute('/logistics'),
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.local_shipping),
                title: const Text('Logistics Hub'),
                onTap: () => drawerController.navigateToPage(4),
              )),
          Obx(() => ListTile(
                selected: drawerController.isCurrentRoute('/delivery_driver'),
                selectedTileColor: Colors.white,
                leading: const Icon(Icons.drive_eta_rounded),
                title: const Text('Delivery Driver'),
                onTap: () => drawerController.navigateToPage(5),
              )),
        ],
      ),
    );
  }
}
