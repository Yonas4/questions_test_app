part of 'add_delete_update_quetion_bloc.dart';

abstract class AddUpdateQuetionEvent extends Equatable {
  const AddUpdateQuetionEvent();

  @override
  List<Object> get props => [];
}

class AddQuetionEvent extends AddUpdateQuetionEvent {
  final Quetion quetion;

  AddQuetionEvent({required this.quetion});

  @override
  List<Object> get props => [quetion];
}

class UpdateQuetionEvent extends AddUpdateQuetionEvent {
  final Quetion quetion;

  UpdateQuetionEvent({required this.quetion});

  @override
  List<Object> get props => [quetion];
}

// class DeleteQuetionEvent extends AddUpdateQuetionEvent {
//   final int quetionId;
//
//   DeleteQuetionEvent({required this.quetionId});
//
//   @override
//   List<Object> get props => [quetionId];
// }
