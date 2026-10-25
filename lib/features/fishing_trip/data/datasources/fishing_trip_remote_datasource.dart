import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/fishing_trip_model.dart';

abstract class FishingTripRemoteDataSource {
  Future<FishingTripModel> startFishingTrip({
    required String boatId,
  });

  Future<FishingTripModel?> getActiveFishingTrip();

  Future<FishingTripModel> endFishingTrip({
    required String tripId,
  });

  Future<List<FishingTripModel>> getTripHistory();
}

class FishingTripRemoteDataSourceImpl
    implements FishingTripRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  FishingTripRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  String get _uid {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _tripsCollection {
    return firestore.collection('fishingTrips');
  }

  @override
  Future<FishingTripModel> startFishingTrip({
    required String boatId,
  }) async {
    // Check whether fisherman already has an active trip.
    final existingTrips = await _tripsCollection
        .where(
      'fishermanId',
      isEqualTo: _uid,
    )
        .get();

    final hasActiveTrip = existingTrips.docs.any(
          (doc) => doc.data()['status'] == 'active',
    );

    if (hasActiveTrip) {
      throw Exception(
        'You already have an active fishing trip.',
      );
    }

    final now = DateTime.now();

    final doc = _tripsCollection.doc();

    final data = {
      'fishermanId': _uid,
      'boatId': boatId,
      'status': 'active',
      'startTime': Timestamp.fromDate(now),
      'endTime': null,
      'startLatitude': null,
      'startLongitude': null,
      'endLatitude': null,
      'endLongitude': null,
      'totalDistance': 0.0,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };

    await doc.set(data);

    final snapshot = await doc.get();

    return FishingTripModel.fromFirestore(snapshot);
  }

  @override
  Future<FishingTripModel?> getActiveFishingTrip() async {
    final snapshot = await _tripsCollection
        .where(
      'fishermanId',
      isEqualTo: _uid,
    )
        .get();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (data['status'] == 'active') {
        return FishingTripModel.fromFirestore(doc);
      }
    }

    return null;
  }

  @override
  Future<FishingTripModel> endFishingTrip({
    required String tripId,
  }) async {
    final docRef = _tripsCollection.doc(tripId);

    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Fishing trip not found.');
    }

    final data = snapshot.data();

    if (data == null) {
      throw Exception('Fishing trip data not found.');
    }

    if (data['fishermanId'] != _uid) {
      throw Exception(
        'You are not allowed to update this trip.',
      );
    }

    if (data['status'] != 'active') {
      throw Exception(
        'This fishing trip is already completed.',
      );
    }

    final now = DateTime.now();

    await docRef.update({
      'status': 'completed',
      'endTime': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });

    final updatedSnapshot = await docRef.get();

    return FishingTripModel.fromFirestore(
      updatedSnapshot,
    );
  }

  @override
  Future<List<FishingTripModel>> getTripHistory() async {
    final snapshot = await _tripsCollection
        .where(
      'fishermanId',
      isEqualTo: _uid,
    )
        .get();

    final trips = snapshot.docs
        .map(
      FishingTripModel.fromFirestore,
    )
        .toList();

    trips.sort(
          (a, b) => b.startTime.compareTo(a.startTime),
    );

    return trips;
  }
}