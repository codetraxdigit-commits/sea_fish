import 'package:equatable/equatable.dart';

import '../../domain/entities/boat_location_entity.dart';

abstract class LiveTrackingEvent extends Equatable {
  const LiveTrackingEvent();

  @override
  List<Object?> get props => [];
}

class LiveTrackingStartRequested extends LiveTrackingEvent {
  final String fishermanId;
  final String boatId;
  final String tripId;

  const LiveTrackingStartRequested({
    required this.fishermanId,
    required this.boatId,
    required this.tripId,
  });

  @override
  List<Object?> get props => [
    fishermanId,
    boatId,
    tripId,
  ];
}

class LiveTrackingStopRequested extends LiveTrackingEvent {
  final String fishermanId;

  const LiveTrackingStopRequested({
    required this.fishermanId,
  });

  @override
  List<Object?> get props => [fishermanId];
}

class LiveTrackingLocationReceived extends LiveTrackingEvent {
  final BoatLocationEntity location;

  const LiveTrackingLocationReceived(this.location);

  @override
  List<Object?> get props => [location];
}