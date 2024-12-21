import 'package:flutter/material.dart';
import '../models/joke.dart';

class JokeListItem extends StatelessWidget {
  final Joke joke;

  const JokeListItem({
    super.key,
    required this.joke,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          joke.type == 'single' ? joke.joke ?? '' : joke.setup ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: joke.type == 'twopart'
            ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            joke.delivery ?? '',
            style: const TextStyle(fontSize: 14),
          ),
        )
            : null,
        leading: const Icon(Icons.tag_faces, size: 30),
      ),
    );
  }
}