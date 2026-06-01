import 'package:carbon_music/features/music/domain/entities/song_entity.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class YouTubeRemoteDataSource {
  Future<List<SongEntity>> searchSongs(String query);
  Future<String> getAudioStreamUrl(String videoId);
}

class YoutubeRemoteDataSourceImp implements YouTubeRemoteDataSource {
  final YoutubeExplode yt = YoutubeExplode();
  @override
  Future<List<SongEntity>> searchSongs(String query) async {
    final searchResults = await yt.search.search(query);
    final results = searchResults.take(15).toList();
    return results.map((video) {
      return SongEntity(
        id: video.id.value,
        title: video.title,
        artist: video.author,
        thumbnailUrl: video.thumbnails.highResUrl,
        duration: video.duration,
      );
    }).toList();
  }

  @override
  Future<String> getAudioStreamUrl(String videoId) async {
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final audioStreamInfo = manifest.audioOnly.withHighestBitrate();
    return audioStreamInfo.url.toString();
  }
}
