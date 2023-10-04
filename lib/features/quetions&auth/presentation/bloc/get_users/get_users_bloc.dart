import 'package:bloc/bloc.dart';
import 'package:questions/features/quetions&auth/domain/usecases/auth/get_all_users.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/auth/user.dart';

part 'get_users_event.dart';

part 'get_users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetAllUserUsecase getAllUsers;

  UsersBloc({
    required this.getAllUsers,
  }) : super(UsersInitial()) {
    on<UsersEvent>((event, emit) async {
      //event GetAllUsersEvent
      if (event is GetAllUsersEvent) {
        // emeit  شاشه التحميل
        emit(LoadingUsersState());

        //استدعاء useCase جلب المستخدمين
        final failureOrUser = await getAllUsers();
        emit(_mapFailureOrUserToState(failureOrUser));

        //عندد السحب للتحديث
      }else if (event is RefreshUsersEvent) {
        emit(LoadingUsersState());

        final failureOrUsers = await getAllUsers();
        emit(_mapFailureOrUserToState(failureOrUsers));
      }
    });
  }

  UsersState _mapFailureOrUserToState(Either<Failure, List<UserData>> either) {
    return either.fold(
      (failure) => ErrorUsersState(message: _mapFailureToMessage(failure)),
      (user) => LoadedUsersState(
        userData: user,
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
