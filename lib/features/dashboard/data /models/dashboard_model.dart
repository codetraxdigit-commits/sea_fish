import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.userName,
    required super.role,
    required super.hasBoat,
    required super.boatName,
    required super.boatStatus,
    required super.boatRegistrationNumber,
    required super.hasActiveTrip,
    required super.tripStatus,
    required super.tripType,
    required super.todayCatchKg,
    required super.todaySales,
    required super.notificationCount,
  });

  factory DashboardModel.fromEntity(DashboardEntity entity) {
    return DashboardModel(
      userName: entity.userName,
      role: entity.role,
      hasBoat: entity.hasBoat,
      boatName: entity.boatName,
      boatStatus: entity.boatStatus,
      boatRegistrationNumber: entity.boatRegistrationNumber,
      hasActiveTrip: entity.hasActiveTrip,
      tripStatus: entity.tripStatus,
      tripType: entity.tripType,
      todayCatchKg: entity.todayCatchKg,
      todaySales: entity.todaySales,
      notificationCount: entity.notificationCount,
    );
  }
}