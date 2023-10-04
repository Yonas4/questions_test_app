part of 'add_update_users_bloc.dart';

abstract class AddUpdateUsersEvent extends Equatable {
  const AddUpdateUsersEvent();

  @override
  List<Object> get props => [];
}

class AddUsersEvent extends AddUpdateUsersEvent {}

class UpdateUsersEvent extends AddUpdateUsersEvent {
  final UserData users;

  const UpdateUsersEvent({required this.users});

  @override
  List<Object> get props => [users];
}

class UserSingIngEvent extends AddUpdateUsersEvent {}
