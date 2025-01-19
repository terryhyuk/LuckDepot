// 2024.01.18
// driver 등록 및 삭제

import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lucky_depot/model/driver.dart';

class DriverRepository {
  static const String _boxName = 'drivers';

  // Create
  addDriver(Driver driver) async {
  final box = await Hive.openBox<Driver>(_boxName);
  await box.add(driver);
}
    
    // Read
  Future<List<Driver>> allDrivers()async{
    final box = await Hive.openBox<Driver>(_boxName);
    return box.values.toList();
  }

    Future<Driver?> getDriver(int index) async {
    final box = await Hive.openBox<Driver>(_boxName);
    return box.getAt(index);
  }

  // Update
  updateDriver(int index, Driver driver)async{
    final box = await Hive.openBox<Driver>(_boxName);
    await box.putAt(index, driver);
  }

  // Delete
    deleteDriver(int index) async{
    final box = await Hive.openBox<Driver>(_boxName);
    await box.deleteAt(index);
  }
    // Box의 데ㅣ터가 변경될 떄마다 UI를 자동으로 업데이트함
  ValueListenable<Box<Driver>> getDriverListenable() {
    return Hive.box<Driver>(_boxName).listenable();
  }
}