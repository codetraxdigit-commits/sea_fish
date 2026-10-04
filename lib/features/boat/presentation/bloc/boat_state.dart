part of 'boat_bloc.dart';


enum BoatStatus {
  initial,
  loading,
  success,
  failure,
}

class BoatState extends Equatable {
  final BoatStatus status;
  final BoatEntity? boat;
  final String? errorMessage;

  const BoatState({
    this.status = BoatStatus.initial,
    this.boat,
    this.errorMessage,
  });

  BoatState copyWith({
    BoatStatus? status,
    BoatEntity? boat,
    String? errorMessage,
    bool clearBoat = false,
  }) {
    return BoatState(
      status: status ?? this.status,
      boat: clearBoat ? null : (boat ?? this.boat),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    boat,
    errorMessage,
  ];
}