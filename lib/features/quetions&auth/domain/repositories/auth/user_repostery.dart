import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/auth/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserData>>> getAllUsers();

  Future<Either<Failure, Unit>> updateUser(UserData userData);

  Future<Either<Failure, Unit>> addUser( );
}
