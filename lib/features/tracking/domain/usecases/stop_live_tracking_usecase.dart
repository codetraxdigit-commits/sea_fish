import '../repositories/live_tracking_repository.dart';

class StopLiveTrackingUseCase {
  final LiveTrackingRepository repository;

  StopLiveTrackingUseCase(this.repository);

  Future<void> call({
    required String fishermanId,
  }) {
    return repository.stopTracking(
      fishermanId: fishermanId,
    );
  }
}