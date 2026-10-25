import '../entities/fishing_trip_entity.dart';

abstract class FishingTripRepository {
  Future<FishingTripEntity> startFishingTrip({
    required String boatId,
  });

  Future<FishingTripEntity?> getActiveFishingTrip();

  Future<FishingTripEntity> endFishingTrip({
    required String tripId,
  });

  Future<List<FishingTripEntity>> getTripHistory();
}