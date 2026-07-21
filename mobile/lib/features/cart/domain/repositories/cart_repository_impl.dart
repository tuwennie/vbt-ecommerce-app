import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../data/models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final DioClient _dioClient;

  CartRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<CartModel> getCart() async {
    final response = await _dioClient.get('/cart');
    final data = response.data.containsKey('data') ? response.data['data'] : response.data;
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> addToCart({required String productId, int quantity = 1}) async {
    final response = await _dioClient.post(
      '/cart/items',
      data: {'productId': productId, 'quantity': quantity},
    );
    final data = response.data.containsKey('data') ? response.data['data'] : response.data;
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> removeFromCart({required String productId}) async {
    final response = await _dioClient.delete('/cart/items/$productId');
    final data = response.data.containsKey('data') ? response.data['data'] : response.data;
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> updateQuantity({required String productId, required int quantity}) async {
    final response = await _dioClient.put(
      '/cart/items/$productId',
      data: {'quantity': quantity},
    );
    final data = response.data.containsKey('data') ? response.data['data'] : response.data;
    return CartModel.fromJson(data);
  }
}