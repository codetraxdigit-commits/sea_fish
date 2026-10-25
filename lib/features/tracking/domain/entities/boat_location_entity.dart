import 'package:equatable/equatable.dart';

class BoatLocationEntity extends Equatable {
  final String fishermanId;
  final String boatId;
  final String tripId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final double heading;
  final DateTime updatedAt;
  final bool isTracking;

  const BoatLocationEntity({
    required this.fishermanId,
    required this.boatId,
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.heading,
    required this.updatedAt,
    required this.isTracking,
  });

  @override
  List<Object?> get props => [
    fishermanId,
    boatId,
    tripId,
    latitude,
    longitude,
    accuracy,
    speed,
    heading,
    updatedAt,
    isTracking,
  ];
}
