import 'package:bloc/bloc.dart';
import '../../../../../core/strings/messages.dart';
import '../../../domain/entities/quetion.dart';
import '../../../domain/usecases/quetions/add_quetion.dart';
import '../../../domain/usecases/quetions/update_quetion.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';

part 'add_update_quetion_event.dart';

part 'add_update_quetion_state.dart';

class AddDeleteUpdateQuetionBloc
    extends Bloc<AddUpdateQuetionEvent, AddUpdateQuetionState> {
  final AddQuetionUsecase addQuetion;

  // final DeletePostUsecase deletePost;
  final UpdateQuetionUsecase updateQuetion;

  AddDeleteUpdateQuetionBloc(
      {required this.addQuetion,
      // required this.deletePost,
      required this.updateQuetion})
      : super(AddDeleteUpdatePostInitial()) {
    on<AddUpdateQuetionEvent>((event, emit) async {
      if (event is AddQuetionEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await addQuetion(event.quetion);

        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, ADD_SUCCESS_MESSAGE),
        );
      } else if (event is UpdateQuetionEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await updateQuetion(event.quetion);

        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, UPDATE_SUCCESS_MESSAGE),
        );
      }
      /*else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await deletePost(event.postId);

        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, DELETE_SUCCESS_MESSAGE),
        );
      }*/
    });
  }

  AddUpdateQuetionState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdatePostState(
        message: _mapFailureToMessage(failure),
      ),
      (_) => MessageAddDeleteUpdatePostState(message: message),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
