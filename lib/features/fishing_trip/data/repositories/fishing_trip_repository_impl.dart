import '../../domain/entities/fishing_trip_entity.dart';
import '../../domain/repositories/fishing_trip_repository.dart';
import '../datasources/fishing_trip_remote_datasource.dart';

class FishingTripRepositoryImpl
    implements FishingTripRepository {
  final FishingTripRemoteDataSource remoteDataSource;

  FishingTripRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<FishingTripEntity> startFishingTrip({
    required String boatId,
  }) {
    return remoteDataSource.startFishingTrip(
      boatId: boatId,
    );
  }

  @override
  Future<FishingTripEntity?> getActiveFishingTrip() {
    return remoteDataSource.getActiveFishingTrip();
  }

  @override
  Future<FishingTripEntity> endFishingTrip({
    required String tripId,
  }) {
    return remoteDataSource.endFishingTrip(
      tripId: tripId,
    );
  }

  @override
  Future<List<FishingTripEntity>> getTripHistory() {
    return remoteDataSource.getTripHistory();
  }
}