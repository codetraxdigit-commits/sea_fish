import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dashboard_entity.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc
    extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;

  DashboardBloc({
    required this.getDashboardUseCase,
  }) : super(const DashboardState()) {
    on<DashboardFetchRequested>(
      _onDashboardFetchRequested,
    );

    on<DashboardRefreshRequested>(
      _onDashboardRefreshRequested,
    );
  }

  Future<void> _onDashboardFetchRequested(
      DashboardFetchRequested event,
      Emitter<DashboardState> emit,
      ) async {
    emit(
      state.copyWith(
        status: DashboardStatus.loading,
        errorMessage: null,
      ),
    );

    try {
      final dashboard = await getDashboardUseCase();

      emit(
        DashboardState(
          status: DashboardStatus.success,
          dashboard: dashboard,
        ),
      );
    } catch (e) {
      emit(
        DashboardState(
          status: DashboardStatus.failure,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> _onDashboardRefreshRequested(
      DashboardRefreshRequested event,
      Emitter<DashboardState> emit,
      ) async {
    try {
      final dashboard = await getDashboardUseCase();

      emit(
        DashboardState(
          status: DashboardStatus.success,
          dashboard: dashboard,
        ),
      );
    } catch (e) {
      emit(
        DashboardState(
          status: DashboardStatus.failure,
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