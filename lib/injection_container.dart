import 'package:get_it/get_it.dart';

// Auth Imports
import 'package:carbon_music/features/auth/domain/auth_repository.dart';
import 'package:carbon_music/features/auth/data/auth_repository_impl.dart';

// Music Imports
import 'package:carbon_music/features/music/data/datasources/youtube_remote_data_source.dart';
import 'package:carbon_music/features/music/domain/repositories/music_repository.dart';
import 'package:carbon_music/features/music/data/repositories/music_repository_impl.dart';

final sl = GetIt.instance; 

Future<void> init() async {
 //auth
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

 
  sl.registerLazySingleton<YouTubeRemoteDataSource>(
    () => YoutubeRemoteDataSourceImp(),
  );

  sl.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryImpl(remoteDataSource: sl()),
  );
}