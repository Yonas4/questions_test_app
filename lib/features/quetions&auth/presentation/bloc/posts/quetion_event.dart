part of 'quetion_bloc.dart';

abstract class QuetionEvent extends Equatable {
  const QuetionEvent();

  @override
  List<Object> get props => [];
}

class GetAllQuetionEvent extends QuetionEvent {}

class RefreshQuetionEvent extends QuetionEvent {}
