import 'package:dartz/dartz.dart';
import 'package:questions/features/quetions&auth/data/models/user_model.dart';
import 'package:questions/features/quetions&auth/domain/entities/auth/user.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/repositories/auth/user_repostery.dart';
import '../../datasources/auth/user_remote_da_sou.dart';

typedef Future<Unit> UpdateOrAddUser();

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<UserData>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getAllUsers();
        // localDataSource.cachePosts(remotePosts);
        return Right(remoteUsers);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
      // try {
      //   // final localPosts = await localDataSource.getCachedPosts();
      //   return Right(localPosts);
      // } on EmptyCacheException {
      //   return Left(EmptyCacheFailure());
      // }
    }
  }

  @override
  Future<Either<Failure, Unit>> addUser(UserData user) async {
    final UserDataModel userDataModel = UserDataModel(
        id: user.id,
        name: user.name,
        email: user.email,
        photourl: user.photourl,
        rate: user.rate,
        fcmtoken: user.fcmtoken,
        addtime: user.addtime);

    return await _getMessage(() {
      return remoteDataSource.addUsers(userDataModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> updateUser(UserData user) async {
    final UserDataModel userDataModel = UserDataModel(
        id: user.id,
        name: user.name,
        email: user.email,
        photourl: user.photourl,
        rate: user.rate,
        fcmtoken: user.fcmtoken,
        addtime: user.addtime);

    return await _getMessage(() {
      return remoteDataSource.updateUsers(userDataModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      UpdateOrAddUser updateOrAddUser) async {
    if (await networkInfo.isConnected) {
      try {
        await updateOrAddUser();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
