import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final int? id;
  final String vehicleNumber;
  final String brand;
  final String model;
  final String type; // CAR, TRUCK, BIKE, SUV, VAN
  final String color;
  final int year;
  final String ownerName;
  final String status; // ACTIVE, INACTIVE
  final DateTime registrationDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Vehicle({
    this.id,
    required this.vehicleNumber,
    required this.brand,
    required this.model,
    required this.type,
    required this.color,
    required this.year,
    required this.ownerName,
    required this.status,
    required this.registrationDate,
    this.createdAt,
    this.updatedAt,
  });

  Vehicle copyWith({
    int? id,
    String? vehicleNumber,
    String? brand,
    String? model,
    String? type,
    String? color,
    int? year,
    String? ownerName,
    String? status,
    DateTime? registrationDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      color: color ?? this.color,
      year: year ?? this.year,
      ownerName: ownerName ?? this.ownerName,
      status: status ?? this.status,
      registrationDate: registrationDate ?? this.registrationDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        vehicleNumber,
        brand,
        model,
        type,
        color,
        year,
        ownerName,
        status,
        registrationDate,
        createdAt,
        updatedAt,
      ];
}
