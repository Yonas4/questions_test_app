import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../domain/entities/quetion.dart';
import '../../../domain/repositories/quetion_repository.dart';
import '../../datasources/auth/user_local_data_source.dart';
import '../../datasources/quetion_remote_data_source.dart';
import '../../models/quetion_model.dart';

typedef Future<Unit> UpdateOrAddQuetion();

class QuetionRepositoryImpl implements QuetionsRepository {
  final QuetionRemoteDataSource remoteDataSource;

  // final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  QuetionRepositoryImpl(
      {required this.remoteDataSource,
      // required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<Quetion>>> getAllQuetions() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuetions = await remoteDataSource.getAllQuetions();
        // localDataSource.cachePosts(remotePosts);
        return Right(remoteQuetions);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  // @override
  // Future<Either<Failure, Unit>> addQuetions(Quetion quetion) async {
  //   final QuetionModel quetionModel = QuetionModel(
  //       id: quetion.id,
  //       quetion: quetion.question,
  //       answer: quetion.answer,
  //       options: quetion.options);
  //
  //   return await _getMessage(() {
  //     return remoteDataSource.addQuetions(quetionModel);
  //   });
  // }

  // @override
  // Future<Either<Failure, Unit>> deleteQuetions(int postId) async {
  //   return await _getMessage(() {
  //     return remoteDataSource.deleteQuetions(postId);
  //   });
  // }

  // @override
  // Future<Either<Failure, Unit>> updateQuetions(Quetion quetion) async {
  //   final QuetionModel quetionModel = QuetionModel(
  //       id: quetion.id,
  //       quetion: quetion.question,
  //       answer: quetion.answer,
  //       options: quetion.options);
  //
  //   return await _getMessage(() {
  //     return remoteDataSource.updateQuetions(quetionModel);
  //   });
  // }

  Future<Either<Failure, Unit>> _getMessage(
      UpdateOrAddQuetion updateOrAddQuetion) async {
    if (await networkInfo.isConnected) {
      try {
        await updateOrAddQuetion();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
