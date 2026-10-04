import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/boat_entity.dart';
import '../../domain/usecases/add_boat_usecase.dart';
import '../../domain/usecases/get_my_boat_usecase.dart';
import '../../domain/usecases/update_boat_usecase.dart';

part 'boat_event.dart';
part 'boat_state.dart';

class BoatBloc extends Bloc<BoatEvent, BoatState> {
  final GetMyBoatUseCase getMyBoatUseCase;
  final AddBoatUseCase addBoatUseCase;
  final UpdateBoatUseCase updateBoatUseCase;

  BoatBloc({
    required this.getMyBoatUseCase,
    required this.addBoatUseCase,
    required this.updateBoatUseCase,
  }) : super(const BoatState()) {
    on<BoatFetchRequested>(_onBoatFetchRequested);
    on<AddBoatRequested>(_onAddBoatRequested);
    on<UpdateBoatRequested>(_onUpdateBoatRequested);
  }

  Future<void> _onBoatFetchRequested(
      BoatFetchRequested event,
      Emitter<BoatState> emit,
      ) async {
    print('========== BOAT FETCH EVENT ==========');

    emit(
      state.copyWith(
        status: BoatStatus.loading,
      ),
    );

    try {
      debugPrint('Calling GetMyBoatUseCase...');

      final boat = await getMyBoatUseCase();

      debugPrint('Boat result: $boat');

      emit(
        state.copyWith(
          status: BoatStatus.success,
          boat: boat,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('BOAT FETCH ERROR: $e');
      debugPrint('$stackTrace');

      emit(
        state.copyWith(
          status: BoatStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddBoatRequested(
      AddBoatRequested event,
      Emitter<BoatState> emit,
      ) async {
    emit(
      state.copyWith(
        status: BoatStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final boat = await addBoatUseCase(
        boatName: event.boatName,
        registrationNumber: event.registrationNumber,
        boatType: event.boatType,
        capacityKg: event.capacityKg,
        engineNumber: event.engineNumber,
        licenseNumber: event.licenseNumber,
        imagePath: event.imagePath,
      );

      emit(
        BoatState(
          status: BoatStatus.success,
          boat: boat,
        ),
      );
    } catch (e) {
      emit(
        BoatState(
          status: BoatStatus.failure,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onUpdateBoatRequested(
      UpdateBoatRequested event,
      Emitter<BoatState> emit,
      ) async {
    emit(
      state.copyWith(
        status: BoatStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final boat = await updateBoatUseCase(
        boatId: event.boatId,
        boatName: event.boatName,
        registrationNumber: event.registrationNumber,
        boatType: event.boatType,
        capacityKg: event.capacityKg,
        engineNumber: event.engineNumber,
        licenseNumber: event.licenseNumber,
        imagePath: event.imagePath,
        existingImageUrl: event.existingImageUrl,
      );

      emit(
        BoatState(
          status: BoatStatus.success,
          boat: boat,
        ),
      );
    } catch (e) {
      emit(
        BoatState(
          status: BoatStatus.failure,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }
}