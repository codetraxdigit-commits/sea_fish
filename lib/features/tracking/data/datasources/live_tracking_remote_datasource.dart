
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../tracking/domain/entities/boat_location_entity.dart';

class LiveTrackingRemoteDataSource {
  final FirebaseDatabase database;

  LiveTrackingRemoteDataSource({
    required this.database,
  });

  StreamSubscription<Position>? _positionSubscription;
  final StreamController<BoatLocationEntity> _locationController =
  StreamController<BoatLocationEntity>.broadcast();

  Stream<BoatLocationEntity> get locations =>
      _locationController.stream;

  Future<void> startTracking({
    required String fishermanId,
    required String boatId,
    required String tripId,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Background boat tracking requires the Android or iOS app.',
      );
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception(
        'Enable location services on your phone.',
      );
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is required. Enable it in app settings.',
      );
    }

    if (permission != LocationPermission.always) {
      throw Exception(
        'For background tracking, allow location access all the time '
            'in your phone settings.',
      );
    }

    await _positionSubscription?.cancel();

    final locationSettings = defaultTargetPlatform ==
        TargetPlatform.android
        ? AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      intervalDuration: const Duration(seconds: 10),
      foregroundNotificationConfig:
      const ForegroundNotificationConfig(
        notificationTitle: 'FishTrack boat tracking',
        notificationText:
        'Location is being shared during your active fishing trip.',
        enableWakeLock: true,
      ),
    )
        : AppleSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      activityType: ActivityType.otherNavigation,
      pauseLocationUpdatesAutomatically: false,
      allowBackgroundLocationUpdates: true,
      showBackgroundLocationIndicator: true,
    );

    final locationRef =
    database.ref('liveBoatLocations/$fishermanId');

    await locationRef.update({
      'boatId': boatId,
      'tripId': tripId,
      'isTracking': true,
      'updatedAt': ServerValue.timestamp,
    });

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
          (position) async {
        try {
          final location = BoatLocationEntity(
            fishermanId: fishermanId,
            boatId: boatId,
            tripId: tripId,
            latitude: position.latitude,
            longitude: position.longitude,
            accuracy: position.accuracy,
            speed: position.speed,
            heading: position.heading,
            updatedAt: position.timestamp,
            isTracking: true,
          );

          await locationRef.update({
            'latitude': location.latitude,
            'longitude': location.longitude,
            'accuracy': location.accuracy,
            'speed': location.speed,
            'heading': location.heading,
            'updatedAt': ServerValue.timestamp,
            'isTracking': true,
          });

          if (!_locationController.isClosed) {
            _locationController.add(location);
          }
        } catch (error, stackTrace) {
          debugPrint('GPS upload failed: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('GPS stream error: $error');

        if (!_locationController.isClosed) {
          _locationController.addError(error, stackTrace);
        }
      },
    );
  }

  Future<void> stopTracking({
    required String fishermanId,
  }) async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;

    await database
        .ref('liveBoatLocations/$fishermanId')
        .update({
      'isTracking': false,
      'updatedAt': ServerValue.timestamp,
    });
  }

  Future<void> dispose() async {
    await _positionSubscription?.cancel();
    await _locationController.close();
  }
}
