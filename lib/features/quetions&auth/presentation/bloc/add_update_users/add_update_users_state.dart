part of 'add_update_users_bloc.dart';

abstract class AddUpdateUsersState extends Equatable {
  const AddUpdateUsersState();

  @override
  List<Object> get props => [];
}

class AddUpdateUserInitial extends AddUpdateUsersState {}

class LoadingAddUpdateUsersState extends AddUpdateUsersState {}

class ErrorAddUpdateUsersState extends AddUpdateUsersState {
  final String message;

  const ErrorAddUpdateUsersState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddUpdateUserState extends AddUpdateUsersState {
  final String message;

  const MessageAddUpdateUserState({required this.message});

  @override
  List<Object> get props => [message];
}
