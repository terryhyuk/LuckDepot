class Hub {
      final int id;
      final String name;
      final String manager;
      final String phone;
      final double lat;
      final double lng;
      final String mail;
      final String start_time;
      final String end_time;


      Hub ({
        required this.id,
        required this.name,
        required this.manager,
        required this.phone,
        required this.lat,
        required this.lng,
        required this.mail,
        required this.start_time,
        required this.end_time,
      });

    Hub.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        manager = res['manager'],
        phone = res['phone'],
        lat = res['lat'],
        lng = res['lng'],
        mail = res['mail'],
        start_time = res['start_time'],
        end_time = res['end_time'];


}