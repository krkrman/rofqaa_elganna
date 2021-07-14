part of 'create_team_cubit.dart';

@immutable
abstract class CreateTeamState {}

class CreateTeamInitial extends CreateTeamState {}

class CreateTeamSucceeded extends CreateTeamState {}

class CreateTeamFailed extends CreateTeamState {
  final String error;

  CreateTeamFailed({
    required this.error,
  });
}

class CreateTeamHasNoInternetConnection extends CreateTeamState {}

class CreateTeamLoading extends CreateTeamState {}

class TeamLeaderDoesNotExist extends CreateTeamState {}