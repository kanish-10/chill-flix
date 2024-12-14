import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];

  void searchMovies(String query) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movies')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchMovies,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a movie',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? const Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = searchResults[index]['show'];
                      return ListTile(
                        leading: Image.network(
                          movie['image']?['medium'] ??
                              'https://via.placeholder.com/150/000000/FFFFFF?text=No+Image',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported,
                                  color: Colors.white),
                        ),
                        title: Text(movie['name'] ?? 'No Title',
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          movie['summary']?.replaceAll(RegExp('<[^>]*>'), '') ??
                              'No Summary',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailsScreen(movie: movie)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
