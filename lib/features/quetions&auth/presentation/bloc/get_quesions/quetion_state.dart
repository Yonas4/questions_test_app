part of 'quetion_bloc.dart';

abstract class QuetionState extends Equatable {
  const QuetionState();

  @override
  List<Object> get props => [];
}

class QuetionInitial extends QuetionState {}

class LoadingQuetionState extends QuetionState {}

class LoadedQuetionState extends QuetionState {
  final List<Quetion> quetion;

  LoadedQuetionState({required this.quetion});

  @override
  List<Object> get props => [quetion];
}

class ErrorQuetionState extends QuetionState {
  final String message;

  ErrorQuetionState({required this.message});

  @override
  List<Object> get props => [message];
}
