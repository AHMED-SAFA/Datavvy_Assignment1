import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import 'api_interceptor.dart';

class DioClient {
  static late final DioClient instance;

  final SharedPreferences sharedPreferences;
  late final Dio dio;

  DioClient({required this.sharedPreferences}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(ApiInterceptor(sharedPreferences: sharedPreferences));
    instance = this;
  }
}
