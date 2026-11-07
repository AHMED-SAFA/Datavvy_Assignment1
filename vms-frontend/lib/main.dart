import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/vehicle_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/vehicle_repository_impl.dart';
import 'presentation/app/vms_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final client = DioClient(sharedPreferences: preferences);
  final authRepository = AuthRepositoryImpl(
    dataSource: AuthRemoteDataSource(dio: client.dio),
    preferences: preferences,
  );
  final vehicleRepository = VehicleRepositoryImpl(
    dataSource: VehicleRemoteDataSource(dio: client.dio),
  );

  runApp(VmsApp(
    authRepository: authRepository,
    vehicleRepository: vehicleRepository,
  ));
}
