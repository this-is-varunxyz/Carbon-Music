import 'package:dartz/dartz.dart';
import 'package:carbon_music/core/errors/failures.dart';
import 'package:carbon_music/features/music/domain/entities/song_entity.dart';

abstract class MusicRepository {
  Future<Either<Failure, List<SongEntity>>> searchSongs(String query);
  Future<Either<Failure, String>> getAudioStreamUrl(String videoId);
}