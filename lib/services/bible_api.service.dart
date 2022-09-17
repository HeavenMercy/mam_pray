import 'package:mam_pray/services/bible_api_response.model.dart';

import 'package:http/http.dart' as http;

class BibleAPIService {
  static BibleAPIService? _instance;

  static BibleAPIService get instance {
    _instance ??= BibleAPIService();

    return _instance!;
  }

  Future<BibleAPIResponse?> getPassageInfo(
      String book, int chapter, int verseStart, int verseEnd) async {
    if (verseStart > verseEnd) {
      var tmp = verseStart;
      verseEnd = verseStart;
      verseStart = tmp;
    }

    if (verseStart == verseEnd) verseEnd = 0;

    var verseEndStr = verseEnd > 0 ? '-${verseEnd.toString()}' : '';
    var url =
        'https://bible-api.com/${book.toLowerCase()}+${chapter.toString()}:${verseStart.toString()}$verseEndStr';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return null;

    return BibleAPIResponse.fromRawJson(response.body);
  }
}
