import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../providers/order_provider.dart';
import '../../data/models/order_model.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    if (orderState.isLoading && orderState.orders.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRouter.profile);
              }
            },
          ),
          title: const Text(
            'Siparişlerim',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (orderState.errorMessage != null && orderState.orders.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRouter.profile);
              }
            },
          ),
          title: const Text(
            'Siparişlerim',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: ErrorStateWidget(
          message: orderState.errorMessage!,
          errorCode: 'ERR_ORDER_FETCH',
          onRetry: () => ref.read(orderProvider.notifier).fetchOrders(),
        ),
      );
    }

    if (orderState.orders.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRouter.profile);
              }
            },
          ),
          title: const Text(
            'Siparişlerim',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async => ref.read(orderProvider.notifier).fetchOrders(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 56,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Henüz Siparişiniz Bulunmamaktadır',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Verdiğiniz tüm siparişlerin kargo ve teslimat durumlarını bu ekrandan takip edebilirsiniz.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => context.go(AppRouter.productList),
                          icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                          label: const Text(
                            'Alışverişe Başla',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final List<OrderUiModel> ordersToDisplay =
        orderState.orders.map((o) => _mapResponseToUi(o)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.profile);
            }
          },
        ),
        title: const Text(
          'Siparişlerim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.read(orderProvider.notifier).fetchOrders(),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          itemCount: ordersToDisplay.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final order = ordersToDisplay[index];
            return _buildOrderCard(context, order);
          },
        ),
      ),
    );
  }

  // ======================================================
  // SİPARİŞ KARTI BİLEŞENİ (Görsele Sadık)
  // ======================================================
  Widget _buildOrderCard(BuildContext context, OrderUiModel order) {
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
          // 1. Üst Kısım: Sipariş No, Tarih ve Durum Rozeti
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.dateStr,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Orta Kısım: Ürün Görselleri, İsimler ve Fiyat
          Row(
            children: [
              // Sol: Görseller ve +N Kutusu
              _buildImageThumbnails(order.imageUrls, order.totalItemCount),
              const SizedBox(width: 14),

              // Sağ: Ürün Başlığı ve Fiyat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productsSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${order.formattedPrice} TL',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Alt Kısım: Sipariş Detayı Butonu (Pasif)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sipariş detay özelliği yakında aktif olacaktır.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sipariş Detayı',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: Color(0xFF374151), size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Durum Rozeti (Pill Badge)
  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData iconData;

    final lower = status.toLowerCase();
    if (lower.contains('kargo') || lower.contains('shipped')) {
      bgColor = const Color(0xFF2563EB); // Canlı Mavi
      textColor = Colors.white;
      iconData = Icons.local_shipping_outlined;
    } else if (lower.contains('hazırlan') || lower.contains('processing')) {
      bgColor = const Color(0xFF86EFAC); // Canlı Yeşil (Görseldeki yeşil)
      textColor = const Color(0xFF14532D);
      iconData = Icons.inventory_2_outlined;
    } else {
      // Teslim Edildi / Tamamlandı
      bgColor = const Color(0xFFE5E7EB); // Açık Gri
      textColor = const Color(0xFF374151);
      iconData = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Ürün Görseli / Küçük Resim Listesi (+N dahil)
  Widget _buildImageThumbnails(List<String> imageUrls, int totalItemCount) {
    final displayImages = imageUrls.take(2).toList();
    final remainingCount = totalItemCount > 2 ? totalItemCount - 2 : 0;

    return Row(
      children: [
        for (int i = 0; i < displayImages.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 52,
                height: 52,
                color: Colors.grey[100],
                child: displayImages[i].isNotEmpty
                    ? Image.network(
                        displayImages[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.watch, color: Colors.grey),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
        if (remainingCount > 0)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Model Eşleme
  OrderUiModel _mapResponseToUi(OrderResponseModel o) {
    final monthNames = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];

    final dateStr = '${o.createdAt.day} ${monthNames[o.createdAt.month]} ${o.createdAt.year}';
    final images = <String>[];
    final names = <String>[];

    for (var item in o.items) {
      if (item is Map<String, dynamic>) {
        if (item['imageUrl'] != null) images.add(item['imageUrl'].toString());
        if (item['productName'] != null) names.add(item['productName'].toString());
      }
    }

    return OrderUiModel(
      orderNo: o.orderNo.isNotEmpty ? o.orderNo : '#ORD-${o.id}',
      dateStr: dateStr,
      status: o.status,
      imageUrls: images,
      productsSummary: names.isNotEmpty ? names.join(', ') : 'Sipariş İletildi',
      formattedPrice: o.totalAmount.toStringAsFixed(2).replaceAll('.', ','),
      totalItemCount: o.items.isNotEmpty ? o.items.length : 1,
    );
  }
}

class OrderUiModel {
  final String orderNo;
  final String dateStr;
  final String status;
  final List<String> imageUrls;
  final String productsSummary;
  final String formattedPrice;
  final int totalItemCount;

  OrderUiModel({
    required this.orderNo,
    required this.dateStr,
    required this.status,
    required this.imageUrls,
    required this.productsSummary,
    required this.formattedPrice,
    required this.totalItemCount,
  });
}
