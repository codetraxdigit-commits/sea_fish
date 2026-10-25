import '../entities/fishing_trip_entity.dart';
import '../repositories/fishing_trip_repository.dart';

class StartFishingTripUseCase {
  final FishingTripRepository repository;

  StartFishingTripUseCase(this.repository);

  Future<FishingTripEntity> call({
    required String boatId,
  }) {
    return repository.startFishingTrip(
      boatId: boatId,
    );
  }
}