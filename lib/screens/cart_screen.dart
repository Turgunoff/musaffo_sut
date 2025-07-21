import 'package:flutter/material.dart';
import 'package:musaffo_sut/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/cart_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // O'zbek so'mida formatlash funksiyasi
  String _formatUzbekCurrency(double amount) {
    final intValue = amount.toInt();
    final formatted = intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
    return '$formatted so\'m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mening Savatim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Savat bo\'sh',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final deliveryCost = 5000.0; // Yetkazib berish narxi
          final totalWithDelivery = cartProvider.totalAmount + deliveryCost;

          return Column(
            children: [
              // Cart Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.items.values.toList()[index];
                    return _buildCartItem(context, cartItem, cartProvider);
                  },
                ),
              ),

              // Summary Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // Summary Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jami mahsulotlar:',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          '${_formatUzbekCurrency(cartProvider.totalAmount)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Yetkazib berish:',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          _formatUzbekCurrency(deliveryCost),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Umumiy narx:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatUzbekCurrency(totalWithDelivery),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Checkout Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _showCheckoutFormDialog(context, cartProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Rasmiylashtirishga o\'tish',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    cartItem,
    CartProvider cartProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              cartItem.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatUzbekCurrency(cartItem.product.price),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decrease Button
              InkWell(
                onTap: () {
                  cartProvider.removeSingleItem(cartItem.product.id);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove, size: 18, color: Colors.grey),
                ),
              ),

              const SizedBox(width: 12),

              // Quantity
              Text(
                '${cartItem.quantity}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 12),

              // Increase Button
              InkWell(
                onTap: () {
                  cartProvider.addItem(cartItem.product);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Remove Button
          InkWell(
            onTap: () {
              cartProvider.removeItem(cartItem.product.id);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bu funksiya to'liq yangilanadi
  void _showCheckoutFormDialog(
    BuildContext context,
    CartProvider cartProvider,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final supabaseService = SupabaseService();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Dialog ichidagi state'ni boshqarish uchun
        return StatefulBuilder(
          builder: (context, setState) {
            bool isPlacingOrder = false;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Ma\'lumotlarni kiriting',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // --- ASOSIY O'ZGARISH SHU YERDA ---
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ism Familiya
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (FocusScope.of(context).hasFocus)
                              BoxShadow(
                                color: const Color(0x332563FF),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Ism Familiya',
                            prefixIcon: Icon(Icons.person_outline),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (value) => value!.isEmpty
                              ? 'Iltimos, ismingizni kiriting'
                              : null,
                        ),
                      ),
                      // Telefon raqam
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (FocusScope.of(context).hasFocus)
                              BoxShadow(
                                color: const Color(0x332563FF),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: TextFormField(
                          controller: phoneController,
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: '+998 (##) ###-##-##',
                              filter: {'#': RegExp(r'[0-9]')},
                            ),
                          ],
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefon Raqam',
                            prefixIcon: Icon(Icons.phone_outlined),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Iltimos, telefon raqam kiriting';
                            } else if (value.length < 19) {
                              return 'Raqamni to\'liq kiriting';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Manzil
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (FocusScope.of(context).hasFocus)
                              BoxShadow(
                                color: const Color(0x332563FF),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                        child: TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Yetkazib berish manzili',
                            prefixIcon: Icon(Icons.location_on_outlined),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                          maxLines: 2,
                          style: const TextStyle(fontSize: 16),
                          validator: (value) => value!.isEmpty
                              ? 'Iltimos, manzilingizni kiriting'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // --- O'ZGARISH TUGADI ---
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Bekor qilish'),
                ),
                ElevatedButton(
                  onPressed: isPlacingOrder
                      ? null // Agar buyurtma yuborilayotgan bo'lsa, tugmani o'chirish
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isPlacingOrder = true;
                            });

                            final newOrderId = await supabaseService
                                .createOrder(
                                  customerName: nameController.text,
                                  customerPhone: phoneController.text,
                                  customerAddress: addressController.text,
                                  totalPrice:
                                      cartProvider.totalAmount +
                                      5000.0, // Yetkazib berish bilan
                                  items: cartProvider.items.values.toList(),
                                );

                            if (newOrderId != null) {
                              // SharedPreferences'ga yangi ID'ni saqlash
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final List<String> orderIds =
                                  prefs.getStringList('order_history') ?? [];
                              orderIds.add(newOrderId);
                              await prefs.setStringList(
                                'order_history',
                                orderIds,
                              );

                              cartProvider.clearCart();
                              Navigator.of(context).pop();
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 32,
                                  ),
                                  titlePadding: const EdgeInsets.only(top: 24),
                                  title: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F5E9),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF43A047),
                                          size: 40,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Buyurtma qabul qilindi!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: const Text(
                                    "Operatorlarimiz tez orada siz bilan bog'lanishadi.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2563FF,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text(
                                          'Tushundim',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Xatolik yuz berdi
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Xatolik! Qaytadan urinib ko\'ring.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            setState(() {
                              isPlacingOrder = false;
                            });
                          }
                        },
                  child: isPlacingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Buyurtma berish'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
