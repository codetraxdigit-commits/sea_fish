import '../../domain/entities/boat_entity.dart';
import '../../domain/repositories/boat_repository.dart';
import '../datasources/boat_remote_datasource.dart';

class BoatRepositoryImpl implements BoatRepository {
  final BoatRemoteDataSource remoteDataSource;

  BoatRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<BoatEntity?> getMyBoat() async {
    return await remoteDataSource.getMyBoat();
  }

  @override
  Future<BoatEntity> addBoat({
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
  }) async {
    return await remoteDataSource.addBoat(
      boatName: boatName,
      registrationNumber: registrationNumber,
      boatType: boatType,
      capacityKg: capacityKg,
      engineNumber: engineNumber,
      licenseNumber: licenseNumber,
      imagePath: imagePath,
    );
  }

  @override
  Future<BoatEntity> updateBoat({
    required String boatId,
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
    required String existingImageUrl,
  }) async {
    return await remoteDataSource.updateBoat(
      boatId: boatId,
      boatName: boatName,
      registrationNumber: registrationNumber,
      boatType: boatType,
      capacityKg: capacityKg,
      engineNumber: engineNumber,
      licenseNumber: licenseNumber,
      imagePath: imagePath,
      existingImageUrl: existingImageUrl,
    );
  }
}