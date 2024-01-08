part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PhoneSendOtpEvent extends AuthEvent {
  final String phoneNumber;
  PhoneSendOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class PhoneVerifyOtpEvent extends AuthEvent {
  final String otpCode;
  final String verificationId;
  PhoneVerifyOtpEvent(this.otpCode, this.verificationId);

  @override
  List<Object> get props => [otpCode, verificationId];
}

class PhoneOnOtpSendEvent extends AuthEvent {
  final String verificationId;
  final int? token;
  PhoneOnOtpSendEvent(
    this.verificationId,
    this.token,
  );

  @override
  List<Object> get props => [verificationId];
}

class PhoneOnErrorEvent extends AuthEvent {
  final String e;
  PhoneOnErrorEvent(this.e);

  @override
  List<Object> get props => [e];
}

class PhoneOnOtpVerifiedEvent extends AuthEvent {
  final AuthCredential credential;
  PhoneOnOtpVerifiedEvent(this.credential);
}

class EmailSignUpEvent extends AuthEvent {
  final String email, password;
  EmailSignUpEvent(this.email, this.password);
}

class EmailSignInEvent extends AuthEvent {
  final String email, password;
  EmailSignInEvent(this.email, this.password);
}

class SignOutEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}
