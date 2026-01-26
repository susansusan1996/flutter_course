import 'package:flutter/material.dart';
import '../models/case_model.dart';
import '../models/suspect_model.dart';
import '../services/game_state_service.dart';

class DeductionPage extends StatefulWidget {
  final Case caseItem;

  const DeductionPage({super.key, required this.caseItem});

  @override
  State<DeductionPage> createState() => _DeductionPageState();
}

class _DeductionPageState extends State<DeductionPage> {
  final gameState = GameStateService();
  Suspect? selectedCulprit;
  String? selectedMotive;
  
  final List<String> motives = [
    '金錢糾紛',
    '感情糾紛',
    '商業競爭',
    '個人恩怨',
    '意外事故',
  ];

  void _submitDeduction() {
    if (selectedCulprit == null || selectedMotive == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請選擇兇手和動機'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check if player has enough clues
    final unlockedClues = gameState.getUnlockedCluesForChapter(widget.caseItem.id);
    
    String ending;
    String endingTitle;
    Color endingColor;
    
    if (unlockedClues.length >= 3) {
      // Good ending - enough clues
      if (selectedCulprit!.id == 'suspect_1' && selectedMotive == '商業競爭') {
        // Perfect ending
        ending = '恭喜！你成功破案了！\n\n'
            '${selectedCulprit!.name}確實是兇手，動機正是${selectedMotive}。'
            '你收集了足夠的證據，成功將兇手繩之以法。';
        endingTitle = '完美結局';
        endingColor = Colors.green;
        gameState.completeChapter(widget.caseItem.id);
      } else {
        // Good ending but wrong culprit
        ending = '你的推理很有邏輯，但似乎還有些細節需要再確認。\n\n'
            '雖然你收集了足夠的證據，但真正的兇手另有其人。'
            '建議重新檢視線索，或許會有新的發現。';
        endingTitle = '接近真相';
        endingColor = Colors.blue;
      }
    } else {
      // Bad ending - not enough clues
      ending = '證據不足！\n\n'
          '你只解鎖了 ${unlockedClues.length} 個線索，這不足以支持你的推理。'
          '建議繼續訊問嫌疑人，收集更多證據後再做推理。';
      endingTitle = '證據不足';
      endingColor = Colors.red;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              unlockedClues.length >= 3 && selectedCulprit!.id == 'suspect_1' 
                  ? Icons.check_circle 
                  : Icons.info,
              color: endingColor,
            ),
            const SizedBox(width: 8),
            Text(endingTitle),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ending),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                '你的推理：',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text('兇手：${selectedCulprit!.name}'),
              Text('動機：$selectedMotive'),
              Text('已解鎖線索：${unlockedClues.length}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suspects = gameState.suspects;
    final unlockedClues = gameState.getUnlockedCluesForChapter(widget.caseItem.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('推理提交'),
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
              // Info card
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '提示',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '你已經解鎖了 ${unlockedClues.length} 個線索。\n'
                        '建議至少解鎖 3 個線索後再進行推理。',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Select culprit
              Text(
                '選擇兇手',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              
              ...suspects.map((suspect) {
                final isSelected = selectedCulprit?.id == suspect.id;
                return Card(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCulprit = suspect;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Radio<Suspect>(
                            value: suspect,
                            groupValue: selectedCulprit,
                            onChanged: (value) {
                              setState(() {
                                selectedCulprit = value;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: suspect.gender == '男'
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.pink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              suspect.gender == '男' 
                                  ? Icons.person 
                                  : Icons.person_outline,
                              color: suspect.gender == '男' 
                                  ? Colors.blue 
                                  : Colors.pink,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  suspect.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  suspect.occupation,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 24),
              
              // Select motive
              Text(
                '選擇動機',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    value: selectedMotive,
                    hint: const Text('請選擇動機'),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: motives.map((motive) {
                      return DropdownMenuItem(
                        value: motive,
                        child: Text(motive),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMotive = value;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Submit button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitDeduction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text(
                    '提交推理',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
