import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class DetailsScreen extends StatelessWidget {
  final Map movie;

  const DetailsScreen({super.key, required this.movie});

  Future<List<String>> fetchCast(int id) async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/shows/$id/cast'));
    if (response.statusCode == 200) {
      final List<dynamic> castData = json.decode(response.body);
      return castData.map<String>((cast) {
        return cast['person']['name'] ?? 'Unknown Actor';
      }).toList();
    } else {
      throw Exception('Failed to load cast data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = movie['name'] ?? 'No Title';
    final String summary =
        movie['summary']?.replaceAll(RegExp('<[^>]*>'), '') ?? 'No Summary';
    final String imageUrl = movie['image']?['original'] ??
        'https://via.placeholder.com/300/000000/FFFFFF?text=No+Image';
    final double rating = movie['rating']?['average']?.toDouble() ?? 0.0;
    final int id = movie['id'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        rating > 0 ? rating.toString() : 'No Rating',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<String>>(
                    future: fetchCast(id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                            color: Colors.redAccent);
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.grey),
                        );
                      } else {
                        final cast = snapshot.data ?? [];
                        return cast.isNotEmpty
                            ? Text(
                                cast.join(', '),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              )
                            : const Text(
                                'No cast information available',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
