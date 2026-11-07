import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_datasource.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource _dataSource;

  VehicleRepositoryImpl({required this._dataSource});

  @override
  Future<List<Vehicle>> getVehicles() => _dataSource.getAllVehicles();

  @override
  Future<Vehicle> getVehicleById(int id) => _dataSource.getVehicleById(id);

  @override
  Future<Vehicle> addVehicle(Vehicle vehicle) =>
      _dataSource.createVehicle(VehicleModel.fromEntity(vehicle));

  @override
  Future<Vehicle> updateVehicle(Vehicle vehicle) {
    final id = vehicle.id;
    if (id == null) {
      throw ArgumentError('A vehicle id is required for updates.');
    }
    return _dataSource.updateVehicle(id, VehicleModel.fromEntity(vehicle));
  }

  @override
  Future<void> deleteVehicle(int id) => _dataSource.deleteVehicle(id);

  @override
  Future<List<Vehicle>> searchVehicles(String query) =>
      _dataSource.searchVehicles(query);
}
