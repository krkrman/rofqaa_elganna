part of 'add_volunteer_cubit.dart';

@immutable
abstract class AddVolunteerState {}

class AddVolunteerInitial extends AddVolunteerState {}

class AddVolunteerSucceeded extends AddVolunteerState {}

class AddVolunteerFailed extends AddVolunteerState {
  final String error;

  AddVolunteerFailed({
    required this.error,
  });
}

class AddVolunteerHasNoInternetConnection extends AddVolunteerState {}

class AddVolunteerLoading extends AddVolunteerState {}

class AddVolunteerDoesNotExist extends AddVolunteerState {}

class VolunteerIsAlreadyExistInTeam extends AddVolunteerState {}
