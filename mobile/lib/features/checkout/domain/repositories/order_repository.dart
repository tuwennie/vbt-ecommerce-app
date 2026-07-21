import '../../data/models/address_model.dart';
import '../../data/models/create_order_dto.dart';

abstract class OrderRepository {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<OrderResponseModel?> createOrder(CreateOrderDto dto);
}