import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:questions/features/quetions&auth/data/datasources/auth/user_local_data_source.dart';
import 'package:questions/features/quetions&auth/data/datasources/auth/user_remote_da_sou.dart';
import 'package:questions/features/quetions&auth/data/repositories/auth/user_repostory_imp.dart';
import 'package:questions/features/quetions&auth/domain/repositories/auth/user_repostery.dart';
import 'package:questions/features/quetions&auth/domain/usecases/auth/add_user.dart';
import 'package:questions/features/quetions&auth/domain/usecases/auth/get_all_users.dart';
import 'package:questions/features/quetions&auth/domain/usecases/auth/update_user.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/add_update_users/add_update_users_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/get_quesions/quetion_bloc.dart';
import 'package:questions/features/quetions&auth/presentation/bloc/get_users/get_users_bloc.dart';
import 'package:questions/notifications.dart';

import 'core/network/network_info.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/quetions&auth/data/datasources/quetion_remote_data_source.dart';
import 'features/quetions&auth/data/repositories/question/quetion_repository_impl.dart';
import 'features/quetions&auth/domain/repositories/quetion_repository.dart';
import 'features/quetions&auth/domain/usecases/quetions/get_all_quetion.dart';
import 'firebase_options.dart';

final sl = GetIt.instance;
//حقن التبعيات باستخدام مكتبه get_it
Future<void> init() async {
//! Features
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Notifications
  Notifications().init();
// Bloc

  sl.registerFactory(() => QuetionBloc(getAllQuetion: sl()));
  sl.registerFactory(() => UsersBloc(getAllUsers: sl()));

  sl.registerFactory(() => AddUpdateUserBloc(
      addUser: sl(), updateUser: sl(), localDataSource: sl()));

// Usecases

  sl.registerLazySingleton(() => GetAllQuetionUsecase(sl()));
  sl.registerLazySingleton(() => GetAllUserUsecase(sl()));
  sl.registerLazySingleton(() => AddUserUsecase(sl()));
  sl.registerLazySingleton(() => UpdateUserUsecase(sl()));

// Repository

  sl.registerLazySingleton<QuetionsRepository>(
      () => QuetionRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));

// Datasource's

  sl.registerLazySingleton<QuetionRemoteDataSource>(
      () => QuetionRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(localDataSource: sl()));
  sl.registerLazySingleton<UsersLocalDataSource>(
      () => UsersLocalDataSourceImpl(sharedPreferences: sl()));

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
