part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// ----------------------------------------------------------
// LOGIN
// ----------------------------------------------------------

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    email,
    password,
  ];
}

// ----------------------------------------------------------
// REGISTER
// ----------------------------------------------------------

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    role,
  ];
}

// ----------------------------------------------------------
// LOGOUT
// ----------------------------------------------------------

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}