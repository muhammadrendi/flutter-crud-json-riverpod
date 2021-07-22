import 'dart:convert';
import 'package:riverpod_crud/model/post_model.dart';
import 'package:http/http.dart' as http;

class DataService {
  static const urlApi = 'https://jsonplaceholder.typicode.com';

  Future<List<PostModel>> readPost() async {
    var url = Uri.parse(urlApi + '/posts');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      return jsonResponse.map((data) => PostModel.fromJson(data)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed Load Data');
    }
  }

  Future createPost(PostModel posts) async {
    var url = Uri.parse(urlApi + '/posts');

    var response = await http.post(
      url,
      body: jsonEncode(posts),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    if (response.body.isNotEmpty) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      // throw Exception('Failed Load Data');
      return false;
    }
  }

  Future editPost(PostModel posts) async {
    var url = Uri.parse(urlApi + '/posts' + '/${posts.id}');

    var response = await http.put(
      url,
      body: jsonEncode(posts),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 404) {
      return false;
    } else {
      return true;
    }
  }

  Future deletePost(id) async {
    var url = Uri.parse(urlApi + '/posts' + '/${id}');

    var response = await http.delete(url);
    if (response.statusCode == 404) {
      return false;
    } else {
      return true;
    }
  }
}
