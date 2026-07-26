import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../providers/checkout_provider.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // completedOrder değişkeni doğrudan OrderResponseModel? tipindedir
    final order = ref.watch(checkoutProvider).completedOrder;

    // Nesne özelliklerine güvenli erişim
    final orderNo = order?.orderNo.isNotEmpty == true 
        ? order!.orderNo 
        : '#SW-9284710';

    final deliveryAddress = (order?.deliveryAddress.isNotEmpty == true)
        ? order!.deliveryAddress
        : 'Levent Mahallesi, Meltem Sokak No:12\nBeşiktaş, İstanbul, 34330';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFFDCFCE7),
                child: Icon(Icons.check, color: Color(0xFF16A34A), size: 40),
              ),
              const SizedBox(height: 16),
              const Text('Siparişiniz Alındı!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Harika seçim! Siparişiniz onaylandı ve ekibimiz hazırlıklara başladı. Tüm güncellemeleri e-posta adresinize göndereceğiz.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 24),

              // Sipariş Bilgileri Kartı
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16), 
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Sipariş No:', orderNo),
                    const SizedBox(height: 8),
                    _buildInfoRow('Tahmini Teslimat:', '3 İş Günü İçinde'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Teslimat Adresi Kartı (Dinamik Veri)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16), 
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TESLİMAT ADRESİ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(deliveryAddress, style: const TextStyle(height: 1.3)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Sipariş Durumu Kartı
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16), 
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sipariş Özeti', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Siparişiniz başarıyla oluşturuldu ve ödemeniz onaylandı.',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Aksiyon Butonları
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => context.go(AppRouter.profile),
                  icon: const Icon(Icons.local_shipping_outlined, color: Colors.white),
                  label: const Text('Sipariş Takibi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => context.go(AppRouter.productList),
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                  label: const Text('Alışverişe Devam Et', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}