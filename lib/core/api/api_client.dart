import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_AuthInterceptor());

    // Auto retry on network failures
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
        retryEvaluator: (error, attempt) {
          // Retry on connection errors and timeouts, not on 4xx/5xx
          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    // Only add logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Multipart request for file uploads
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    return _dio.post(
      path,
      data: formData,
      options: options,
      onSendProgress: onSendProgress,
    );
  }
}

// Auth Interceptor to add JWT token to requests
class _AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<String?> _readAccessToken() async {
    if (kDebugMode) {
      print('[TOKEN_READ] Reading token from secure storage...');
    }

    final token = await _storage.read(key: _tokenKey);
    if (kDebugMode) {
      print(
          '[TOKEN_READ] Token read from auth_token: ${token != null ? 'YES (${token.substring(0, 20)}...)' : 'NO'}');
    }

    if (token != null && token.isNotEmpty) {
      return token;
    }

    final fallbackToken = await _storage.read(key: 'access_token');
    if (kDebugMode) {
      print(
          '[TOKEN_READ] Token read from access_token: ${fallbackToken != null ? 'YES' : 'NO'}');
    }

    if (fallbackToken != null && fallbackToken.isNotEmpty) {
      return fallbackToken;
    }

    if (kDebugMode) {
      print('[TOKEN_READ] NO TOKEN FOUND in secure storage!');
    }
    return null;
  }

  Future<String?> _readRefreshToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      return refreshToken;
    }

    final fallbackRefresh = await _storage.read(key: 'refreshToken');
    if (fallbackRefresh != null && fallbackRefresh.isNotEmpty) {
      return fallbackRefresh;
    }

    return null;
  }

  String? _extractAccessToken(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return null;
    }
    return data['token'] as String? ??
        data['accessToken'] as String? ??
        data['access_token'] as String?;
  }

  String? _extractRefreshToken(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return null;
    }
    return data['refreshToken'] as String? ?? data['refresh_token'] as String?;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    final publicEndpoints = [
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.forgotPassword,
      ApiEndpoints.resetPassword,
      ApiEndpoints.verifyEmail,
      ApiEndpoints.googleAuth,
      ApiEndpoints.appleAuth,
    ];

    final isPublicGet = options.method == 'GET' &&
        publicEndpoints.any((endpoint) => options.path.contains(endpoint));

    final isAuthEndpoint = publicEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    if (!isPublicGet && !isAuthEndpoint) {
      final token = await _readAccessToken();
      if (kDebugMode) {
        print(
            '[AUTH_INTERCEPTOR] Token read: ${token != null ? 'YES (${token.substring(0, 20)}...)' : 'NO'} for ${options.path}');
        print('[AUTH_INTERCEPTOR] Headers before: ${options.headers}');
      }
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        if (kDebugMode) {
          print(
              '[AUTH_INTERCEPTOR] Authorization header added for ${options.path}');
          print('[AUTH_INTERCEPTOR] Headers after: ${options.headers}');
        }
      } else {
        if (kDebugMode) {
          print(
              '[AUTH_INTERCEPTOR] WARNING: No token available for protected endpoint: ${options.path}');
        }
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshToken = await _readRefreshToken();

      if (refreshToken != null) {
        try {
          // Attempt token refresh
          final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
          final response = await dio.post(
            ApiEndpoints.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          if (response.data['success'] == true) {
            final data = response.data['data'];
            final newToken = _extractAccessToken(data);
            final newRefreshToken = _extractRefreshToken(data);
            if (newToken == null || newToken.isEmpty) {
              throw Exception('Token refresh failed');
            }

            // Cache and save new tokens
            await _storage.write(key: _tokenKey, value: newToken);
            if (newRefreshToken != null) {
              await _storage.write(
                  key: _refreshTokenKey, value: newRefreshToken);
            }

            // Retry the original request with new token
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final opts = Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            );

            final cloneDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
            final retryResponse = await cloneDio.request(
              err.requestOptions.path,
              options: opts,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
            );

            return handler.resolve(retryResponse);
          }
        } catch (e) {
          if (kDebugMode) {
            print('[AUTH_INTERCEPTOR] Token refresh failed: $e');
          }
          // Token refresh failed, clear tokens
          await _storage.delete(key: _tokenKey);
          await _storage.delete(key: _refreshTokenKey);
        }
      } else {
        // No refresh token, clear auth token
        await _storage.delete(key: _tokenKey);
      }
    }

    return handler.next(err);
  }
}
