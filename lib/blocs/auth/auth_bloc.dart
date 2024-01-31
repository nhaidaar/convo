import 'package:convo/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository auth;
  AuthBloc({required this.auth}) : super(UnAuthenticated()) {
    final user = FirebaseAuth.instance.currentUser;

    // When user clicks on send otp button then this event will be fired
    on<PhoneSendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await auth.phoneVerify(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            add(PhoneOnOtpVerifiedEvent(credential));
          },
          codeSent: (String verificationId, int? resendToken) {
            add(PhoneOnOtpSendEvent(verificationId, resendToken));
          },
          verificationFailed: (FirebaseAuthException e) {
            add(PhoneOnErrorEvent(e.code));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // After receiving the otp, When user clicks on verify otp button then this event will be fired
    on<PhoneVerifyOtpEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.otpCode,
        );
        add(PhoneOnOtpVerifiedEvent(credential));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // When the firebase sends the code to the user's phone, this event will be fired
    on<PhoneOnOtpSendEvent>(
      (event, emit) => emit(
        AuthOtpSent(event.verificationId),
      ),
    );

    // When any error occurs while sending otp to the user's phone, this event will be fired
    on<PhoneOnErrorEvent>(
      (event, emit) => emit(
        AuthError(event.e),
      ),
    );

    // When the otp verification is successful, this event will be fired
    on<PhoneOnOtpVerifiedEvent>(
      (event, emit) async {
        try {
          await auth.signInWithCredential(event.credential);
          emit(AuthSuccess());
        } on FirebaseAuthException catch (e) {
          emit(AuthError(e.code));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      },
    );

    on<EmailSignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await auth.emailSignIn(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<EmailSignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await auth.emailSignUp(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      await auth.signOut();
      ZegoUIKitPrebuiltCallInvitationService().uninit();
      emit(UnAuthenticated());
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await auth.forgotPassword(event.email);
        emit(AuthForgotPasswordSent());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await user!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: event.email,
            password: event.currentPassword,
          ),
        );
        await user.updatePassword(event.newPassword);
        emit(AuthSuccess());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.code.toString()));
      }
    });
  }
}
