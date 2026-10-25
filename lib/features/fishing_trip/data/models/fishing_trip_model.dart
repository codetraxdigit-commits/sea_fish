import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/fishing_trip_entity.dart';

class FishingTripModel extends FishingTripEntity {
  const FishingTripModel({
    required super.id,
    required super.fishermanId,
    required super.boatId,
    required super.status,
    required super.startTime,
    super.endTime,
    super.startLatitude,
    super.startLongitude,
    super.endLatitude,
    super.endLongitude,
    required super.totalDistance,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FishingTripModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? {};

    return FishingTripModel(
      id: document.id,
      fishermanId: data['fishermanId'] as String? ?? '',
      boatId: data['boatId'] as String? ?? '',
      status: _statusFromString(
        data['status'] as String? ?? 'active',
      ),
      startTime: _timestampToDateTime(
        data['startTime'],
      ),
      endTime: _nullableTimestampToDateTime(
        data['endTime'],
      ),
      startLatitude: (data['startLatitude'] as num?)?.toDouble(),
      startLongitude: (data['startLongitude'] as num?)?.toDouble(),
      endLatitude: (data['endLatitude'] as num?)?.toDouble(),
      endLongitude: (data['endLongitude'] as num?)?.toDouble(),
      totalDistance: (data['totalDistance'] as num?)?.toDouble() ?? 0,
      createdAt: _timestampToDateTime(
        data['createdAt'],
      ),
      updatedAt: _timestampToDateTime(
        data['updatedAt'],
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fishermanId': fishermanId,
      'boatId': boatId,
      'status': status.name,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime == null
          ? null
          : Timestamp.fromDate(endTime!),
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'totalDistance': totalDistance,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static FishingTripStatus _statusFromString(String value) {
    return FishingTripStatus.values.firstWhere(
          (status) => status.name == value,
      orElse: () => FishingTripStatus.active,
    );
  }

  static DateTime _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return DateTime.now();
  }

  static DateTime? _nullableTimestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return null;
  }
}