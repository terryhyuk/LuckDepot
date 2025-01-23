class Customer {
  final String name;
  final String email;
  final double totalPayment;
  final int orderCount;
  final String lastOrderDate;

  Customer({
    required this.name,
    required this.email,
    required this.totalPayment,
    required this.orderCount,
    required this.lastOrderDate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      totalPayment: (json['total_payment'] ?? 0).toDouble(),
      orderCount: json['order_count'] ?? 0,
      lastOrderDate: json['last_order_date'] ?? '',
    );
  }
}

/// API 응답 전체 구조를 담는 클래스
class CustomerResponse {
  final List<Customer> customers;
  final double sum; // 총 결제금액
  final double avg; // 평균

  CustomerResponse({
    required this.customers,
    required this.sum,
    required this.avg,
  });

factory CustomerResponse.fromJson(Map<String, dynamic> json) {
  try {
    final resultList = json['result'] as List<dynamic>;
    return CustomerResponse(
      customers: resultList
          .map((item) => Customer.fromJson(item as Map<String, dynamic>))
          .toList(),
      sum: (json['sum'] as num?)?.toDouble() ?? 0.0,
      avg: (json['avg'] as num?)?.toDouble() ?? 0.0,
    );
  } catch (e) {
    print('Error parsing JSON: $e');
    return CustomerResponse(
      customers: [],
      sum: 0.0,
      avg: 0.0,
    );
  }
}

}
