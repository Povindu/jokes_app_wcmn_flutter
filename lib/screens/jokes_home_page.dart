import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/joke.dart';
import '../services/connectivity_service.dart';
import '../widgets/joke_list_item.dart';

class JokesHomePage extends StatefulWidget {
  const JokesHomePage({super.key});

  @override
  State<JokesHomePage> createState() => _JokesHomePageState();
}

class _JokesHomePageState extends State<JokesHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Joke> jokes = [];
  List<Joke> filteredJokes = [];
  bool isLoading = false;
  String error = '';
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    checkConnectivityAndLoadJokes();
  }

  Future<void> checkConnectivityAndLoadJokes() async {
    bool hasConnection = await ConnectivityService.checkInternetConnection();
    if (hasConnection) {
      await fetchJokes();
    } else {
      final cachedJokes = await ConnectivityService.loadCachedJokes();
      setState(() {
        jokes = cachedJokes;
        filteredJokes = List.from(jokes);
        isOffline = true;
      });
    }
  }

  Future<void> fetchJokes() async {
    setState(() {
      isLoading = true;
      error = '';
      isOffline = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://v2.jokeapi.dev/joke/Any?amount=10'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jokesList = (data['jokes'] as List)
            .map((jokeJson) => Joke.fromJson(jokeJson))
            .toList();

        setState(() {
          jokes = jokesList;
          filteredJokes = List.from(jokes);
          isLoading = false;
        });

        await ConnectivityService.saveJokesToCache(jokes);
      } else {
        setState(() {
          error = 'Failed to load jokes. Please try again later.';
          isLoading = false;
        });
        final cachedJokes = await ConnectivityService.loadCachedJokes();
        setState(() {
          jokes = cachedJokes;
          filteredJokes = List.from(jokes);
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
      final cachedJokes = await ConnectivityService.loadCachedJokes();
      setState(() {
        jokes = cachedJokes;
        filteredJokes = List.from(jokes);
      });
    }
  }

  void _filterJokes(String query) {
    setState(() {
      filteredJokes = jokes
          .where((joke) =>
          joke.fullJoke.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jokes App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (isOffline)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.cloud_off, color: Colors.grey),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: checkConnectivityAndLoadJokes,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isOffline)
            Container(
              color: Colors.amber[100],
              padding: const EdgeInsets.all(8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Offline mode - Showing cached jokes'),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Jokes',
                hintText: 'Enter keywords...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterJokes,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error.isNotEmpty && !isOffline
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: checkConnectivityAndLoadJokes,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : filteredJokes.isEmpty
                ? const Center(
              child: Text(
                'No jokes found!',
                style: TextStyle(fontSize: 18),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredJokes.length,
              itemBuilder: (context, index) {
                return JokeListItem(joke: filteredJokes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}