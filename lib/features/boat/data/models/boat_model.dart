import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/boat_entity.dart';

class BoatModel extends BoatEntity {
  const BoatModel({
    required super.id,
    required super.ownerId,
    required super.boatName,
    required super.registrationNumber,
    required super.boatType,
    required super.capacityKg,
    required super.engineNumber,
    required super.licenseNumber,
    required super.imageUrl,
    required super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory BoatModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? {};

    return BoatModel(
      id: document.id,
      ownerId: (data['ownerId'] ?? '').toString(),
      boatName: (data['boatName'] ?? '').toString(),
      registrationNumber:
      (data['registrationNumber'] ?? '').toString(),
      boatType: (data['boatType'] ?? '').toString(),
      capacityKg: _toDouble(data['capacityKg']),
      engineNumber: (data['engineNumber'] ?? '').toString(),
      licenseNumber: (data['licenseNumber'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      status: (data['status'] ?? 'active').toString(),
      createdAt: _toDateTime(data['createdAt']),
      updatedAt: _toDateTime(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'boatName': boatName,
      'registrationNumber': registrationNumber,
      'boatType': boatType,
      'capacityKg': capacityKg,
      'engineNumber': engineNumber,
      'licenseNumber': licenseNumber,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(updatedAt!),
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return null;
  }
}