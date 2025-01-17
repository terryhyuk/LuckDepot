
import 'package:hive_ce/hive.dart';

part 'truck.g.dart';

@HiveType(typeId:1)
class Truck {
  @HiveField(0)
  String carNumber; // 차량번호

  @HiveField(1)
  bool isCompanyOwned;  // 회사 소유의 차량 여부

  Truck({
    required this.carNumber,
    required this.isCompanyOwned
  }
  );
}