part of 'dashboard_bloc.dart';

enum DashboardStatus {
  initial,
  loading,
  success,
  failure,
}

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardEntity? dashboard;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardEntity? dashboard,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dashboard,
    errorMessage,
  ];
}