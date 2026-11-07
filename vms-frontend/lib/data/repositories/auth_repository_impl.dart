import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final SharedPreferences _preferences;

  AuthRepositoryImpl({
    required this._dataSource,
    required this._preferences,
  });

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await _dataSource.login(
        LoginRequestModel(username: username.trim(), password: password),
      );
      await _preferences.setString(ApiConstants.tokenKey, response.token);
      await _preferences.setString(ApiConstants.usernameKey, response.username);
      if (response.expiresIn != null) {
        await _preferences.setInt(
          ApiConstants.tokenExpiryKey,
          DateTime.now()
              .add(Duration(milliseconds: response.expiresIn!))
              .millisecondsSinceEpoch,
        );
      }
      return response.username;
    } catch (error) {
      throw AuthFailure(_messageFor(error));
    }
  }

  String _messageFor(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['message'] is String) {
        return data['message'] as String;
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Unable to connect to the server. Please try again.';
      }
      return 'Authentication failed. Please check your credentials.';
    }
    return 'Authentication failed. Please try again.';
  }

  @override
  Future<void> logout() async {
    await _preferences.remove(ApiConstants.tokenKey);
    await _preferences.remove(ApiConstants.usernameKey);
    await _preferences.remove(ApiConstants.tokenExpiryKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = _preferences.getString(ApiConstants.tokenKey);
    final expiry = _preferences.getInt(ApiConstants.tokenExpiryKey);
    return token != null &&
        token.isNotEmpty &&
        (expiry == null || expiry > DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<String?> getCurrentUser() async =>
      _preferences.getString(ApiConstants.usernameKey);

  @override
  Future<String?> getToken() async =>
      _preferences.getString(ApiConstants.tokenKey);
}
