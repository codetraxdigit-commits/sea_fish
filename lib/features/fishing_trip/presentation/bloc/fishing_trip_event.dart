
import 'package:equatable/equatable.dart';

abstract class FishingTripEvent extends Equatable {
  const FishingTripEvent();

  @override
  List<Object?> get props => [];
}

class FishingTripFetchActiveRequested
    extends FishingTripEvent {
  const FishingTripFetchActiveRequested();
}

class FishingTripStartRequested
    extends FishingTripEvent {
  final String boatId;

  const FishingTripStartRequested({
    required this.boatId,
  });

  @override
  List<Object?> get props => [boatId];
}

class FishingTripEndRequested
    extends FishingTripEvent {
  final String tripId;

  const FishingTripEndRequested({
    required this.tripId,
  });

  @override
  List<Object?> get props => [tripId];
}

class FishingTripHistoryRequested
    extends FishingTripEvent {
  const FishingTripHistoryRequested();
}