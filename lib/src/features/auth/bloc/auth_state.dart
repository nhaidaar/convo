part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class UnAuthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String verificationId;
  const AuthOtpSent(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String e;
  const AuthError(this.e);

  @override
  List<Object> get props => [e];
}

class AuthForgotPasswordSent extends AuthState {}
