import 'package:flutter/material.dart';

class PassTile extends StatelessWidget {
  final String title;
  final String content;

  const PassTile({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              softWrap: false,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 18, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Adjust the height as needed
            Text(
              content,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(
                fontSize: 14, // Adjust the font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
