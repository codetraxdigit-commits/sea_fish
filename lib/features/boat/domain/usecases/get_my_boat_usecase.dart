import '../entities/boat_entity.dart';
import '../repositories/boat_repository.dart';

class GetMyBoatUseCase {
  final BoatRepository repository;

  GetMyBoatUseCase(this.repository);

  Future<BoatEntity?> call() {
    return repository.getMyBoat();
  }
}