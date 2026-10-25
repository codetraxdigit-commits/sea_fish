import 'package:equatable/equatable.dart';

import '../../domain/entities/fishing_trip_entity.dart';
import '../../../boat/domain/entities/boat_entity.dart';

enum FishingTripBlocStatus {
  initial,
  loading,
  success,
  failure,
}

class FishingTripState extends Equatable {
  final FishingTripBlocStatus status;

  final FishingTripEntity? activeTrip;

  final List<FishingTripEntity> history;

  final BoatEntity? boat;

  final String? errorMessage;

  const FishingTripState({
    this.status = FishingTripBlocStatus.initial,
    this.activeTrip,
    this.history = const [],
    this.boat,
    this.errorMessage,
  });

  FishingTripState copyWith({
    FishingTripBlocStatus? status,
    FishingTripEntity? activeTrip,
    bool clearActiveTrip = false,
    List<FishingTripEntity>? history,
    BoatEntity? boat,
    bool clearBoat = false,
    String? errorMessage,
  }) {
    return FishingTripState(
      status: status ?? this.status,
      activeTrip:
      clearActiveTrip ? null : activeTrip ?? this.activeTrip,
      history: history ?? this.history,
      boat: clearBoat ? null : boat ?? this.boat,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    activeTrip,
    history,
    boat,
    errorMessage,
  ];
}