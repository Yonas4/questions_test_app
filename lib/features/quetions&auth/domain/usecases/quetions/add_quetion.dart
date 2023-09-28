import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/quetion.dart';
import '../../repositories/quetion_repository.dart';

class AddQuetionUsecase {
  final QuetionsRepository repository;

  AddQuetionUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Quetion quetion) async {
    return await repository.addQuetions(quetion);
  }
}
