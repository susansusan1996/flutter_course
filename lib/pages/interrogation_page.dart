import 'package:flutter/material.dart';
import '../models/suspect_model.dart';
import '../models/question_model.dart';
import '../data/game_data.dart';

class InterrogationPage extends StatefulWidget {
  final Suspect suspect;

  const InterrogationPage({super.key, required this.suspect});

  @override
  State<InterrogationPage> createState() => _InterrogationPageState();
}

class _InterrogationPageState extends State<InterrogationPage> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  bool showingAnswer = false;

  @override
  void initState() {
    super.initState();
    // 找出這個嫌疑人的問題
    questions = allQuestions
        .where((q) => q.suspectId == widget.suspect.id)
        .toList();
  }

  void _askQuestion() {
    if (currentQuestionIndex >= questions.length) {
      // 所有問題都問完了
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('訊問完成'),
          content: const Text('你已經問完所有問題了。'),
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
      return;
    }

    setState(() {
      showingAnswer = true;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        showingAnswer = false;
      });
    } else {
      // 最後一題，完成訊問
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('訊問完成'),
          content: const Text('你已經完成了這次訊問。'),
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
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('訊問')),
        body: const Center(child: Text('沒有可用的問題')),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('訊問 ${widget.suspect.name}'),
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('問題 ${currentQuestionIndex + 1}/${questions.length}'),
          ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Suspect info
                    Card(
                      child: ListTile(
                        leading: Icon(
                          widget.suspect.gender == '男' ? Icons.person : Icons.person_outline,
                        ),
                        title: Text(widget.suspect.name),
                        subtitle: Text(widget.suspect.occupation),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Question
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '問題：',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentQuestion.question,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Answer (if shown)
                    if (showingAnswer)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '回答：',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(currentQuestion.answer),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Action button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: showingAnswer ? _nextQuestion : _askQuestion,
                child: Text(
                  showingAnswer 
                      ? (currentQuestionIndex < questions.length - 1 ? '下一個問題' : '完成訊問')
                      : '提問',
                ),
              ),
            ),
          ],
        ),
    );
  }
}
