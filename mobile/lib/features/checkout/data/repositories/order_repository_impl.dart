import 'dart:math';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/order_repository.dart';
import '../../data/models/address_model.dart';
import '../../data/models/create_order_dto.dart';

class OrderRepositoryImpl implements OrderRepository {
  final DioClient _dioClient;

  OrderRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  String _generateUuidV4() {
    final Random random = Random.secure();
    final values = List<int>.generate(16, (_) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // Version 4
    values[8] = (values[8] & 0x3f) | 0x80; // Variant 1
    final String hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _dioClient.get('/addresses');
      dynamic rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        rawData = rawData['data'] ?? rawData['addresses'] ?? rawData['items'] ?? rawData;
      }
      if (rawData is List) {
        return rawData
            .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      final response = await _dioClient.post('/addresses', data: address.toJson());
      final rawData = response.data is Map<String, dynamic>
          ? (response.data.containsKey('data') ? response.data['data'] : response.data)
          : response.data;
      if (rawData is Map<String, dynamic>) {
        return AddressModel.fromJson(rawData);
      }
      return address;
    } catch (e) {
      return address;
    }
  }

  @override
  Future<OrderResponseModel?> createOrder(CreateOrderDto dto) async {
    final idempotencyKey = _generateUuidV4();
    final response = await _dioClient.post(
      '/orders',
      data: dto.toJson(),
      options: Options(
        headers: {
          'Idempotency-Key': idempotencyKey,
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final rawData = response.data is Map<String, dynamic>
          ? (response.data.containsKey('data') ? response.data['data'] : response.data)
          : response.data;
      if (rawData is Map<String, dynamic>) {
        return OrderResponseModel.fromJson(rawData);
      }
    }
    return null;
  }
}