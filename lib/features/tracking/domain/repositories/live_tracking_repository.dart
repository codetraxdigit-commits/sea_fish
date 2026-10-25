import '../entities/boat_location_entity.dart';

abstract class LiveTrackingRepository {
  Stream<BoatLocationEntity> get locations;

  Future<void> startTracking({
    required String fishermanId,
    required String boatId,
    required String tripId,
  });

  Future<void> stopTracking({
    required String fishermanId,
  });
}