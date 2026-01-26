import 'package:flutter/material.dart';
import '../services/game_state_service.dart';
import '../widgets/clue_card.dart';
import 'clue_detail_page.dart';

class CluesPage extends StatelessWidget {
  final int chapterId;

  const CluesPage({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    final gameState = GameStateService();
    final allClues = gameState.getCluesForChapter(chapterId);
    final unlockedClues = allClues.where((c) => c.isUnlocked).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('線索庫'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: unlockedClues.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '尚未解鎖任何線索',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '訊問嫌疑人以獲取線索',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                          ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: unlockedClues.length,
                itemBuilder: (context, index) {
                  final clue = unlockedClues[index];
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
      ),
    );
  }
}
