class SongEntity {

  SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    this.duration,
  });
  final String id;
    final String title;
  final String artist;
  final String thumbnailUrl;
  final Duration? duration;
}