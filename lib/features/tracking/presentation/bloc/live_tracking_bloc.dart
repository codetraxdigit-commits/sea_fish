import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/boat_location_entity.dart';
import '../../domain/usecases/start_live_tracking_usecase.dart';
import '../../domain/usecases/stop_live_tracking_usecase.dart';
import '../../domain/repositories/live_tracking_repository.dart';
import 'live_tracking_event.dart';
import 'live_tracking_state.dart';

class LiveTrackingBloc
    extends Bloc<LiveTrackingEvent, LiveTrackingState> {
  final StartLiveTrackingUseCase startLiveTrackingUseCase;
  final StopLiveTrackingUseCase stopLiveTrackingUseCase;
  final LiveTrackingRepository repository;

  StreamSubscription<BoatLocationEntity>? _locationSubscription;

  LiveTrackingBloc({
    required this.startLiveTrackingUseCase,
    required this.stopLiveTrackingUseCase,
    required this.repository,
  }) : super(const LiveTrackingState()) {
    on<LiveTrackingStartRequested>(_onStart);
    on<LiveTrackingStopRequested>(_onStop);
    on<LiveTrackingLocationReceived>(_onLocationReceived);
  }

  Future<void> _onStart(
      LiveTrackingStartRequested event,
      Emitter<LiveTrackingState> emit,
      ) async {
    emit(state.copyWith(
      status: LiveTrackingStatus.loading,
    ));

    try {
      await startLiveTrackingUseCase(
        fishermanId: event.fishermanId,
        boatId: event.boatId,
        tripId: event.tripId,
      );

      await _locationSubscription?.cancel();

      _locationSubscription = repository.locations.listen(
            (location) {
          if (!isClosed) {
            add(LiveTrackingLocationReceived(location));
          }
        },
        onError: (Object error) {
          if (!isClosed) {
            addError(error);
          }
        },
      );

      emit(state.copyWith(
        status: LiveTrackingStatus.tracking,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LiveTrackingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onStop(
      LiveTrackingStopRequested event,
      Emitter<LiveTrackingState> emit,
      ) async {
    emit(state.copyWith(
      status: LiveTrackingStatus.loading,
    ));

    try {
      await stopLiveTrackingUseCase(
        fishermanId: event.fishermanId,
      );

      await _locationSubscription?.cancel();
      _locationSubscription = null;

      emit(state.copyWith(
        status: LiveTrackingStatus.stopped,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LiveTrackingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLocationReceived(
      LiveTrackingLocationReceived event,
      Emitter<LiveTrackingState> emit,
      ) {
    emit(state.copyWith(
      status: LiveTrackingStatus.tracking,
      location: event.location,
    ));
  }

  @override
  Future<void> close() async {
    await _locationSubscription?.cancel();
    await super.close();
  }
}