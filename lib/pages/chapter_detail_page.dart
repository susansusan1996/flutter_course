import 'package:flutter/material.dart';
import '../models/case_model.dart';
import 'clues_page.dart';
import 'suspects_page.dart';
import 'deduction_page.dart';

class ChapterDetailPage extends StatelessWidget {
  final Case caseItem;

  const ChapterDetailPage({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(caseItem.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Case description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '案件摘要',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(caseItem.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Navigation buttons
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('線索庫'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CluesPage(chapterId: caseItem.id),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('嫌疑人板'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuspectsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: const Text('推理提交'),
              trailing: const Icon(Icons.arrow_forward_ios),
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
    );
  }
}
