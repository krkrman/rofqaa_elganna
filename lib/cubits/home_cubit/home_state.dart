part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeBottomNavigationBarChanged extends HomeState {}

class HomeSignedOut extends HomeState {}

class HomeQRCodeScanned extends HomeState {}

class HomeGetDonationLoading extends HomeState {}

class HomeGetDonationSucceeded extends HomeState {
  final DonationModel donationModel;

  HomeGetDonationSucceeded({
    required this.donationModel,
  });
}

class HomeGetDonationFailed extends HomeState {
  final String error;

  HomeGetDonationFailed({
    required this.error,
  });
}

class HomeDonationChangedToCollectedSucceeded extends HomeState {}

class HomeDonationChangedToCollectedFailed extends HomeState {}

class AddDonationHasNoInternetConnection extends HomeState {}

class HomeDonationAddedSuccessfully extends HomeState {}

class HomeDonationFailed extends HomeState {
  final String error;

  HomeDonationFailed({
    required this.error,
  });
}

class HomeDonationDeletedSuccessfully extends HomeState {}

class HomeDonationDeletedFailed extends HomeState {}
