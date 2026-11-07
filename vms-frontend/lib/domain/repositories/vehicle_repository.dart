import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getVehicles();
  Future<Vehicle> getVehicleById(int id);
  Future<Vehicle> addVehicle(Vehicle vehicle);
  Future<Vehicle> updateVehicle(Vehicle vehicle);
  Future<void> deleteVehicle(int id);
  Future<List<Vehicle>> searchVehicles(String query);
}
