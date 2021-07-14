part of 'my_donations_cubit.dart';

@immutable
abstract class MyDonationsState {}

class MyDonationsInitial extends MyDonationsState {}

class MyDonationsLoading extends MyDonationsState {}

class MyDonationsSucceeded extends MyDonationsState {}

class MyDonationsFailed extends MyDonationsState {}
