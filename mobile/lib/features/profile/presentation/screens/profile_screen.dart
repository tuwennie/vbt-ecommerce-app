import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'ShopSwift',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // 1. KULLANICI BİLGİLERİ KARTI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  // Profil Resmi + Kalem İkonu
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB0B0B0),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D6EFD),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Ad Soyad
                  Text(
                    user?.fullName ?? 'Ahmet Yılmaz',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // E-posta
                  Text(
                    user?.email ?? 'ahmet.yilmaz@mail.com',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. MENÜ SEÇENEKLERİ KARTI
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.history,
                    title: 'Sipariş Geçmişim',
                    badgeText: '12',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 64, endIndent: 16, color: Color(0xFFF0F0F0)),
                  _ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Adreslerim',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 64, endIndent: 16, color: Color(0xFFF0F0F0)),
                  _ProfileMenuItem(
                    icon: Icons.payment,
                    title: 'Ödeme Yöntemlerim',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 64, endIndent: 16, color: Color(0xFFF0F0F0)),
                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Ayarlar',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. ÇIKIŞ YAP KARTI
            InkWell(
              onTap: () {
                ref.read(authProvider.notifier).logout();
              },
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Color(0xFFDC3545),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Çıkış Yap',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC3545),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFFDC3545),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 4. VERSİYON YAZISI
            const Text(
              'ShopSwift v2.4.0',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black38,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Menü Elemanı Özel Widget'ı
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badgeText;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.black87,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeText != null) ...[
            Text(
              badgeText!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
          ],
          const Icon(
            Icons.chevron_right,
            color: Colors.black45,
            size: 22,
          ),
        ],
      ),
    );
  }
}