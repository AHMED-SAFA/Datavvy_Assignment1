import '../../domain/entities/vehicle.dart';

/// Data model for Vehicle with JSON serialization.
///
/// Maps between the domain [Vehicle] entity and the API JSON format.
class VehicleModel extends Vehicle {
  const VehicleModel({
    super.id,
    required super.vehicleNumber,
    required super.brand,
    required super.model,
    required super.type,
    required super.color,
    required super.year,
    required super.ownerName,
    required super.status,
    required super.registrationDate,
    super.createdAt,
    super.updatedAt,
  });

  /// Create a [VehicleModel] from API JSON response.
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int?,
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      type: json['type'] as String? ?? 'CAR',
      color: json['color'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      ownerName: json['ownerName'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      registrationDate: DateTime.tryParse(
            json['registrationDate'] as String? ?? '',
          ) ??
          DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON for API request.
  Map<String, dynamic> toJson() {
    return {
      'vehicleNumber': vehicleNumber,
      'brand': brand,
      'model': model,
      'type': type,
      'color': color,
      'year': year,
      'ownerName': ownerName,
      'status': status,
      'registrationDate': registrationDate.toIso8601String().split('T').first,
    };
  }

  /// Create a [VehicleModel] from a domain [Vehicle] entity.
  factory VehicleModel.fromEntity(Vehicle entity) {
    return VehicleModel(
      id: entity.id,
      vehicleNumber: entity.vehicleNumber,
      brand: entity.brand,
      model: entity.model,
      type: entity.type,
      color: entity.color,
      year: entity.year,
      ownerName: entity.ownerName,
      status: entity.status,
      registrationDate: entity.registrationDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
