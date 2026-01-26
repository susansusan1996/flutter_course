import 'package:flutter/material.dart';
import '../services/game_state_service.dart';
import '../widgets/case_card.dart';
import 'chapter_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameStateService();
    final cases = gameState.cases;

    return Scaffold(
      appBar: AppBar(
        title: const Text('偵探推理遊戲'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('重置進度'),
                  content: const Text('確定要重置所有遊戲進度嗎？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('確定'),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true && context.mounted) {
                await gameState.resetProgress();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('進度已重置')),
                );
              }
            },
            tooltip: '重置進度',
          ),
        ],
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '案件牆',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  final caseItem = cases[index];
                  final isCompleted = gameState.completedChapters.contains(caseItem.id);
                  
                  return CaseCard(
                    caseItem: caseItem,
                    isCompleted: isCompleted,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterDetailPage(caseItem: caseItem),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
