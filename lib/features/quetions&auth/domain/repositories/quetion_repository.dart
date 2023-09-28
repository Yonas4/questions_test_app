import '../entities/quetion.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class QuetionsRepository {
  Future<Either<Failure, List<Quetion>>> getAllQuetions();
  // Future<Either<Failure, Unit>> deleteQuetions(int id);
  Future<Either<Failure, Unit>> updateQuetions(Quetion post);
  Future<Either<Failure, Unit>> addQuetions(Quetion post);
}
