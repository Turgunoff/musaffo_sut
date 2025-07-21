import 'package:flutter/material.dart';
import 'package:musaffo_sut/models/category_model.dart';
import 'package:musaffo_sut/models/product_model.dart';
import 'package:musaffo_sut/services/supabase_service.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Yangi holat o'zgaruvchilari
  bool _isLoading = true; // Yuklanish holatini kuzatish uchun
  List<Category> _categories = []; // Supabase'dan keladigan kategoriyalar uchun
  List<Product> _products = []; // Supabase'dan keladigan mahsulotlar uchun
  String? _selectedCategoryId; // Tanlangan kategoriya ID'sini saqlash uchun

  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _fetchData(); // Ekran ochilganda ma'lumotlarni yuklash
  }

  // Ma'lumotlarni Supabase'dan olib keluvchi funksiya
  Future<void> _fetchData() async {
    // Kategoriyalarni va mahsulotlarni bir vaqtda olib kelamiz
    final results = await Future.wait([
      _supabaseService.getCategories(),
      _supabaseService.getProducts(),
    ]);

    // Boshlanishiga "Barchasi" kategoriyasini qo'lda qo'shib qo'yamiz
    final categories = results[0] as List<Category>;
    categories.insert(0, Category(id: 'all', name: 'Barchasi'));

    setState(() {
      _categories = categories;
      _products = results[1] as List<Product>;
      _selectedCategoryId =
          _categories.first.id; // Boshlanishiga "Barchasi" tanlangan bo'ladi
      _isLoading = false; // Yuklanish tugadi
    });
  }

  // Mahsulotlarni tanlangan kategoriyaga qarab filtrlash
  List<Product> get _filteredProducts {
    if (_selectedCategoryId == 'all' || _selectedCategoryId == null) {
      return _products;
    }
    return _products
        .where((product) => product.categoryId == _selectedCategoryId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData,
              edgeOffset: 80,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // AppBar
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    titleSpacing: 0,
                    title: const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Musaffo Sut',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    pinned: true, // AppBar fixed holda qoladi
                  ),

                  // Banner
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.network(
                              'https://images.pexels.com/photos/416656/pexels-photo-416656.jpeg?auto=compress&w=600&q=80',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              color: Colors.black.withOpacity(0.5),
                              colorBlendMode: BlendMode.colorBurn,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 120,
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              left: 16,
                              top: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Eng Toza Mahsulotlar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "To'g'ridan-to'g'ri fermadan!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Kategoriyalar (Fixed)
                  SliverPersistentHeader(
                    pinned: true, // Kategoriyalar fixed holda qoladi
                    delegate: _CategoryHeaderDelegate(
                      child: _buildCategorySection(),
                    ),
                  ),

                  // Mahsulotlar
                  SliverToBoxAdapter(child: _buildProductSection()),
                ],
              ),
            ),
    );
  }

  // Kategoriyalarni chizuvchi yangi widget
  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = category.id == _selectedCategoryId;
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == _categories.length - 1 ? 16 : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedCategoryId = category.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2563FF)
                        : const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Mahsulotlarni chizuvchi yangi widget
  Widget _buildProductSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mahsulotlar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9, // Kartochka bo'yi va eni nisbati
              crossAxisSpacing: 0,
              mainAxisSpacing: 8,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ProductCard(
                product: product,
              ); // ProductCard'ga mahsulotni uzatamiz
            },
          ),
        ],
      ),
    );
  }
}

// Kategoriyalar uchun SliverPersistentHeaderDelegate
class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CategoryHeaderDelegate({required this.child});

  @override
  double get minExtent => 56.0; // Minimal balandlik

  @override
  double get maxExtent => 56.0; // Maksimal balandlik

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
