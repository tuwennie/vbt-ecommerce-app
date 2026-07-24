import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../providers/category_provider.dart';

class CategoryListScreen extends ConsumerStatefulWidget {
  const CategoryListScreen({super.key});

  @override
  ConsumerState<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends ConsumerState<CategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Kategori ismine göre dinamik ikon seçimi
  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('elektronik')) return Icons.devices_rounded;
    if (name.contains('moda') || name.contains('giyim')) return Icons.checkroom_rounded;
    if (name.contains('ev') || name.contains('yaşam')) return Icons.home_rounded;
    if (name.contains('kozmetik') || name.contains('bakım')) return Icons.clean_hands_rounded;
    if (name.contains('spor')) return Icons.fitness_center_rounded;
    if (name.contains('kitap') || name.contains('hobi')) return Icons.menu_book_rounded;
    if (name.contains('oto')) return Icons.directions_car_rounded;
    if (name.contains('market') || name.contains('gıda')) return Icons.shopping_basket_rounded;
    return Icons.category_rounded;
  }

  // Varsayılan Unsplash görselleri (Eğer backend'den image_url gelmiyorsa)
  String _getCategoryBgImage(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('elektronik')) return 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600';
    if (name.contains('moda')) return 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?q=80&w=600';
    if (name.contains('ev')) return 'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=600';
    if (name.contains('kozmetik')) return 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600';
    return 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?q=80&w=600';
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text(
          'Kategoriler',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(categoryListProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // 1. Arama Çubuğu
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Kategori ara...',
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    prefixIcon: Icon(Icons.tune_rounded, color: Color(0xFF6B7280), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Canlı Grid Kategori Listesi
              categoriesAsync.when(
                data: (categories) {
                  final filteredCategories = categories.where((cat) {
                    return cat.name.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filteredCategories.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text('Kategori bulunamadı.', style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredCategories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return _buildCategoryCard(
                        name: category.name,
                        icon: _getCategoryIcon(category.name),
                        imageUrl: _getCategoryBgImage(category.name),
                        onTap: () {
                          // Seçilen kategori ID'si ile ürünler sayfasına geçiş
                          context.go(
                            AppRouter.productList,
                            extra: {'categoryId': category.id},
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 200,
                  child: Center(
                    child: Text('Kategoriler yüklenemedi: $err', textAlign: TextAlign.center),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Ücretsiz Kargo Banner Kartı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ücretsiz Kargo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tüm kategorilerde 250 TL ve üzeri alışverişlerde kargo bizden!',
                            style: TextStyle(
                              color: const Color(0xE6FFFFFF),
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String name,
    required IconData icon,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}