import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/order_repository.dart';
import '../../data/models/address_model.dart';
import '../../data/models/create_order_dto.dart';

class OrderRepositoryImpl implements OrderRepository {
  final DioClient _dioClient;

  OrderRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _dioClient.get('/addresses');
    final List data = response.data.containsKey('data') ? response.data['data'] : response.data;
    return data.map((e) => AddressModel.fromJson(e)).toList();
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await _dioClient.post('/addresses', data: address.toJson());
    final data = response.data.containsKey('data') ? response.data['data'] : response.data;
    return AddressModel.fromJson(data);
  }

  @override
  Future<bool> createOrder(CreateOrderDto dto) async {
    final response = await _dioClient.post('/orders', data: dto.toJson());
    return response.statusCode == 200 || response.statusCode == 201;
  }
}