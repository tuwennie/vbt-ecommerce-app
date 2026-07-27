import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../../data/models/address_model.dart';
import '../providers/checkout_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _selectedPaymentIndex = 0; // 0: Kredi Kartı, 1: Dijital Cüzdan

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(checkoutProvider.notifier).fetchAddresses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('ShopSwift', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Stepper İlerleme Çubuğu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStepItem(Icons.local_shipping_outlined, 'Sipariş', false),
                Expanded(child: Container(height: 1, color: Colors.grey[300])),
                _buildStepItem(Icons.payment_outlined, 'Ödeme', true),
                Expanded(child: Container(height: 1, color: Colors.grey[300])),
                _buildStepItem(Icons.check_circle_outline, 'Onay', false),
              ],
            ),
            const SizedBox(height: 20),

            // Teslimat Adresi Kartı
            _buildCardWrapper(
              title: 'Teslimat Adresi',
              actionWidget: TextButton(
                onPressed: () async {
                  await context.push(AppRouter.addresses);
                  if (mounted) {
                    ref.read(checkoutProvider.notifier).fetchAddresses();
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Ekle / Düzenle',
                  style: TextStyle(
                    color: Color(0xFFE06D14),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              child: checkoutState.userAddresses.isEmpty
                  ? InkWell(
                      onTap: () async {
                        await context.push(AppRouter.addresses);
                        if (mounted) {
                          ref.read(checkoutProvider.notifier).fetchAddresses();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Kayıtlı adres bulunamadı. Adres eklemek için tıklayın.',
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    )
                  : DropdownButtonFormField<AddressModel>(
                      dropdownColor: Colors.white,
                      initialValue: checkoutState.selectedAddress ??
                          (checkoutState.userAddresses.isNotEmpty ? checkoutState.userAddresses.first : null),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF16A34A)),
                        ),
                      ),
                      items: checkoutState.userAddresses.map((addr) {
                        final titleStr = (addr.title != null && addr.title!.isNotEmpty) ? addr.title! : 'Adres';
                        final detailStr = addr.fullAddress.isNotEmpty ? addr.fullAddress : '${addr.district}/${addr.city}';
                        return DropdownMenuItem<AddressModel>(
                          value: addr,
                          child: Text(
                            '$titleStr ($detailStr)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(checkoutProvider.notifier).setSelectedAddress(val);
                        }
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // Ödeme Yöntemleri Kartı (Göstermelik Seçim)
            _buildCardWrapper(
              title: 'Ödeme Yöntemleri',
              icon: Icons.credit_card_outlined,
              child: Column(
                children: [
                  _buildPaymentOption(
                    index: 0,
                    icon: Icons.credit_card,
                    title: 'Kredi veya Banka Kartı',
                    subtitle: 'Visa, Mastercard, Amex',
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentOption(
                    index: 1,
                    icon: Icons.contactless_outlined,
                    title: 'Dijital Cüzdan',
                    subtitle: 'Apple Pay, Google Pay',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sipariş Özeti Kartı (Sizin CartState Modelinizle Uyumlu)
            _buildCardWrapper(
              title: 'Sipariş Özeti',
              child: cartState.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : (cartState.cart == null || cartState.cart!.items.isEmpty)
                      ? const Text('Sepetinizde ürün bulunmamaktadır.', style: TextStyle(color: Colors.grey))
                      : Column(
                          children: [
                            // Sepetteki Ürün Listesi
                            ...cartState.cart!.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.imageUrl ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Adet: ${item.quantity}',
                                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '₺${item.totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),

                            // Ara Toplam
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Ara Toplam', style: TextStyle(color: Colors.grey)),
                                Text('₺${cartState.cart!.totalPrice.toStringAsFixed(2)}'),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Kargo
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Kargo', style: TextStyle(color: Colors.grey)),
                                Text('Ücretsiz', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(),

                            // Genel Toplam
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Genel Toplam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(
                                  '₺${cartState.cart!.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
            ),
            const SizedBox(height: 24),

            // Siparişi Tamamla Butonu
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: checkoutState.isLoading
                    ? null
                    : () async {
                        final selectedAddr = checkoutState.selectedAddress ??
                            (checkoutState.userAddresses.isNotEmpty ? checkoutState.userAddresses.first : null);

                        if (selectedAddr == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lütfen bir teslimat adresi seçin veya yeni adres ekleyin.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final messenger = ScaffoldMessenger.of(context);
                        final router = GoRouter.of(context);

                        final success = await ref.read(checkoutProvider.notifier).createOrder(
                          address: selectedAddr.fullAddress,
                          city: selectedAddr.city,
                          zipCode: selectedAddr.postalCode ?? '34000',
                        );
                        if (!mounted) return;

                        if (success) {
                          ref.read(orderProvider.notifier).fetchOrders();
                          ref.read(cartProvider.notifier).clearCart();
                          router.go(AppRouter.orderConfirmation);
                        } else {
                          final currentError = ref.read(checkoutProvider).errorMessage;
                          if (currentError != null) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(currentError),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                      },
                icon: checkoutState.isLoading
                    ? const SizedBox.shrink()
                    : const Icon(Icons.check_circle_outline, color: Colors.white),
                label: checkoutState.isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Siparişi Tamamla', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive ? const Color(0xFF2563EB) : Colors.grey[200],
          child: Icon(icon, size: 18, color: isActive ? Colors.white : Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? const Color(0xFF2563EB) : Colors.grey)),
      ],
    );
  }

  Widget _buildCardWrapper({required String title, IconData? icon, Widget? actionWidget, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              if (actionWidget != null) actionWidget,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }



  Widget _buildPaymentOption({required int index, required IconData icon, required String title, required String subtitle}) {
    final isSelected = _selectedPaymentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF2563EB) : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFF2563EB) : Colors.grey),
          ],
        ),
      ),
    );
  }
}