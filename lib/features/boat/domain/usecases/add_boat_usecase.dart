import '../entities/boat_entity.dart';
import '../repositories/boat_repository.dart';

class AddBoatUseCase {
  final BoatRepository repository;

  AddBoatUseCase(this.repository);

  Future<BoatEntity> call({
    required String boatName,
    required String registrationNumber,
    required String boatType,
    required double capacityKg,
    required String engineNumber,
    required String licenseNumber,
    required String imagePath,
  }) {
    return repository.addBoat(
      boatName: boatName,
      registrationNumber: registrationNumber,
      boatType: boatType,
      capacityKg: capacityKg,
      engineNumber: engineNumber,
      licenseNumber: licenseNumber,
      imagePath: imagePath,
    );
  }
}