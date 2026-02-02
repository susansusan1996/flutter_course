import 'package:flutter/material.dart';
import '../models/case_model.dart';
import '../models/suspect_model.dart';
import '../data/game_data.dart';

class DeductionPage extends StatefulWidget {
  final Case caseItem;

  const DeductionPage({super.key, required this.caseItem});

  @override
  State<DeductionPage> createState() => _DeductionPageState();
}

class _DeductionPageState extends State<DeductionPage> {
  Suspect? selectedCulprit;
  String? selectedMotive;
  
  final List<String> motives = [
    '商業競爭',
    '個人恩怨',
    '意外事故',
  ];

  void _submitDeduction() {
    if (selectedCulprit == null || selectedMotive == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請選擇兇手和動機')),
      );
      return;
    }

    // 檢查答案是否正確
    final isCorrect = selectedCulprit!.id == 'suspect_1' && selectedMotive == '商業競爭';
    
    String message;
    if (isCorrect) {
      message = '恭喜！你成功破案了！\n\n${selectedCulprit!.name}確實是兇手，動機是$selectedMotive。';
    } else {
      message = '答案不正確！\n\n請重新檢視線索，再試一次。\n\n提示：真正的兇手是誰？動機又是什麼？';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '✅ 破案成功' : '❌ 答案錯誤'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) {
                Navigator.pop(context);
              }
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推理提交'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const Text('選擇你認為的兇手和犯案動機'),
              ),
            ),
            const SizedBox(height: 16),
              
            // Select culprit
            Text(
              '選擇兇手',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            
            ...allSuspects.map((suspect) {
              return RadioListTile<Suspect>(
                value: suspect,
                groupValue: selectedCulprit,
                onChanged: (value) {
                  setState(() {
                    selectedCulprit = value;
                  });
                },
                title: Text('${suspect.name} (${suspect.occupation})'),
                secondary: Icon(
                  suspect.gender == '男' ? Icons.person : Icons.person_outline,
                ),
              );
            }),
              
              const SizedBox(height: 24),
              
              // Select motive
              Text(
                '選擇動機',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              
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
              
            const SizedBox(height: 24),
            
            // Submit button
            ElevatedButton(
              onPressed: _submitDeduction,
              child: const Text('提交推理'),
            ),
          ],
        ),
      ),
    );
  }
}
