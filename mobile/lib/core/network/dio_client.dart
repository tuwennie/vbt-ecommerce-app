import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';

/// Tüm mobil isteklerinin geçtiği tekil Dio istemcisi ve merkezi hata yönetim katmanı.
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
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final statusCode = error.response?.statusCode;
          String errorMessage = "Beklenmedik bir ağ hatası oluştu.";

          if (statusCode == 401) {
            errorMessage = "Oturum süreniz doldu, lütfen tekrar giriş yapın (401).";
            // 401 hatası alındığında güvenli hafızadaki token'ları otomatik temizle
            await clearTokens();
          } else if (statusCode == 404) {
            errorMessage = "Aradığınız kaynak sunucuda bulunamadı (404).";
          } else if (statusCode != null && statusCode >= 500) {
            errorMessage = "Sunucu şu anda yanıt vermiyor. Lütfen daha sonra tekrar deneyin (500).";
          } else if (error.type == DioExceptionType.connectionTimeout || 
                     error.type == DioExceptionType.receiveTimeout) {
            errorMessage = "Sunucu bağlantı zaman aşımına uğradı, lütfen internetinizi kontrol edin.";
          } else if (error.message != null && error.message!.contains('SocketException')) {
            errorMessage = "İnternet bağlantısı bulunamadı.";
          }

          final customError = DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: errorMessage,
          );

          return handler.next(customError);
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

  // Token İşlemleri
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // Repository Katmanı İçin Yardımcı HTTP Metotları
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
  }
}