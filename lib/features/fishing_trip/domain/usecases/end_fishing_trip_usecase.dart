
import 'package:fishtrack/features/fishing_trip/domain/entities/fishing_trip_entity.dart';
import 'package:fishtrack/features/fishing_trip/domain/repositories/fishing_trip_repository.dart';

class EndFishingTripUseCase {
  final FishingTripRepository repository;

  EndFishingTripUseCase(this.repository);

  Future<FishingTripEntity> call({
    required String tripId,
  }) {
    return repository.endFishingTrip(
      tripId: tripId,
    );
  }
}