import 'package:dartz/dartz.dart';
import 'package:questions/features/quetions&auth/domain/repositories/auth/user_repostery.dart';

import '../../../../../core/error/failures.dart';

class AddUserUsecase {
  final UserRepository userRepository;

  AddUserUsecase(this.userRepository);

  Future<Either<Failure, Unit>> call() async {
    return await userRepository.addUser( );
  }
}