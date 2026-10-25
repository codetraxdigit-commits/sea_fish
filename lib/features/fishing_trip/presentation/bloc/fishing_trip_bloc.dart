import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/start_fishing_trip_usecase.dart';
import '../../domain/usecases/get_active_trip_usecase.dart';
import '../../domain/usecases/end_fishing_trip_usecase.dart';
import '../../domain/usecases/get_trip_history_usecase.dart';

import '../../../boat/domain/usecases/get_my_boat_usecase.dart';

import 'fishing_trip_event.dart';
import 'fishing_trip_state.dart';

class FishingTripBloc
    extends Bloc<FishingTripEvent, FishingTripState> {
  final StartFishingTripUseCase startFishingTripUseCase;
  final GetActiveTripUseCase getActiveTripUseCase;
  final EndFishingTripUseCase endFishingTripUseCase;
  final GetTripHistoryUseCase getTripHistoryUseCase;
  final GetMyBoatUseCase getMyBoatUseCase;

  FishingTripBloc({
    required this.startFishingTripUseCase,
    required this.getActiveTripUseCase,
    required this.endFishingTripUseCase,
    required this.getTripHistoryUseCase,
    required this.getMyBoatUseCase,
  }) : super(const FishingTripState()) {
    on<FishingTripFetchActiveRequested>(
      _onFetchActiveTrip,
    );

    on<FishingTripStartRequested>(
      _onStartTrip,
    );

    on<FishingTripEndRequested>(
      _onEndTrip,
    );

    on<FishingTripHistoryRequested>(
      _onFetchHistory,
    );
  }

  Future<void> _onFetchActiveTrip(
      FishingTripFetchActiveRequested event,
      Emitter<FishingTripState> emit,
      ) async {
    emit(
      state.copyWith(
        status: FishingTripBlocStatus.loading,
      ),
    );

    try {
      // Get boat
      final boat = await getMyBoatUseCase();

      // Get active trip
      final activeTrip =
      await getActiveTripUseCase();

      emit(
        state.copyWith(
          status: FishingTripBlocStatus.success,
          boat: boat,
          activeTrip: activeTrip,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FishingTripBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStartTrip(
      FishingTripStartRequested event,
      Emitter<FishingTripState> emit,
      ) async {
    emit(
      state.copyWith(
        status: FishingTripBlocStatus.loading,
      ),
    );

    try {
      final trip = await startFishingTripUseCase(
        boatId: event.boatId,
      );

      emit(
        state.copyWith(
          status: FishingTripBlocStatus.success,
          activeTrip: trip,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FishingTripBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEndTrip(
      FishingTripEndRequested event,
      Emitter<FishingTripState> emit,
      ) async {
    emit(
      state.copyWith(
        status: FishingTripBlocStatus.loading,
      ),
    );

    try {
      await endFishingTripUseCase(
        tripId: event.tripId,
      );

      emit(
        state.copyWith(
          status: FishingTripBlocStatus.success,
          clearActiveTrip: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FishingTripBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchHistory(
      FishingTripHistoryRequested event,
      Emitter<FishingTripState> emit,
      ) async {
    emit(
      state.copyWith(
        status: FishingTripBlocStatus.loading,
      ),
    );

    try {
      final history =
      await getTripHistoryUseCase();

      emit(
        state.copyWith(
          status: FishingTripBlocStatus.success,
          history: history,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FishingTripBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}