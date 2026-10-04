import '../entities/boat_entity.dart';

abstract class BoatRepository {
  Future<BoatEntity?> getMyBoat();

  Future<BoatEntity> addBoat({
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
  });

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
  });
}