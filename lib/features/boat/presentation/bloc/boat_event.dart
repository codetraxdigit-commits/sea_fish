part of 'boat_bloc.dart';

abstract class BoatEvent extends Equatable {
  const BoatEvent();

  @override
  List<Object?> get props => [];
}

class BoatFetchRequested extends BoatEvent {
  const BoatFetchRequested();
}

class AddBoatRequested extends BoatEvent {
  final String boatName;
  final String registrationNumber;
  final String boatType;
  final double capacityKg;
  final String engineNumber;
  final String licenseNumber;
  final String imagePath;

  const AddBoatRequested({
    required this.boatName,
    required this.registrationNumber,
    required this.boatType,
    required this.capacityKg,
    required this.engineNumber,
    required this.licenseNumber,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [
    boatName,
    registrationNumber,
    boatType,
    capacityKg,
    engineNumber,
    licenseNumber,
    imagePath,
  ];
}

class UpdateBoatRequested extends BoatEvent {
  final String boatId;
  final String boatName;
  final String registrationNumber;
  final String boatType;
  final double capacityKg;
  final String engineNumber;
  final String licenseNumber;
  final String imagePath;
  final String existingImageUrl;

  const UpdateBoatRequested({
    required this.boatId,
    required this.boatName,
    required this.registrationNumber,
    required this.boatType,
    required this.capacityKg,
    required this.engineNumber,
    required this.licenseNumber,
    required this.imagePath,
    required this.existingImageUrl,
  });

  @override
  List<Object?> get props => [
    boatId,
    boatName,
    registrationNumber,
    boatType,
    capacityKg,
    engineNumber,
    licenseNumber,
    imagePath,
    existingImageUrl,
  ];
}