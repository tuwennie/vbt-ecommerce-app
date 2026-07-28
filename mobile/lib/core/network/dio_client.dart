import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          final token = await getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final statusCode = error.response?.statusCode;

          // 1. 401 Unauthorized durumunda sessizce Refresh Token kullanarak yeni Access Token almayı deniyoruz
          if (statusCode == 401 && !error.requestOptions.path.contains('/auth/')) {
            final refreshToken = await getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshResponse = await _dio.post(
                  ApiEndpoints.refresh,
                  data: {'refreshToken': refreshToken},
                  options: Options(headers: {'X-Client-Type': 'MOBILE'}),
                );

                final responseData = refreshResponse.data;
                final newAccessToken = (responseData['accessToken'] ?? responseData['access_token'])?.toString();
                final newRefreshToken = (responseData['refreshToken'] ?? responseData['refresh_token'])?.toString();

                if (newAccessToken != null && newAccessToken.isNotEmpty) {
                  await saveTokens(
                    accessToken: newAccessToken,
                    refreshToken: newRefreshToken,
                  );

                  final opts = error.requestOptions;
                  opts.headers['Authorization'] = 'Bearer $newAccessToken';
                  final clonedResponse = await _dio.fetch(opts);
                  return handler.resolve(clonedResponse);
                }
              } catch (_) {
                await clearTokens();
              }
            } else {
              await clearTokens();
            }
          }

          String errorMessage = "Beklenmedik bir ağ hatası oluştu.";

          // 2. Backend'den gelen özel hata mesajını ayıklama
          final responseData = error.response?.data;
          if (responseData is Map<String, dynamic>) {
            if (responseData['message'] != null) {
              if (responseData['message'] is List) {
                errorMessage = (responseData['message'] as List).first.toString();
              } else {
                errorMessage = responseData['message'].toString();
              }
            } else if (responseData['error'] != null && responseData['error'] is String) {
              errorMessage = responseData['error'];
            }
          }

          // 3. HTTP Durum Kodlarına Göre Varsayılan Mesajları Tamamlama
          if (responseData == null || errorMessage == "Beklenmedik bir ağ hatası oluştu.") {
            if (statusCode == 401) {
              errorMessage = "Oturum süreniz doldu, lütfen tekrar giriş yapın.";
            } else if (statusCode == 403) {
              errorMessage = "Bu işlemi gerçekleştirmek için yetkiniz bulunmamaktadır.";
            } else if (statusCode == 404) {
              errorMessage = "Aradığınız kaynak sunucuda bulunamadı (404).";
            } else if (statusCode == 409) {
              errorMessage = "Bu kayıt zaten mevcut.";
            } else if (statusCode != null && statusCode >= 500) {
              errorMessage = "Sunucu şu anda yanıt vermiyor. Lütfen daha sonra tekrar deneyin.";
            } else if (error.type == DioExceptionType.connectionTimeout || 
                     error.type == DioExceptionType.receiveTimeout ||
                     error.type == DioExceptionType.sendTimeout) {
              errorMessage = "Sunucu bağlantı zaman aşımına uğradı, lütfen internetinizi ve sunucuyu kontrol edin.";
            } else if (error.type == DioExceptionType.connectionError) {
              errorMessage = "Sunucuya bağlanılamadı. İnternet bağlantınızı veya sunucu durumunu kontrol edin.";
            } else if (error.message != null && error.message!.contains('SocketException')) {
              errorMessage = "İnternet bağlantısı bulunamadı.";
            }
          }

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
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await prefs.setString(_refreshTokenKey, refreshToken);
      }
    } catch (_) {}

    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _storage.write(key: _refreshTokenKey, value: refreshToken);
      }
    } catch (_) {}
  }

  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_accessTokenKey);
      if (token != null && token.isNotEmpty) return token;
    } catch (_) {}

    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_refreshTokenKey);
      if (token != null && token.isNotEmpty) return token;
    } catch (_) {}

    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
    } catch (_) {}

    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
    } catch (_) {}
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