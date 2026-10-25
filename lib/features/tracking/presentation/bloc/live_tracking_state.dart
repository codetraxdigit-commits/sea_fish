import 'package:equatable/equatable.dart';

import '../../domain/entities/boat_location_entity.dart';

enum LiveTrackingStatus {
  initial,
  loading,
  tracking,
  stopped,
  failure,
}

class LiveTrackingState extends Equatable {
  final LiveTrackingStatus status;
  final BoatLocationEntity? location;
  final String? errorMessage;

  const LiveTrackingState({
    this.status = LiveTrackingStatus.initial,
    this.location,
    this.errorMessage,
  });

  LiveTrackingState copyWith({
    LiveTrackingStatus? status,
    BoatLocationEntity? location,
    bool clearLocation = false,
    String? errorMessage,
  }) {
    return LiveTrackingState(
      status: status ?? this.status,
      location: clearLocation ? null : location ?? this.location,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    location,
    errorMessage,
  ];
}