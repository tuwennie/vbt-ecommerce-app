import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/order_model.dart'; // OrderResponseModel'in bulunduğu dosya

class OrderState {
  final bool isLoading;
  final List<OrderResponseModel> orders; // 👈 OrderModel yerine OrderResponseModel kullanıldı
  final String? errorMessage;

  OrderState({
    this.isLoading = false,
    this.orders = const [],
    this.errorMessage,
  });

  OrderState copyWith({
    bool? isLoading,
    List<OrderResponseModel>? orders, // 👈 OrderResponseModel
    String? errorMessage,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final DioClient _dioClient;

  OrderNotifier(this._dioClient) : super(OrderState()) {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _dioClient.get(ApiEndpoints.orders);

      final rawData = response.data is Map<String, dynamic>
          ? (response.data['orders'] ?? response.data['data'] ?? [])
          : (response.data as List? ?? []);

      final ordersList = (rawData as List)
          .map((e) => OrderResponseModel.fromJson(e as Map<String, dynamic>)) // 👈 OrderResponseModel.fromJson
          .toList();

      state = state.copyWith(isLoading: false, orders: ordersList);
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map<String, dynamic>
          ? e.response?.data['message']
          : null;

      final message = serverMessage is List
          ? serverMessage.join(', ')
          : serverMessage?.toString() ?? 'Geçmiş siparişler yüklenemedi.';

      state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Beklenmeyen bir hata oluştu.',
      );
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(DioClient());
});