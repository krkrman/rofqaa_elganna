part of 'teams_donations_for_manager_cubit.dart';

@immutable
abstract class TeamsDonationsForManagerState {}

class TeamsDonationsForManagerInitial extends TeamsDonationsForManagerState {}


class TeamsDonationsForManagerLoading extends TeamsDonationsForManagerState {}

class TeamsDonationsForManagerSucceeded extends TeamsDonationsForManagerState {}

class TeamsDonationsForManagerFailed extends TeamsDonationsForManagerState {}