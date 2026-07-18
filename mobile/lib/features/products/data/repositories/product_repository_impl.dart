import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _dioClient;

  ProductRepositoryImpl(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int size = 20,
    String? search,
    String? categoryId,
    String? sort,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': size,
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null && categoryId.isNotEmpty)
          'categoryId': categoryId,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      };

      final response = await _dioClient.dio.get(
        ApiEndpoints.products,
        queryParameters: queryParameters,
      );

      final body = response.data as Map<String, dynamic>;
      if (body['success'] != true) {
        final message = body['message'] as String? ??
            'Ürünler yüklenirken bir hata oluştu.';
        throw Exception(message);
      }

      final data = body['data'] as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>?;
      if (items == null) {
        return [];
      }

      return items
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {

      if (e.error is String && (e.error as String).isNotEmpty) {
        throw Exception(e.error as String);
      }

      throw Exception(
        e.message ?? 'Ağ bağlantısı sırasında bir hata meydana geldi.',
      );
    } catch (e) {
      throw Exception('Veri işleme hatası: $e');
    }
  }
}