import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';

class ApiInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  ApiInterceptor({required this.sharedPreferences});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = sharedPreferences.getString(ApiConstants.tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      sharedPreferences.remove(ApiConstants.tokenKey);
      sharedPreferences.remove(ApiConstants.usernameKey);
      sharedPreferences.remove(ApiConstants.tokenExpiryKey);
    }
    handler.next(err);
  }
}
