import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/components/custom_button.dart';
import 'core/components/custom_text_field.dart';
import 'features/products/presentation/widgets/product_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopSwift UI Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: 'sans-serif', // Cihazın varsayılan temiz yazı tipini kullanır
      ),
      home: const UICatalogScreen(),
    );
  }
}

class UICatalogScreen extends StatefulWidget {
  const UICatalogScreen({super.key});

  @override
  State<UICatalogScreen> createState() => _UICatalogScreenState();
}

class _UICatalogScreenState extends State<UICatalogScreen> {
  bool _isButtonLoading = false;
  bool _isFavoriteSample = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopSwift Bileşen Kataloğu',
          style: TextStyle(
            color: AppColors.textPrimary, 
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Bölüm: Tasarım Sistemi Renkleri
            _sectionHeader('1. GÜNCEL RENK PALETİ (Tuba\'nın Seçimi)'),
            const SizedBox(height: 12),
            Row(
              children: [
                _colorBox('Primary\n(Yeşil)', AppColors.primary, Colors.white),
                _colorBox('BrandBlue\n(Mavi)', AppColors.brandBlue, Colors.white),
                _colorBox('Background\n(Kırık Gri)', AppColors.background, AppColors.textPrimary),
                _colorBox('Surface\n(Beyaz)', AppColors.surface, AppColors.textPrimary),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Bölüm: Giriş Alanları
            _sectionHeader('2. GİRİŞ ALANLARI (CustomTextField)'),
            const SizedBox(height: 12),
            const CustomTextField(
              labelText: 'Ad Soyad',
              hintText: 'John Doe',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              labelText: 'E-posta Adresi',
              hintText: 'ornek@mail.com',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              labelText: 'Şifre',
              hintText: '••••••••',
              isPassword: true,
              prefixIcon: Icons.lock_outline,
            ),
            const SizedBox(height: 24),

            // 3. Bölüm: Butonlar
            _sectionHeader('3. GÜNCEL BUTONLAR (CustomButton)'),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Kayıt Ol',
              showArrow: true,
              onPressed: () {
                _showSnackBar('Kayıt Ol butonuna tıklandı!');
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Yüklenme Testi',
              isLoading: _isButtonLoading,
              showArrow: false,
              onPressed: () async {
                setState(() => _isButtonLoading = true);
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) {
                  setState(() => _isButtonLoading = false);
                  _showSnackBar('İşlem başarıyla tamamlandı!');
                }
              },
            ),
            const SizedBox(height: 24),

            // 4. Bölüm: Ürün Kartı
            _sectionHeader('4. ÜRÜN KARTI (ProductCard)'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ProductCard(
                    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', // Kulaklık görseli
                    category: 'Giyilebilir Teknoloji',
                    title: 'SwiftSonic Pro X1',
                    price: 12499.00, // Tasarımdaki gerçek fiyat
                    isFavorite: _isFavoriteSample,
                    onFavoriteTap: () {
                      setState(() => _isFavoriteSample = !_isFavoriteSample);
                      _showSnackBar(_isFavoriteSample ? 'Favorilere eklendi!' : 'Favorilerden çıkarıldı!');
                    },
                    onAddToCartTap: () {
                      _showSnackBar('Sepete eklendi!');
                    },
                    onTap: () {
                      _showSnackBar('Ürün detayına gidiliyor...');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Grid yapısının simülasyonu için boş bir alan bırakıyoruz
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13, 
        fontWeight: FontWeight.w800, 
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _colorBox(String label, Color color, Color textColor) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label, 
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}