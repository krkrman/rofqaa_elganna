part of 'add_donation_cubit.dart';

@immutable
abstract class AddDonationState {}

class AddDonationInitial extends AddDonationState {}

class AddDonationSucceeded extends AddDonationState {}

class AddDonationFailed extends AddDonationState {
  final String error;

  AddDonationFailed({
    required this.error,
  });
}

class AddDonationHasNoInternetConnection extends AddDonationState {}

class AddDonationLoading extends AddDonationState {}