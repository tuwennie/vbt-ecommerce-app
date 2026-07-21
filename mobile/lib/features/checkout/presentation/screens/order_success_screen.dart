import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderNo;
  final String deliveryAddress;

  const OrderSuccessScreen({
    super.key,
    this.orderNo = '#SW-9284710',
    this.deliveryAddress = 'Levent Mahallesi, Meltem Sokak No:12 Beşiktaş, İstanbul, 34330',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSwift', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Yeşil Onay İkonu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, size: 64, color: Colors.green),
            ),
            const SizedBox(height: 16),
            const Text(
              'Siparişiniz Alındı!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Harika seçim! Siparişiniz onaylandı ve ekibimiz hazırlıklara başladı. Tüm güncellemeleri e-posta adresinize göndereceğiz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // 1. Sipariş Bilgileri Kartı
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SİPARİŞ BİLGİLERİ', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sipariş No:', style: TextStyle(color: Colors.grey)),
                        Text(orderNo, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tahmini Teslimat:', style: TextStyle(color: Colors.grey)),
                        Text('24 Ekim Perşembe', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 2. Teslimat Adresi Kartı
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TESLİMAT ADRESİ', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(deliveryAddress, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Butonlar
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                onPressed: () {
                  // Sipariş detay / takip ekranına yönlendirme
                },
                icon: const Icon(Icons.local_shipping_outlined, color: Colors.white),
                label: const Text('Sipariş Takibi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                label: const Text('Alışverişe Devam Et', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}