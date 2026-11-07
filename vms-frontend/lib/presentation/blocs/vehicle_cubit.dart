import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

enum VehicleStatus { initial, loading, loaded, saving, failure }

class VehicleState {
  final VehicleStatus status;
  final List<Vehicle> vehicles;
  final String? errorMessage;

  const VehicleState({
    this.status = VehicleStatus.initial,
    this.vehicles = const [],
    this.errorMessage,
  });
}

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository _repository;

  VehicleCubit({required this._repository})
      : super(const VehicleState());

  Future<void> loadVehicles({String query = ''}) async {
    emit(VehicleState(status: VehicleStatus.loading, vehicles: state.vehicles));
    try {
      final vehicles = query.trim().isEmpty
          ? await _repository.getVehicles()
          : await _repository.searchVehicles(query.trim());
      emit(VehicleState(status: VehicleStatus.loaded, vehicles: vehicles));
    } catch (error) {
      emit(VehicleState(
        status: VehicleStatus.failure,
        vehicles: state.vehicles,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<bool> saveVehicle(Vehicle vehicle) async {
    emit(VehicleState(status: VehicleStatus.saving, vehicles: state.vehicles));
    try {
      final saved = vehicle.id == null
          ? await _repository.addVehicle(vehicle)
          : await _repository.updateVehicle(vehicle);
      final vehicles = [
        for (final item in state.vehicles)
          if (item.id != saved.id) item,
        saved,
      ]..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      emit(VehicleState(status: VehicleStatus.loaded, vehicles: vehicles));
      return true;
    } catch (error) {
      emit(VehicleState(
        status: VehicleStatus.failure,
        vehicles: state.vehicles,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ));
      return false;
    }
  }

  Future<bool> deleteVehicle(int id) async {
    emit(VehicleState(status: VehicleStatus.saving, vehicles: state.vehicles));
    try {
      await _repository.deleteVehicle(id);
      emit(VehicleState(
        status: VehicleStatus.loaded,
        vehicles: state.vehicles.where((vehicle) => vehicle.id != id).toList(),
      ));
      return true;
    } catch (error) {
      emit(VehicleState(
        status: VehicleStatus.failure,
        vehicles: state.vehicles,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ));
      return false;
    }
  }
}
