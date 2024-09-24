import 'package:http/http.dart' as http;
import 'package:quadbtechapp/screen/model/Post.dart';

class RemoteServices {
  Future<List<Post>?> getPosts({String query = 'all'}) async {
    var client = http.Client();
    var uri = Uri.parse('https://api.tvmaze.com/search/shows?q=$query'); // Use query in the API
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return postFromJson(json);
    }
    return null;
  }
}
