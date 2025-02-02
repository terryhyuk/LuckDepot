import 'package:hive_ce/hive.dart';

part 'driver.g.dart';

@HiveType(typeId: 0)
class Driver{
  @HiveField(0)
  int driverNum;  // 기사번호
  
  @HiveField(1)
  String name;    // 기사이름

  @HiveField(2)   // 기사 연락처
  int phone;

  @HiveField(3)   // 기사 이메일
  String email;

  @HiveField(4)
  bool isRegular; // 정규직여부

  @HiveField(5)
  String id;      // 기사로그인ID

  @HiveField(6)
  String password;  // 비밀번호

  @HiveField(7)
  String isworker = 'T';

  Driver({
    required this.driverNum,
    required this.name,
    required this.phone,
    required this.email,
    required this.isRegular,
    required this.id,
    required this.password,
    this.isworker = 'T',
  });
}
