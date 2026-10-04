import '../entities/boat_entity.dart';
import '../repositories/boat_repository.dart';

class UpdateBoatUseCase {
  final BoatRepository repository;

  UpdateBoatUseCase(this.repository);

  Future<BoatEntity> call({
    required String boatId,
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
    required String existingImageUrl,
  }) {
    return repository.updateBoat(
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