import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../widgets/add_address_dialog.dart';
import '../screens/order_success_screen.dart';

class CheckoutSummaryScreen extends ConsumerWidget {
  const CheckoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sipariş Özeti')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📍 1. Teslimat Adresi Seçim Alanı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Teslimat Adresi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const AddAddressDialog(),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Adres'),
                ),
              ],
            ),
            if (checkoutState.addresses.isEmpty)
              const Text('Kayıtlı adres bulunamadı. Lütfen yeni bir adres ekleyin.', style: TextStyle(color: Colors.red))
            else
              ...checkoutState.addresses.map((address) {
                return RadioListTile<String>(
                  title: Text(address.title),
                  subtitle: Text('${address.fullAddress} - ${address.district}/${address.city}'),
                  value: address.id,
                  groupValue: checkoutState.selectedAddress?.id,
                  onChanged: (value) {
                    final selected = checkoutState.addresses.firstWhere((e) => e.id == value);
                    ref.read(checkoutProvider.notifier).selectAddress(selected);
                  },
                );
              }),
            const Divider(height: 32),

            // 🛒 2. Sepet Ürün Özeti
            const Text('Siparişteki Ürünler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...?cartState.cart?.items.map((item) => ListTile(
                  dense: true,
                  title: Text(item.productName),
                  subtitle: Text('${item.quantity} adet x ₺${item.price.toStringAsFixed(2)}'),
                  trailing: Text('₺${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                )),
            const Divider(height: 32),

            // 💳 3. Toplam Fiyat Özeti
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam Tutar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '₺${cartState.cart?.totalPrice.toStringAsFixed(2) ?? "0.00"}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🚀 4. Siparişi Onayla Butonu (Form Validation Aktif)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // DoD: Adres seçilmediyse buton pasif kalır
                onPressed: checkoutState.isFormValid && !checkoutState.isLoading
                    ? () async {
                        final success = await ref.read(checkoutProvider.notifier).submitOrder();
                        if (success && context.mounted) {
                          // Başarılı sipariş sonrası Success Ekranına Yönlendirme
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
                            (route) => route.isFirst,
                          );
                        }
                      }
                    : null,
                child: checkoutState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Siparişi Onayla ve Bitir', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}