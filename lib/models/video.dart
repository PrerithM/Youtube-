class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String channel;
  final String channelId;
  final String thumbnail;
  final String duration;
  final String views;
  final String publishedAt;

  const Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelTitle,
    this.channel = '',
    this.channelId = '',
    this.thumbnail = '',
    this.duration = '',
    this.views = '',
    this.publishedAt = '',
  });
}

