import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';

class SavedCardsScreen extends ConsumerWidget {
  const SavedCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.profile);
            }
          },
        ),
        title: const Text(
          'Kayıtlı Kartlarım',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // 1. Basit Kart İllüstrasyon Kutusu (Görsel Birebir)
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      // Kredi Kartı İllüstrasyon Çizimi
                      Container(
                        width: 100,
                        height: 64,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12,
                              color: Colors.grey.shade300,
                            ),
                            const Spacer(),
                            Container(
                              width: 32,
                              height: 6,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),

                      // Üzeri Çizgili İkon Etkisi
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 110,
                            height: 2,
                            color: Colors.grey.shade400,
                            transform: Matrix4.rotationZ(-0.4),
                          ),
                        ),
                      ),

                      // Kırmızı ! Uyarı Rozeti
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDC2626), // Kırmızı
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // 2. Ana Başlık (Kaydolmuş Kart Bulunmamaktadır)
              const Text(
                'Kayıtlı kart\nbulunmamaktadır',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 14),

              // 3. Açıklama Metni
              Text(
                'Ödeme işlemlerinizi hızlandırmak için bir kart ekleyebilirsiniz. Verileriniz yüksek güvenlik standartları ile korunur.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 32),

              // 4. Aksiyon Butonu (+ Yeni Kart Ekle - Pasif)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kart ekleme özelliği yakında aktif olacaktır.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text(
                  'Yeni Kart Ekle',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
