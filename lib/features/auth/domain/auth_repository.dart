import 'package:dartz/dartz.dart';
import 'package:carbon_music/features/auth/domain/user_entity.dart';
import 'package:carbon_music/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
}
