import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../core/navigation/app_router.dart';
import '../providers/auth_provider.dart';

/// Dinamik Oturum Kontrolü Yapan ve Şık Açılış Ekranı (Splash Screen)
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // 1. Veritabanından ve Cihaz Hafızasından Dinamik Oturum Kontrolü
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.checkAuthStatus();

    if (!mounted) return;

    final authState = ref.read(authProvider);

    // 2. Dinamik Yönlendirme (Kullanıcı Oturumu Açık İse Ana Sayfa, Yoksa Login)
    if (authState.isAuthenticated) {
      ref.read(profileProvider.notifier).fetchProfile();
      ref.read(cartProvider.notifier).fetchCart();
      context.go(AppRouter.productList);
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1D61E7),
              Color(0xFF1142A5),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo İkonu
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Uygulama Başlığı
            Text(
              'ShopSwift',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Geleceğin Alışveriş Deneyimi',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 48),

            // Yükleniyor İndikatörü
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
