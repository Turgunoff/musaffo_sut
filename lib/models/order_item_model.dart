// lib/models/order_item_model.dart

import 'product_model.dart';

class OrderItemWithProduct {
  final int quantity;
  final double price;
  final Product product;

  OrderItemWithProduct({
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItemWithProduct.fromJson(Map<String, dynamic> json) {
    // Supabase'dan kelgan ma'lumotni tekshiramiz
    if (json['products'] == null) {
      throw Exception('Product data is missing in the order item response');
    }

    return OrderItemWithProduct(
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      // 'products' bu - Supabase'dagi jadval nomi
      product: Product.fromJson(json['products'] as Map<String, dynamic>),
    );
  }
}
