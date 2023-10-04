import '../entities/quetion.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class QuetionsRepository {
  Future<Either<Failure, List<Quetion>>> getAllQuetions();
}
