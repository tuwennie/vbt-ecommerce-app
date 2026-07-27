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

      dynamic rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        if (rawData.containsKey('data')) {
          final dataField = rawData['data'];
          if (dataField is List) {
            rawData = dataField;
          } else if (dataField is Map<String, dynamic>) {
            rawData = dataField['orders'] ?? dataField['items'] ?? dataField['data'] ?? [];
          } else {
            rawData = [];
          }
        } else if (rawData.containsKey('orders')) {
          rawData = rawData['orders'];
        } else if (rawData.containsKey('items')) {
          rawData = rawData['items'];
        }
      }

      final List listData = rawData is List ? rawData : [];

      final ordersList = listData
          .whereType<Map<String, dynamic>>()
          .map((e) => OrderResponseModel.fromJson(e))
          .toList();

      state = state.copyWith(isLoading: false, orders: ordersList, errorMessage: null);
    } on CustomApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
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
        errorMessage: 'Beklenmeyen bir hata oluştu: $e',
      );
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(DioClient());
});