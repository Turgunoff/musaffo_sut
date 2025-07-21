import 'package:musaffo_sut/models/cart_item_model.dart';
import 'package:musaffo_sut/models/order_item_model.dart';
import 'package:musaffo_sut/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Barcha kategoriyalarni olib keladigan funksiya
  Future<List<Category>> getCategories() async {
    final response = await _client.from('categories').select();

    final List<Category> categories = [];
    for (var item in response) {
      categories.add(Category.fromJson(item));
    }
    return categories;
  }

  // Barcha mahsulotlarni olib keladigan funksiya
  Future<List<Product>> getProducts() async {
    final response = await _client.from('products').select();

    final List<Product> products = [];
    for (var item in response) {
      products.add(Product.fromJson(item));
    }
    return products;
  }

  // YANGI FUNKSIYA: Buyurtmani bazaga yozish
  Future<String?> createOrder({
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required double totalPrice,
    required List<CartItem> items,
  }) async {
    try {
      // 1. "orders" jadvaliga yangi buyurtma qo'shish
      final orderResponse = await _client.from('orders').insert({
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_address': customerAddress,
        'total_price': totalPrice,
        'status': 'Yangi',
      }).select(); // .select() orqali yangi yaratilgan qatorni qaytarib olamiz

      // Yangi buyurtmaning noyob ID'sini olish
      final newOrderId = orderResponse.first['id'];

      // 2. Har bir mahsulotni "order_items" jadvaliga qo'shish
      final List<Map<String, dynamic>> orderItems = items
          .map(
            (item) => {
              'order_id': newOrderId,
              'product_id': item.product.id,
              'quantity': item.quantity,
              'price': item.product.price, // Aynan sotib olingan paytdagi narxi
            },
          )
          .toList();

      await _client.from('order_items').insert(orderItems);

      // Muvaffaqiyatli bo'lsa, buyurtma ID'sini qaytaramiz
      return newOrderId;
    } catch (e) {
      // Xatolik bo'lsa, konsolga chiqarish va null qaytarish
      print('Buyurtma yaratishda xatolik: $e');
      return null;
    }
  }

  // YANGI FUNKSIYA: ID'lar ro'yxati bo'yicha buyurtmalarni olib kelish
  Future<List<Order>> getOrdersByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return []; // Agar ID'lar ro'yxati bo'sh bo'lsa, so'rov yubormaslik
    }

    final response = await _client
        .from('orders')
        .select()
        .inFilter(
          'id',
          ids,
        ) // "id" ustuni shu ro'yxatdagilardan biri bo'lgan qatorlarni tanlash
        .order(
          'created_at',
          ascending: false,
        ); // Yangi buyurtmalarni tepada ko'rsatish

    final List<Order> orders = [];
    for (var item in response) {
      orders.add(Order.fromJson(item));
    }
    return orders;
  }

  Future<List<OrderItemWithProduct>> getOrderDetails(String orderId) async {
    final response = await _client
        .from('order_items')
        .select('*, products(*)') // Jadvallarni bog'lash (JOIN)
        .eq('order_id', orderId);

    final List<OrderItemWithProduct> items = [];
    for (var item in response) {
      items.add(OrderItemWithProduct.fromJson(item));
    }
    return items;
  }
}
