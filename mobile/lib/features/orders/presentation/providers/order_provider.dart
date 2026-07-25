import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/order_model.dart';

class OrderState {
  final bool isLoading;
  final List<OrderModel> orders;
  final String? errorMessage;

  OrderState({this.isLoading = false, this.orders = const [], this.errorMessage});

  OrderState copyWith({
    bool? isLoading,
    List<OrderModel>? orders,
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
      final List rawData = response.data['orders'] ?? response.data ?? [];
      final ordersList = rawData.map((e) => OrderModel.fromJson(e)).toList();

      state = state.copyWith(isLoading: false, orders: ordersList);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Geçmiş siparişler yüklenemedi.',
      );
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(DioClient());
});