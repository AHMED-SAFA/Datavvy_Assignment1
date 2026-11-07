import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

/// Remote data source for authentication API calls.
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// POST /api/auth/login
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );

    final apiResponse = response.data as Map<String, dynamic>;
    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      return LoginResponseModel.fromJson(
        apiResponse['data'] as Map<String, dynamic>,
      );
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse['message'] as String? ?? 'Login failed',
    );
  }
}
