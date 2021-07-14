part of 'team_members_cubit.dart';

@immutable
abstract class TeamMembersState {}

class TeamMembersInitial extends TeamMembersState {}

class TeamMembersLoading extends TeamMembersState {}

class TeamMembersSucceeded extends TeamMembersState {}

class TeamMembersFailed extends TeamMembersState {
  final String error;

  TeamMembersFailed({
    required this.error,
  });
}