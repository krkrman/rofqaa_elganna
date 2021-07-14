part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthVerificationCompleted extends PhoneAuthState {}

class PhoneAuthVerificationFailed extends PhoneAuthState {
  final String? error;

  PhoneAuthVerificationFailed({
    required this.error,
  });
}

class PhoneAuthCodeSent extends PhoneAuthState {
  final String? verificationId;

  PhoneAuthCodeSent({
    required this.verificationId,
  });
}

class PhoneAuthInvalidPhoneNumber extends PhoneAuthState {}

class PhoneAuthCodeAutoRetrievalTimeout extends PhoneAuthState {}

class PhoneAuthEmailCreatedSuccessfully extends PhoneAuthState {}

class PhoneAuthEmailCreatedFailed extends PhoneAuthState {
  final String? error;

  PhoneAuthEmailCreatedFailed({
    required this.error,
  });
}
