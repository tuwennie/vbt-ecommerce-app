import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';

/// UI ve Repository katmanına anlaşılır mesaj dönmek için özel Exception sınıfı
class CustomApiException implements Exception {
  final String message;
  final int? statusCode;

  CustomApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Tüm mobil isteklerinin geçtiği tekil Dio istemcisi ve merkezi hata yönetim katmanı.
class DioClient {
  
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  
  DioClient._internal(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.defaultBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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

          // 1. Backend'den gelen özel hata mesajını ayıklama (NestJS Validation/HttpException)
          final responseData = error.response?.data;
          if (responseData is Map<String, dynamic>) {
            if (responseData['message'] != null) {
              if (responseData['message'] is List) {
                // NestJS Class-Validator list dönerse ilk hatayı al
                errorMessage = (responseData['message'] as List).first.toString();
              } else {
                errorMessage = responseData['message'].toString();
              }
            } else if (responseData['error'] != null && responseData['error'] is String) {
              errorMessage = responseData['error'];
            }
          }

          // 2. HTTP Durum Kodlarına Göre Varsayılan Mesajları Tamamlama
          if (responseData == null || errorMessage == "Beklenmedik bir ağ hatası oluştu.") {
            if (statusCode == 401) {
              errorMessage = "Oturum süreniz doldu, lütfen tekrar giriş yapın.";
              await clearTokens(); // Güvenli hafızadaki token'ları temizle
            } else if (statusCode == 403) {
              errorMessage = "Bu işlemi gerçekleştirmek için yetkiniz bulunmamaktadır.";
            } else if (statusCode == 404) {
              errorMessage = "Aradığınız kaynak sunucuda bulunamadı (404).";
            } else if (statusCode == 409) {
              errorMessage = "Bu kayıt zaten mevcut.";
            } else if (statusCode != null && statusCode >= 500) {
              errorMessage = "Sunucu şu anda yanıt vermiyor. Lütfen daha sonra tekrar deneyin.";
            } 
            // 3. Dio Zaman Aşımı ve Bağlantı Hataları Kontrolü
            else if (error.type == DioExceptionType.connectionTimeout || 
                     error.type == DioExceptionType.receiveTimeout ||
                     error.type == DioExceptionType.sendTimeout) {
              errorMessage = "Sunucu bağlantı zaman aşımına uğradı, lütfen internetinizi ve sunucuyu kontrol edin.";
            } else if (error.type == DioExceptionType.connectionError) {
              errorMessage = "Sunucuya bağlanılamadı. İnternet bağlantınızı veya sunucu durumunu kontrol edin.";
            } else if (error.message != null && error.message!.contains('SocketException')) {
              errorMessage = "İnternet bağlantısı bulunamadı.";
            }
          }

          // 4. Hata Nesnesini Düzgün Bir Exception Olarak Paketleme
          final customException = CustomApiException(
            errorMessage,
            statusCode: statusCode,
          );

          final customError = DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: customException,
          );

          return handler.next(customError);
        },
      ),
    );
  }

  
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

  // Repository ve Service Katmanları İçin Güvenli Yardımcı HTTP Metotları
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _handleRequest(
      () => _dio.get(path, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _handleRequest(
      () => _dio.post(path, data: data, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _handleRequest(
      () => _dio.put(path, data: data, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _handleRequest(
      () => _dio.delete(path, data: data, queryParameters: queryParameters, options: options),
    );
  }

  /// İstekleri sarmalayan ve fırlatılan DioException içindeki CustomApiException'ı dışarı çıkaran yardımcı metot
  Future<Response> _handleRequest(Future<Response> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.error is CustomApiException) {
        throw e.error as CustomApiException;
      }
      throw CustomApiException(
        'Bir ağ hatası oluştu: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw CustomApiException('Beklenmeyen bir sistem hatası oluştu: $e');
    }
  }
}