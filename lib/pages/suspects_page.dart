import 'package:flutter/material.dart';
import '../services/game_state_service.dart';
import '../widgets/suspect_card.dart';
import 'interrogation_page.dart';

class SuspectsPage extends StatelessWidget {
  const SuspectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameStateService();
    final suspects = gameState.suspects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('嫌疑人板'),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: suspects.length,
          itemBuilder: (context, index) {
            final suspect = suspects[index];
            final interrogationCount = gameState.getInterrogationCount(suspect.id);
            final canInterrogate = gameState.canInterrogate(suspect.id);

            return SuspectCard(
              suspect: suspect,
              interrogationCount: interrogationCount,
              canInterrogate: canInterrogate,
              onTap: () {
                if (!canInterrogate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已達到訊問次數上限（3次）'),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InterrogationPage(suspect: suspect),
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
