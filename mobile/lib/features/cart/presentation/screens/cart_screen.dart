import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sepetim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: _buildBody(context, ref, cartState, cartNotifier),
    );
  }

  Widget _buildBody(
    BuildContext context, 
    WidgetRef ref, 
    CartState state, 
    CartNotifier notifier
  ) {
    // 1. Yüklenme Durumu
    if (state.isLoading && state.cart == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Hata Durumu
    if (state.errorMessage != null && state.cart == null) {
      return ErrorStateWidget(
        message: state.errorMessage!,
        errorCode: 'ERR_CART_FETCH',
        onRetry: () => notifier.fetchCart(),
        onGoHome: () => context.go(AppRouter.productList),
      );
    }

    final items = state.cart?.items ?? [];

    // 3. Boş Sepet Durumu
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_cart_outlined, size: 72, color: AppColors.brandBlue),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sepetinizde ürün bulunmamaktadır',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Harika ürünleri keşfetmek ve fırsatları kaçırmamak için hemen alışverişe başlayın.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRouter.productList),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Alışverişe Başla', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = state.cart?.totalPrice ?? 0.0;
    const kargo = 29.99;
    final grandTotal = subtotal + kargo;

    return Column(
      children: [
        // Sepet Ürün Listesi
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Görsel
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                            ? Image.network(
                                item.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                              )
                            : const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Ürün Bilgileri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${item.price.toStringAsFixed(2)} TRY',
                            style: const TextStyle(
                              color: AppColors.brandBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Adet Kontrol Butonları (+ / - / Sil)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            iconSize: 18,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                              color: item.quantity == 1 ? Colors.redAccent : Colors.black87,
                            ),
                            onPressed: () {
                              if (item.quantity == 1) {
                                notifier.removeFromCart(item.productId);
                              } else {
                                notifier.updateQuantity(item.productId, item.quantity - 1);
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          IconButton(
                            iconSize: 18,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.add, color: Colors.black87),
                            onPressed: () {
                              notifier.updateQuantity(item.productId, item.quantity + 1);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Sipariş Özeti ve Ödemeye Geç Alt Kartı
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ara Toplam', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text('${subtotal.toStringAsFixed(2)} TRY', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kargo Ücreti', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text('${kargo.toStringAsFixed(2)} TRY', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Genel Toplam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      '${grandTotal.toStringAsFixed(2)} TRY',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.brandBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Adres/Ödeme adımına geçiş
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981), // Tasarımdaki Canlı Yeşil
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Siparişi Onayla',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}