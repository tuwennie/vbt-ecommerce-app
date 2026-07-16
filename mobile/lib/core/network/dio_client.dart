import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';

/// Tüm mobil isteklerinin geçtiği tekil Dio istemcisi.
///
/// Sözleşme kuralları (backend/docs/openapi.yaml):
/// - Her istekte `X-Client-Type: MOBILE` header'ı ZORUNLU (auth uçları için).
///   Bu sayede refreshToken cookie yerine JSON gövdede döner.
/// - Başarılı yanıtlar `{ success: true, data: ... }` zarfıyla döner.
/// - Hata yanıtları `{ success: false, message, statusCode, status }` şemasında.
class DioClient {
  DioClient._internal(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.defaultBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {
          'Content-Type': 'application/json',
          'X-Client-Type': 'MOBILE',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: _accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // TODO(Zeliha): 401 alındığında refresh token akışıyla otomatik
          // yenileme + orijinal isteği tekrar deneme (retry) burada eklenecek.
          handler.next(error);
        },
      ),
    );
  }

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static DioClient? _instance;
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  factory DioClient({FlutterSecureStorage? storage}) {
    _instance ??= DioClient._internal(storage ?? const FlutterSecureStorage());
    return _instance!;
  }

  Dio get dio => _dio;

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
