part of 'team_donations_cubit.dart';

@immutable
abstract class TeamDonationsState {}

class TeamDonationsInitial extends TeamDonationsState {}

class TeamDonationsLoading extends TeamDonationsState {}

class TeamModelSucceeded extends TeamDonationsState {}

class TeamModelFailed extends TeamDonationsState {}

//class TeamCollectedDonationsSucceeded extends TeamDonationsState {}

//class TeamCollectedDonationsFailed extends TeamDonationsState {}

//class TeamUnCollectedDonationsSucceeded extends TeamDonationsState {}

//class TeamUnCollectedDonationsFailed extends TeamDonationsState {}
