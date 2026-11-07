import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/vehicle_model.dart';

/// Remote data source for vehicle API calls.
class VehicleRemoteDataSource {
  final Dio _dio;

  VehicleRemoteDataSource({Dio? dio}) : _dio = dio ?? DioClient.instance.dio;

  /// GET /api/vehicles
  Future<List<VehicleModel>> getAllVehicles() async {
    final response = await _dio.get(ApiConstants.vehicles);
    final apiResponse = response.data as Map<String, dynamic>;

    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      final list = apiResponse['data'] as List<dynamic>;
      return list
          .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// GET /api/vehicles/{id}
  Future<VehicleModel> getVehicleById(int id) async {
    final response = await _dio.get(ApiConstants.vehicleById(id));
    final apiResponse = response.data as Map<String, dynamic>;

    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      return VehicleModel.fromJson(
        apiResponse['data'] as Map<String, dynamic>,
      );
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: 'Vehicle not found',
    );
  }

  /// POST /api/vehicles
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    final response = await _dio.post(
      ApiConstants.vehicles,
      data: vehicle.toJson(),
    );
    final apiResponse = response.data as Map<String, dynamic>;

    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      return VehicleModel.fromJson(
        apiResponse['data'] as Map<String, dynamic>,
      );
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse['message'] as String? ?? 'Failed to create vehicle',
    );
  }

  /// PUT /api/vehicles/{id}
  Future<VehicleModel> updateVehicle(int id, VehicleModel vehicle) async {
    final response = await _dio.put(
      ApiConstants.vehicleById(id),
      data: vehicle.toJson(),
    );
    final apiResponse = response.data as Map<String, dynamic>;

    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      return VehicleModel.fromJson(
        apiResponse['data'] as Map<String, dynamic>,
      );
    }
    throw DioException(
      requestOptions: response.requestOptions,
      message: apiResponse['message'] as String? ?? 'Failed to update vehicle',
    );
  }

  /// DELETE /api/vehicles/{id}
  Future<void> deleteVehicle(int id) async {
    await _dio.delete(ApiConstants.vehicleById(id));
  }

  /// GET /api/vehicles/search?query=xxx
  Future<List<VehicleModel>> searchVehicles(String query) async {
    final response = await _dio.get(
      ApiConstants.vehicleSearch,
      queryParameters: {'query': query},
    );
    final apiResponse = response.data as Map<String, dynamic>;

    if (apiResponse['success'] == true && apiResponse['data'] != null) {
      final list = apiResponse['data'] as List<dynamic>;
      return list
          .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
