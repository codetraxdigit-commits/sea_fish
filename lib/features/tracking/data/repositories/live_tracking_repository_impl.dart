import '../../domain/entities/boat_location_entity.dart';
import '../../domain/repositories/live_tracking_repository.dart';
import '../datasources/live_tracking_remote_datasource.dart';

class LiveTrackingRepositoryImpl implements LiveTrackingRepository {
  final LiveTrackingRemoteDataSource remoteDataSource;

  LiveTrackingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Stream<BoatLocationEntity> get locations =>
      remoteDataSource.locations;

  @override
  Future<void> startTracking({
    required String fishermanId,
    required String boatId,
    required String tripId,
  }) {
    return remoteDataSource.startTracking(
      fishermanId: fishermanId,
      boatId: boatId,
      tripId: tripId,
    );
  }

  @override
  Future<void> stopTracking({
    required String fishermanId,
  }) {
    return remoteDataSource.stopTracking(
      fishermanId: fishermanId,
    );
  }
}