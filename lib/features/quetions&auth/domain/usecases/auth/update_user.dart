
import 'package:dartz/dartz.dart';
import 'package:questions/features/quetions&auth/domain/entities/auth/user.dart';

import '../../../../../core/error/failures.dart';
import '../../repositories/auth/user_repostery.dart';

class UpdateUserUsecase {
  final UserRepository userRepository;

  UpdateUserUsecase(this.userRepository);

  Future<Either<Failure, Unit>> call(UserData User) async {
    return await userRepository.updateUser(User);
  }
}