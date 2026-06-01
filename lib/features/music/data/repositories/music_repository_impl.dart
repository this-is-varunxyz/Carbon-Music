import 'package:dartz/dartz.dart';
import 'package:carbon_music/core/errors/failures.dart';
import 'package:carbon_music/features/music/domain/entities/song_entity.dart';
import 'package:carbon_music/features/music/domain/repositories/music_repository.dart';
import 'package:carbon_music/features/music/data/datasources/youtube_remote_data_source.dart';

class MusicRepositoryImpl implements MusicRepository {
  final YouTubeRemoteDataSource remoteDataSource;

  MusicRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SongEntity>>> searchSongs(String query) async {
    try {
      final songs = await remoteDataSource.searchSongs(query);
      return Right(songs);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch songs: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getAudioStreamUrl(String videoId) async {
    try {
      final url = await remoteDataSource.getAudioStreamUrl(videoId);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure('Failed to extract audio stream: ${e.toString()}'));
    }
  }
}