import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String userName;
  final String role;

  final bool hasBoat;
  final String boatName;
  final String boatStatus;
  final String boatRegistrationNumber;

  final bool hasActiveTrip;
  final String tripStatus;
  final String tripType;

  final double todayCatchKg;
  final double todaySales;

  final int notificationCount;

  const DashboardEntity({
    required this.userName,
    required this.role,
    required this.hasBoat,
    required this.boatName,
    required this.boatStatus,
    required this.boatRegistrationNumber,
    required this.hasActiveTrip,
    required this.tripStatus,
    required this.tripType,
    required this.todayCatchKg,
    required this.todaySales,
    required this.notificationCount,
  });

  const DashboardEntity.empty()
      : userName = 'Fisherman',
        role = 'fisherman',
        hasBoat = false,
        boatName = '',
        boatStatus = 'No Boat',
        boatRegistrationNumber = '',
        hasActiveTrip = false,
        tripStatus = '',
        tripType = '',
        todayCatchKg = 0,
        todaySales = 0,
        notificationCount = 0;

  @override
  List<Object?> get props => [
    userName,
    role,
    hasBoat,
    boatName,
    boatStatus,
    boatRegistrationNumber,
    hasActiveTrip,
    tripStatus,
    tripType,
    todayCatchKg,
    todaySales,
    notificationCount,
  ];
}