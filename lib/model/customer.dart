class Customer {
  final int id;
  final String name;
  final String email;
  final double totalPayment;
  final int orderCount;
  final String lastOrderDate;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPayment,
    required this.orderCount,
    required this.lastOrderDate,
  });

  // JSON 데이터를 Customer 객체로 변환
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      totalPayment: json['total_payment'].toDouble(),
      orderCount: json['order_count'],
      lastOrderDate: json['last_order_date'],
    );
  }

  // Customer 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'total_payment': totalPayment,
      'order_count': orderCount,
      'last_order_date': lastOrderDate,
    };
  }
}
