import 'package:get_it/get_it.dart';
import 'package:carbon_music/features/auth/domain/auth_repository.dart';
import 'package:carbon_music/features/auth/data/auth_repository_impl.dart';

final sl = GetIt.instance; 

Future<void> init() async {

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
 
}