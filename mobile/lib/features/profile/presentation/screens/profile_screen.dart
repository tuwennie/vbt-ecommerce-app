import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../../../orders/presentation/providers/order_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final orderState = ref.watch(orderProvider);

    if (profileState.isLoading && profileState.user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profileState.errorMessage != null && profileState.user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: ErrorStateWidget(
          message: profileState.errorMessage!,
          errorCode: 'ERR_PROFILE_FETCH',
          onRetry: () => ref.read(profileProvider.notifier).fetchProfile(),
        ),
      );
    }

    final user = profileState.user;
    final orderCount = orderState.orders.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'ShopSwift',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // 1. Profil Bilgileri Kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.grey[400],
                        child: Text(
                          user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'A',
                          style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D61E7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Ahmet Yılmaz',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'ahmet.yilmaz@mail.com',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Menü Seçenekleri Kartı
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Sipariş Geçmişim',
                    badgeText: orderCount > 0 ? '$orderCount' : '12',
                    onTap: () => context.go(AppRouter.orderHistory),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Adreslerim',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildMenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Ödeme Yöntemlerim',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Ayarlar',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Çıkış Yap Kartı
            InkWell(
              onTap: () async {
                try {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(AppRouter.login);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Çıkış yapılırken bir hata oluştu: $e')),
                    );
                  }
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE2E2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.logout, color: Color(0xFFDC2626), size: 20),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Çıkış Yap',
                      style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Color(0xFFDC2626)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Versiyon Bilgisi
            Text(
              'ShopSwift v2.4.0',
              style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeText != null) ...[
            Text(
              badgeText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
            const SizedBox(width: 12),
          ],
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}