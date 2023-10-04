import 'package:firebase_core/firebase_core.dart';
import 'package:questions/notifications.dart';

import 'core/network/network_info.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/quetions&auth/data/datasources/quetion_remote_data_source.dart';
import 'features/quetions&auth/data/repositories/question/quetion_repository_impl.dart';
import 'features/quetions&auth/domain/repositories/quetion_repository.dart';
import 'features/quetions&auth/domain/usecases/quetions/add_quetion.dart';
import 'features/quetions&auth/domain/usecases/quetions/get_all_quetion.dart';
import 'features/quetions&auth/domain/usecases/quetions/update_quetion.dart';
import 'features/quetions&auth/presentation/bloc/add_delete_update_post/add_delete_update_quetion_bloc.dart';
import 'features/quetions&auth/presentation/bloc/posts/quetion_bloc.dart';
import 'firebase_options.dart';

final sl = GetIt.instance;


///////
Future<void> init() async {
//! Features - posts
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Bloc

  sl.registerFactory(() => QuetionBloc(getAllQuetion: sl()));
  sl.registerFactory(
      () => AddDeleteUpdateQuetionBloc(addQuetion: sl(), updateQuetion: sl()));

// Usecases

  sl.registerLazySingleton(() => GetAllQuetionUsecase(sl()));
  sl.registerLazySingleton(() => AddQuetionUsecase(sl()));
  // sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => UpdateQuetionUsecase(sl()));

// Repository

  sl.registerLazySingleton<QuetionsRepository>(
      () => QuetionRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

// Datasource's

  sl.registerLazySingleton<QuetionRemoteDataSource>(
      () => QuetionRemoteDataSourceImpl(client: sl()));
  // sl.registerLazySingleton<PostLocalDataSource>(
  //     () => PostLocalDataSourceImpl(sharedPreferences: sl()));

//! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());

// Firebase
//   Firebase

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // sl.registerSingleton(() => );

  //Notifications
  sl.registerSingleton(() => Notifications().init());
}
