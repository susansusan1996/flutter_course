import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../widgets/case_card.dart';
import 'chapter_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('偵探推理遊戲'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '案件牆',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allCases.length,
              itemBuilder: (context, index) {
                final caseItem = allCases[index];
                final isPlayable = caseItem.id == 1; // 只有第一章可以玩
                
                return CaseCard(
                  caseItem: caseItem,
                  isCompleted: false,
                  onTap: isPlayable ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChapterDetailPage(caseItem: caseItem),
                      ),
                    );
                  } : null, // 第二章不可點擊
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
