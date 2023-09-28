part of 'add_delete_update_quetion_bloc.dart';

abstract class AddUpdateQuetionState extends Equatable {
  const AddUpdateQuetionState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdatePostInitial extends AddUpdateQuetionState {}

class LoadingAddDeleteUpdatePostState extends AddUpdateQuetionState {}

class ErrorAddDeleteUpdatePostState extends AddUpdateQuetionState {
  final String message;

  ErrorAddDeleteUpdatePostState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageAddDeleteUpdatePostState extends AddUpdateQuetionState {
  final String message;

  MessageAddDeleteUpdatePostState({required this.message});

  @override
  List<Object> get props => [message];
}
