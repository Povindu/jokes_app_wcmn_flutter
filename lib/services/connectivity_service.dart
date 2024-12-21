import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/joke.dart';

class ConnectivityService {
  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<List<Joke>> loadCachedJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJokes = prefs.getString('jokes');
    if (cachedJokes != null) {
      return (json.decode(cachedJokes) as List)
          .map((jokeJson) => Joke.fromJson(jokeJson))
          .toList();
    }
    return [];
  }

  static Future<void> saveJokesToCache(List<Joke> jokes) async {
    final jokesToCache = jokes.take(5).toList();
    final prefs = await SharedPreferences.getInstance();
    final jokesJson = json.encode(jokesToCache.map((joke) => joke.toJson()).toList());
    await prefs.setString('jokes', jokesJson);
  }
}