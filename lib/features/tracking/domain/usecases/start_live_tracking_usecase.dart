import '../repositories/live_tracking_repository.dart';

class StartLiveTrackingUseCase {
  final LiveTrackingRepository repository;

  StartLiveTrackingUseCase(this.repository);

  Future<void> call({
    required String fishermanId,
    required String boatId,
    required String tripId,
  }) {
    return repository.startTracking(
      fishermanId: fishermanId,
      boatId: boatId,
      tripId: tripId,
    );
  }
}