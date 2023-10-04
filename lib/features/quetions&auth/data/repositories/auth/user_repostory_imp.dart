import 'package:dartz/dartz.dart';
import 'package:questions/features/quetions&auth/data/datasources/auth/user_local_data_source.dart';
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
  final UsersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<UserData>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUsers = await remoteDataSource.getAllUsers();
        localDataSource.cacheUsers(remoteUsers);
        return Right(remoteUsers);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUsers = await localDataSource.getCachedUsers();
        return Right(localUsers);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addUser() async {
    return await _getMessage(() {
      return remoteDataSource.addUsers();
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
        isTested: user.isTested,
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
