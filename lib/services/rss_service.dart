import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../models/video.dart';

class RssService {
  Future<List<Video>> fetchVideosFromRss(List<String> channelIds) async {
    List<Video> videos = [];
    for (String channelId in channelIds) {
      try {
        final url = Uri.parse('https://www.youtube.com/feeds/videos.xml?channel_id=$channelId');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          var document = xml.XmlDocument.parse(response.body);
          var entries = document.findAllElements('entry');
          for (var entry in entries) {
            var videoId = entry.findElements('yt:videoId').single.innerText;
            var title = entry.findElements('title').single.innerText;
            var author = entry.findElements('author').single.findElements('name').single.innerText;
            var thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
            videos.add(
              Video(
                id: videoId,
                title: title,
                thumbnailUrl: thumbnailUrl,
                channelTitle: author,
              ),
            );
          }
        }
      } catch (e) {
        print('Error fetching RSS feed for channel $channelId: $e');
      }
    }
    return videos;
  }
}
