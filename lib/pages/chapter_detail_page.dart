import 'package:flutter/material.dart';
import '../models/case_model.dart';
import '../services/game_state_service.dart';
import 'clues_page.dart';
import 'suspects_page.dart';
import 'deduction_page.dart';

class ChapterDetailPage extends StatelessWidget {
  final Case caseItem;

  const ChapterDetailPage({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final gameState = GameStateService();
    final unlockedClues = gameState.getUnlockedCluesForChapter(caseItem.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(caseItem.title),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Case description card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '案件摘要',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        caseItem.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '已解鎖線索：${unlockedClues.length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Navigation buttons
              _buildNavigationButton(
                context,
                icon: Icons.search,
                title: '線索庫',
                subtitle: '查看已解鎖的線索',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CluesPage(chapterId: caseItem.id),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              
              _buildNavigationButton(
                context,
                icon: Icons.people,
                title: '嫌疑人板',
                subtitle: '訊問嫌疑人以獲取線索',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuspectsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              
              _buildNavigationButton(
                context,
                icon: Icons.gavel,
                title: '推理提交',
                subtitle: '選出兇手並揭開真相',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeductionPage(caseItem: caseItem),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
