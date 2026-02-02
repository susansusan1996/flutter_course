import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../widgets/suspect_card.dart';
import 'interrogation_page.dart';

class SuspectsPage extends StatelessWidget {
  const SuspectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('嫌疑人板'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allSuspects.length,
        itemBuilder: (context, index) {
          final suspect = allSuspects[index];

          return SuspectCard(
            suspect: suspect,
            interrogationCount: 0, // 簡化：不追蹤次數
            canInterrogate: true,  // 簡化：總是可以訊問
            onTap: () {
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
    );
  }
}
