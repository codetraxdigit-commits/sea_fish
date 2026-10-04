import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboard();
}

class DashboardRemoteDataSourceImpl
    implements DashboardRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<DashboardModel> getDashboard() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      throw Exception('User is not logged in.');
    }

    final uid = firebaseUser.uid;

    // ------------------------------------------------------------
    // USER
    // ------------------------------------------------------------

    final userDocument = await firestore
        .collection('users')
        .doc(uid)
        .get();

    final userData = userDocument.data() ?? {};

    final String userName =
    (userData['name'] ?? 'Fisherman').toString();

    final String role =
    (userData['role'] ?? 'fisherman').toString();

    // ------------------------------------------------------------
    // BOAT
    // ------------------------------------------------------------

    final boatSnapshot = await firestore
        .collection('boats')
        .where('ownerId', isEqualTo: uid)
        .limit(1)
        .get();

    bool hasBoat = false;
    String boatName = '';
    String boatStatus = 'No Boat';
    String boatRegistrationNumber = '';

    if (boatSnapshot.docs.isNotEmpty) {
      final boatData = boatSnapshot.docs.first.data();

      hasBoat = true;

      boatName =
          (boatData['boatName'] ?? 'My Boat').toString();

      boatStatus =
          (boatData['status'] ?? 'inactive').toString();

      boatRegistrationNumber =
          (boatData['registrationNumber'] ?? '').toString();
    }

    // ------------------------------------------------------------
    // ACTIVE TRIP
    // ------------------------------------------------------------

    final activeTripSnapshot = await firestore
        .collection('fishingTrips')
        .where('fishermanId', isEqualTo: uid)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();

    bool hasActiveTrip = false;
    String tripStatus = '';
    String tripType = '';

    if (activeTripSnapshot.docs.isNotEmpty) {
      final tripData =
      activeTripSnapshot.docs.first.data();

      hasActiveTrip = true;

      tripStatus =
          (tripData['status'] ?? 'active').toString();

      tripType =
          (tripData['tripType'] ?? 'Fishing Trip').toString();
    }

    // ------------------------------------------------------------
    // TODAY START
    // ------------------------------------------------------------

    final now = DateTime.now();

    final todayStart = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final Timestamp todayTimestamp =
    Timestamp.fromDate(todayStart);

    // ------------------------------------------------------------
    // TODAY CATCH
    // ------------------------------------------------------------

    double todayCatchKg = 0;

    final catchSnapshot = await firestore
        .collection('catches')
        .where(
      'fishermanId',
      isEqualTo: uid,
    )
        .where(
      'createdAt',
      isGreaterThanOrEqualTo: todayTimestamp,
    )
        .get();

    for (final document in catchSnapshot.docs) {
      final data = document.data();

      final dynamic quantity = data['quantityKg'];

      if (quantity is num) {
        todayCatchKg += quantity.toDouble();
      } else {
        todayCatchKg +=
            double.tryParse(quantity?.toString() ?? '0') ?? 0;
      }
    }

    // ------------------------------------------------------------
    // TODAY SALES
    // ------------------------------------------------------------

    double todaySales = 0;

    final salesSnapshot = await firestore
        .collection('orders')
        .where(
      'fishermanId',
      isEqualTo: uid,
    )
        .where(
      'createdAt',
      isGreaterThanOrEqualTo: todayTimestamp,
    )
        .get();

    for (final document in salesSnapshot.docs) {
      final data = document.data();

      final dynamic amount = data['totalAmount'];

      if (amount is num) {
        todaySales += amount.toDouble();
      } else {
        todaySales +=
            double.tryParse(amount?.toString() ?? '0') ?? 0;
      }
    }

    // ------------------------------------------------------------
    // NOTIFICATIONS
    // ------------------------------------------------------------

    int notificationCount = 0;

    final notificationSnapshot = await firestore
        .collection('notifications')
        .where(
      'userId',
      isEqualTo: uid,
    )
        .where(
      'isRead',
      isEqualTo: false,
    )
        .get();

    notificationCount = notificationSnapshot.docs.length;

    // ------------------------------------------------------------
    // RETURN
    // ------------------------------------------------------------

    return DashboardModel(
      userName: userName,
      role: role,
      hasBoat: hasBoat,
      boatName: boatName,
      boatStatus: boatStatus,
      boatRegistrationNumber: boatRegistrationNumber,
      hasActiveTrip: hasActiveTrip,
      tripStatus: tripStatus,
      tripType: tripType,
      todayCatchKg: todayCatchKg,
      todaySales: todaySales,
      notificationCount: notificationCount,
    );
  }
}