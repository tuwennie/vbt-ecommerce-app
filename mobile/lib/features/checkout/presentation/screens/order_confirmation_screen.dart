import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../providers/checkout_provider.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  String _formatTurkishDate(DateTime date) {
    final deliveryDate = date.add(const Duration(days: 5));
    const months = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    const days = [
      '', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
    ];
    final dayStr = deliveryDate.day;
    final monthStr = months[deliveryDate.month];
    final weekdayStr = days[deliveryDate.weekday];
    return '$dayStr $monthStr $weekdayStr';
  }

  String _formatPrice(double val) {
    final int wholePart = val.toInt();
    final int decimalPart = ((val - wholePart) * 100).round();
    final String formattedWhole = wholePart.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    final String formattedDecimal = decimalPart.toString().padLeft(2, '0');
    return '$formattedWhole,$formattedDecimal';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(checkoutProvider).completedOrder;

    final orderNo = (order?.orderNo != null && order!.orderNo.isNotEmpty)
        ? order.orderNo
        : '#SW-9284710';

    final deliveryAddress = (order?.deliveryAddress != null && order!.deliveryAddress.isNotEmpty)
        ? order.deliveryAddress
        : 'Teslimat Adresi';

    final createdAt = order?.createdAt ?? DateTime.now();
    final deliveryDateStr = _formatTurkishDate(createdAt);
    final totalAmount = order?.totalAmount ?? 0.0;
    final itemsList = order?.items ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'ShopSwift',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Yeşil Onay İkonu
            const CircleAvatar(
              radius: 32,
              backgroundColor: Color(0xFFDCFCE7),
              child: Icon(Icons.check, color: Color(0xFF16A34A), size: 36),
            ),
            const SizedBox(height: 16),

            // Başlık ve Açıklama Metni
            const Text(
              'Siparişiniz Alındı!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Harika seçim! Siparişiniz onaylandı ve ekibimiz hazırlıklara başladı. Tüm güncellemeleri e-posta adresinize göndereceğiz.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
              ),
            ),
            const SizedBox(height: 24),

            // 1. SİPARİŞ BİLGİLERİ Kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SİPARİŞ BİLGİLERİ',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Sipariş No:', orderNo),
                  const SizedBox(height: 8),
                  _buildInfoRow('Tahmini Teslimat:', deliveryDateStr),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. TESLİMAT ADRESİ Kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TESLİMAT ADRESİ',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deliveryAddress,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF374151), height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. SİPARİŞ ÖZETİ Kartı (Gerçek Veri)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kart Başlık Alanı
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Sipariş Özeti',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),

                  // Ürün Listesi
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if (itemsList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Sipariş ürün detayları başarıyla kaydedildi.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemsList.length,
                            separatorBuilder: (_, __) => const Divider(height: 20),
                            itemBuilder: (context, index) {
                              final item = itemsList[index];
                              final String title = item is Map ? (item['productName'] ?? 'Ürün') : 'Ürün';
                              final int qty = item is Map ? (item['quantity'] ?? 1) : 1;
                              final double price = item is Map
                                  ? (double.tryParse(item['subtotal']?.toString() ?? item['unitPrice']?.toString() ?? '0') ?? 0.0)
                                  : 0.0;
                              final String? imgUrl = item is Map ? item['imageUrl']?.toString() : null;

                              return Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[100],
                                      child: imgUrl != null && imgUrl.isNotEmpty
                                          ? Image.network(imgUrl, fit: BoxFit.cover)
                                          : const Icon(Icons.image, size: 30, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Adet: $qty',
                                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₺${_formatPrice(price > 0 ? price : totalAmount)}',
                                          style: const TextStyle(
                                            color: Color(0xFF1D61E7),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                        const Divider(height: 24),

                        // Ara Toplam
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Ara Toplam', style: TextStyle(color: Colors.black54, fontSize: 14)),
                            Text('₺${_formatPrice(totalAmount)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Kargo
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Kargo', style: TextStyle(color: Colors.black54, fontSize: 14)),
                            Text('Ücretsiz', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const Divider(height: 24),

                        // Genel Toplam
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Toplam', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              '₺${_formatPrice(totalAmount)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Sipariş Takibi Butonu (Yeşil)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go(AppRouter.orderHistory),
                icon: const Icon(Icons.local_shipping_outlined, color: Colors.white, size: 20),
                label: const Text(
                  'Sipariş Takibi',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 5. Alışverişe Devam Et Butonu (Beyaz)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go(AppRouter.productList),
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 20),
                label: const Text(
                  'Alışverişe Devam Et',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}