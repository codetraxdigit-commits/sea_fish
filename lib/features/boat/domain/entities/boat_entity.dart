import 'package:equatable/equatable.dart';

class BoatEntity extends Equatable {
  final String id;
  final String ownerId;
  final String boatName;
  final String registrationNumber;
  final String boatType;
  final double capacityKg;
  final String engineNumber;
  final String licenseNumber;
  final String imageUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BoatEntity({
    required this.id,
    required this.ownerId,
    required this.boatName,
    required this.registrationNumber,
    required this.boatType,
    required this.capacityKg,
    required this.engineNumber,
    required this.licenseNumber,
    required this.imageUrl,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    ownerId,
    boatName,
    registrationNumber,
    boatType,
    capacityKg,
    engineNumber,
    licenseNumber,
    imageUrl,
    status,
    createdAt,
    updatedAt,
  ];
}