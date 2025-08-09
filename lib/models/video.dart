class Video {
  final String id;
  final String title;
  final String channel;
  final String channelId;
  final String thumbnail;
  final String duration;
  final String views;
  final String publishedAt;

  const Video({
    required this.id,
    required this.title,
    required this.channel,
    required this.channelId,
    required this.thumbnail,
    required this.duration,
    required this.views,
    required this.publishedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      channel: json['channel'] ?? '',
      channelId: json['channelId'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? '',
      views: json['views'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'channel': channel,
      'channelId': channelId,
      'thumbnail': thumbnail,
      'duration': duration,
      'views': views,
      'publishedAt': publishedAt,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Video && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

