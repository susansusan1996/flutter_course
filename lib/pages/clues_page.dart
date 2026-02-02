import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../widgets/clue_card.dart';
import 'clue_detail_page.dart';

class CluesPage extends StatelessWidget {
  final int chapterId;

  const CluesPage({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    // 找出這個章節的所有線索
    final clues = allClues
        .where((clue) => clue.chapterId == chapterId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('線索庫'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: clues.length,
        itemBuilder: (context, index) {
          final clue = clues[index];
          return ClueCard(
            clue: clue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClueDetailPage(clue: clue),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
