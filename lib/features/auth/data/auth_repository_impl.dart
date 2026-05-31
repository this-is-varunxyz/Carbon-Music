import 'package:carbon_music/core/errors/failures.dart';
import 'package:carbon_music/features/auth/domain/auth_repository.dart';
import 'package:carbon_music/features/auth/domain/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;
  

  Future<void> _ensureGoogleSignInInitialized() async {
    await dotenv.load(fileName: '.env');
    if (!_isGoogleSignInInitialized) {
      await _googleSignIn.initialize(serverClientId: dotenv.env['SERVER_CLIENT_ID']);
      _isGoogleSignInInitialized = true;
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      
      await _ensureGoogleSignInInitialized();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final clientAuth = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
      ]);

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: clientAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        final userEntity = UserEntity(
          id: user.uid,
          name: user.displayName ?? 'Unknown',
          email: user.email ?? '',
        );
        return Right(userEntity);
      } else {
        return Left(ServerFailure('Failed to retrieve user data.'));
      }
    } on GoogleSignInException catch (e) {
      if (e.code.name == 'canceled') {
        return Left(ServerFailure('Google sign in was canceled by user.'));
      }
      return Left(ServerFailure('Google Sign In Error: ${e.description ?? e.code.name}'));
    }catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Unable to signout,${e.toString()}'));
    }
  }
}
