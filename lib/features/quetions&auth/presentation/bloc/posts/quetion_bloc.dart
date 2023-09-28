import 'package:bloc/bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/quetion.dart';
import '../../../domain/usecases/quetions/get_all_quetion.dart';

part 'quetion_event.dart';
part 'quetion_state.dart';

class QuetionBloc extends Bloc<QuetionEvent, QuetionState> {
  final GetAllQuetionUsecase getAllQuetion;
  QuetionBloc({
    required this.getAllQuetion,
  }) : super(QuetionInitial()) {
    on<QuetionEvent>((event, emit) async {
      if (event is GetAllQuetionEvent) {
        emit(LoadingQuetionState());

        final failureOrQuetion = await getAllQuetion();
        emit(_mapFailureOrQuetionToState(failureOrQuetion));
      } else if (event is RefreshQuetionEvent) {
        emit(LoadingQuetionState());

        final failureOrQuetions = await getAllQuetion();
        emit(_mapFailureOrQuetionToState(failureOrQuetions));
      }
    });
  }

  QuetionState _mapFailureOrQuetionToState(Either<Failure, List<Quetion>> either) {
    return either.fold(
      (failure) => ErrorQuetionState(message: _mapFailureToMessage(failure)),
      (quetion) => LoadedQuetionState(
        quetion: quetion,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
