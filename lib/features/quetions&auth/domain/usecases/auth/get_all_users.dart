import 'package:dartz/dartz.dart';
import 'package:questions/features/quetions&auth/domain/entities/auth/user.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/auth/user_repostery.dart';

class GetAllUserUsecase {
  final UserRepository userRepository;

  GetAllUserUsecase(this.userRepository);

  Future<Either<Failure, List<UserData>>> call() async {
    return await userRepository.getAllUsers();
  }
}