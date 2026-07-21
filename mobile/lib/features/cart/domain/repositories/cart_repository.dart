import '../../data/models/cart_model.dart';

abstract class CartRepository {
  Future<CartModel> getCart();
  Future<CartModel> addToCart({required String productId, int quantity = 1});
  Future<CartModel> removeFromCart({required String productId});
  Future<CartModel> updateQuantity({required String productId, required int quantity});
}