class Channel {
  final String id;
  final String name;
  final String url;

  const Channel({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Channel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

