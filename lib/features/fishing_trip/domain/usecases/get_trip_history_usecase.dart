import '../entities/fishing_trip_entity.dart';
import '../repositories/fishing_trip_repository.dart';

class GetTripHistoryUseCase {
  final FishingTripRepository repository;

  GetTripHistoryUseCase(this.repository);

  Future<List<FishingTripEntity>> call() {
    return repository.getTripHistory();
  }
}