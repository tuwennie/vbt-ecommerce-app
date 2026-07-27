import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/favorites_provider.dart';
import '../../../orders/presentation/providers/order_provider.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _showSettingsCard = false;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final orderState = ref.watch(orderProvider);
    final favorites = ref.watch(favoritesProvider);

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
    final favoriteCount = favorites.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'ShopSwift',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileProvider.notifier).fetchProfile();
          await ref.read(orderProvider.notifier).fetchOrders();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFF1D61E7),
                        child: Text(
                          user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'A',
                          style: const TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: InkWell(
                          onTap: () => _showEditNameDialog(context, ref, currentName: user?.name ?? ''),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1D61E7),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user?.name ?? 'Ahmet Yılmaz',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _showEditNameDialog(context, ref, currentName: user?.name ?? ''),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Color(0xFF1D61E7),
                        ),
                      ),
                    ],
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

            // 2. Ana Kart VEYA Ayarlar Kartı
            if (!_showSettingsCard)
              _buildMainCard(context, ref, orderCount: orderCount, favoriteCount: favoriteCount)
            else
              _buildSettingsCard(context, ref),

            const SizedBox(height: 24),

            // 3. Versiyon Bilgisi
            Text(
              'ShopSwift v2.4.0',
              style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    );
  }

  // ======================================================
  // ANA MENÜ KARTI (Sipariş Geçmişim, Favoriler, Bildirimler, Ayarlar, Çıkış Yap)
  // ======================================================
  Widget _buildMainCard(
    BuildContext context,
    WidgetRef ref, {
    required int orderCount,
    required int favoriteCount,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // 1. Sipariş Geçmişim (Fonksiyonel)
          _buildMenuItem(
            icon: Icons.history,
            title: 'Sipariş Geçmişim',
            badgeText: orderCount > 0 ? '$orderCount' : null,
            onTap: () => context.go(AppRouter.orderHistory),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 2. Favoriler (Fonksiyonel Tam Ekran)
          _buildMenuItem(
            icon: Icons.favorite_border,
            title: 'Favorilerim',
            badgeText: favoriteCount > 0 ? '$favoriteCount' : null,
            onTap: () => context.push(AppRouter.favorites),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 3. Bildirimler (Pasif)
          _buildMenuItem(
            icon: Icons.notifications_none,
            title: 'Bildirimler',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bildirimler özelliği yakında aktif olacaktır.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 4. Ayarlar (Fonksiyonel -> Ayarlar kartını açar)
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Ayarlar',
            onTap: () => setState(() => _showSettingsCard = true),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 5. Çıkış Yap (Kart içinde, Fonksiyonel)
          ListTile(
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout, color: Color(0xFFDC2626), size: 20),
            ),
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold, fontSize: 15),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFFDC2626)),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // AYARLAR ALT KARTI
  // ======================================================
  Widget _buildSettingsCard(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ayarlar Başlığı & Geri Butonu
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => setState(() => _showSettingsCard = false),
                ),
                const Text(
                  'Ayarlar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 1. Adreslerim (Görsele Sadık Tam Ekran)
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Adreslerim',
            onTap: () => context.push(AppRouter.addresses),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 2. Kayıtlı Kartlarım (Görsele Sadık Tam Ekran)
          _buildMenuItem(
            icon: Icons.credit_card_outlined,
            title: 'Kayıtlı Kartlarım',
            onTap: () => context.push(AppRouter.savedCards),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 3. E-posta Değiştir (Görsele Sadık Tam Ekran)
          _buildMenuItem(
            icon: Icons.email_outlined,
            title: 'E-posta Değiştir',
            onTap: () => context.push(AppRouter.changeEmail),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 4. Şifre Değiştir (Görsele Sadık Tam Ekran)
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Şifre Değiştir',
            onTap: () => context.push(AppRouter.changePassword),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 5. Hesap Gizliliği
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Hesap Gizliliği',
            onTap: () => _showInfoDialog(
              context,
              title: 'Hesap Gizliliği',
              content: 'Hesap ve verilerinizin güvenliği 256-bit SSL şifreleme standartları ile korunmaktadır.',
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 6. Yardım Merkezi
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Yardım Merkezi',
            onTap: () => _showInfoDialog(
              context,
              title: 'Yardım Merkezi',
              content: 'Sorularınız ve destek için destek@shopswift.com adresine e-posta gönderebilirsiniz.',
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // MODAL / DIALOG YARDIMCI METOTLARI
  // ======================================================









  // Genel Bilgilendirme Dialog
  void _showInfoDialog(BuildContext context, {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tamam')),
        ],
      ),
    );
  }

  // Menü Öğesi Oluşturucu
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1D61E7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref, {required String currentName}) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Adınızı Düzenleyin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profilinizde görüntülenecek yeni adınızı giriniz:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Ad Soyad',
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D61E7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                await ref.read(profileProvider.notifier).updateName(newName);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil adınız başarıyla güncellendi.'),
                      backgroundColor: Color(0xFF16A34A),
                    ),
                  );
                }
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}