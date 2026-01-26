import 'package:flutter/material.dart';
import '../models/suspect_model.dart';
import '../models/question_model.dart';
import '../services/game_state_service.dart';

class InterrogationPage extends StatefulWidget {
  final Suspect suspect;

  const InterrogationPage({super.key, required this.suspect});

  @override
  State<InterrogationPage> createState() => _InterrogationPageState();
}

class _InterrogationPageState extends State<InterrogationPage> {
  final gameState = GameStateService();
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  bool showingAnswer = false;

  @override
  void initState() {
    super.initState();
    questions = gameState.getQuestionsForSuspect(widget.suspect.id);
  }

  void _askQuestion() {
    if (currentQuestionIndex >= questions.length) {
      // All questions answered
      gameState.incrementInterrogationCount(widget.suspect.id);
      
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

    // Unlock clue if specified
    final question = questions[currentQuestionIndex];
    if (question.unlocksClue.isNotEmpty) {
      gameState.unlockClue(question.unlocksClue);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('🔓 解鎖了新線索！'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        showingAnswer = false;
      });
    } else {
      // Last question, finish interrogation
      gameState.incrementInterrogationCount(widget.suspect.id);
      
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
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                minHeight: 8,
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Suspect info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: widget.suspect.gender == '男'
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.pink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                widget.suspect.gender == '男' 
                                    ? Icons.person 
                                    : Icons.person_outline,
                                size: 35,
                                color: widget.suspect.gender == '男' 
                                    ? Colors.blue 
                                    : Colors.pink,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.suspect.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    widget.suspect.occupation,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Question
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
                                  Icons.help_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '問題 ${currentQuestionIndex + 1}/${questions.length}',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currentQuestion.question,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Answer (if shown)
                    if (showingAnswer) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '回答',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentQuestion.answer,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Action button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: showingAnswer ? _nextQuestion : _askQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(
                    showingAnswer 
                        ? (currentQuestionIndex < questions.length - 1 ? '下一個問題' : '完成訊問')
                        : '提問',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
