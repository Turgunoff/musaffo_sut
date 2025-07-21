// lib/models/order_model.dart

class Order {
  final String id;
  final DateTime createdAt;
  final String status;
  final double totalPrice;
  // Kelajakda kerak bo'lishi mumkin:
  // final List<OrderItem> items;

  Order({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}
