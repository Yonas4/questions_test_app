import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:questions/features/quetions&auth/data/datasources/auth/user_local_data_source.dart';

import '../../../../../core/strings/messages.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/auth/user.dart';
import '../../../domain/usecases/auth/add_user.dart';
import '../../../domain/usecases/auth/update_user.dart';

part 'add_update_users_state.dart';

part 'add_update_users_event.dart';

class AddUpdateUserBloc extends Bloc<AddUpdateUsersEvent, AddUpdateUsersState> {
  final AddUserUsecase addUser;
  final UpdateUserUsecase updateUser;
  final UsersLocalDataSource localDataSource;

  AddUpdateUserBloc(
      {required this.localDataSource,
      required this.addUser,
      required this.updateUser})
      : super(AddUpdateUserInitial()) {
    on<AddUpdateUsersEvent>((event, emit) async {

      ///event UserSingIngEvent
      if (event is UserSingIngEvent) {
        // جلب بيانات المستخدمللتاكد من حالته
        final userData = await localDataSource.getCachedUser();

        // ينتقل الى تسجيل الدخول لانه غير مسجل الددخول
        if (userData.email == 'email') {
          emit(
            const MessageAddUpdateUserState(message: SINGOUT_MESSAGE),
          );

          //اذا كان المستخدم مسجل الدخول وقد اخذ الاختبار من قبل ينتقل الي شاشه المتصدرين
        } else if (userData.isTested == true) {
          emit(
            const MessageAddUpdateUserState(message: IS_TESTED_MESSAGE),
          );

          //اذا لم يتحقق احدد الشروط يعني انه مسجل الدخول لكن لم يختبر ينتقل الي شاشه الاجابه على الاسئله
        } else {
          emit(
            const MessageAddUpdateUserState(message: SINGING_MESSAGE),
          );
        }

        ///event AddUsersEvent
      } else if (event is AddUsersEvent) {
        emit(LoadingAddUpdateUsersState());
        //استدعاء useCase اضافه المستخدم
        final failureOrDoneMessage = await addUser();
        final userData = await localDataSource.getCachedUser();
        emit(
          _eitherDoneMessageOrErrorState(failureOrDoneMessage,
              //اذا كان المستخدم موجود من قبل في قاعده بيانات فايربيس وقد اخذ الاختبار ينتقل ال شاشه المتصدرين غير ذلك ينتقل الي شاشه الاجابه على الاسئله
              userData.isTested ? IS_TESTED_MESSAGE : ADD_SUCCESS_MESSAGE),
        );

        ///event AddUsersEvent
      } else if (event is UpdateUsersEvent) {
        emit(LoadingAddUpdateUsersState());
        //استدعاء useCase تحيث المستخدم

        final failureOrDoneMessage = await updateUser(event.users);
        //تحديث بيانات المستخدم
        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, UPDATE_SUCCESS_MESSAGE),
        );
      }
    });
  }
// دداله للتحكم في ارجاع ال events
  AddUpdateUsersState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddUpdateUsersState(
        message: _mapFailureToMessage(failure),
      ),
      (_) => MessageAddUpdateUserState(message: message),
    );
  }

  //دداله للتحكم في ارجاع الرسائل
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
