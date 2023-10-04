import '../../repositories/quetion_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/quetion.dart';

class GetAllQuetionUsecase {
  final QuetionsRepository repository;

  GetAllQuetionUsecase(this.repository);

  Future<Either<Failure, List<Quetion>>> call() async {
    return await repository.getAllQuetions();
  }
}
