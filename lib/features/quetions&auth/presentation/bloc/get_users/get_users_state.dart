part of 'get_users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class LoadingUsersState extends UsersState {}

class LoadedUsersState extends UsersState {
  final List<UserData> userData;

  const LoadedUsersState({required this.userData});

  @override
  List<Object> get props => [userData];
}

class ErrorUsersState extends UsersState {
  final String message;

  const ErrorUsersState({required this.message});

  @override
  List<Object> get props => [message];
}
