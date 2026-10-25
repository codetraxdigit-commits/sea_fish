import 'package:equatable/equatable.dart';

enum FishingTripStatus {
  active,
  completed,
  cancelled,
}

class FishingTripEntity extends Equatable {
  final String id;
  final String fishermanId;
  final String boatId;

  final FishingTripStatus status;

  final DateTime startTime;
  final DateTime? endTime;

  final double? startLatitude;
  final double? startLongitude;

  final double? endLatitude;
  final double? endLongitude;

  final double totalDistance;

  final DateTime createdAt;
  final DateTime updatedAt;

  const FishingTripEntity({
    required this.id,
    required this.fishermanId,
    required this.boatId,
    required this.status,
    required this.startTime,
    this.endTime,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    required this.totalDistance,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    fishermanId,
    boatId,
    status,
    startTime,
    endTime,
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
    totalDistance,
    createdAt,
    updatedAt,
  ];
}