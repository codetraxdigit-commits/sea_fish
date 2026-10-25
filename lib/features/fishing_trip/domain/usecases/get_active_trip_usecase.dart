import '../entities/fishing_trip_entity.dart';
import '../repositories/fishing_trip_repository.dart';

class GetActiveTripUseCase {
  final FishingTripRepository repository;

  GetActiveTripUseCase(this.repository);

  Future<FishingTripEntity?> call() {
    return repository.getActiveFishingTrip();
  }
}