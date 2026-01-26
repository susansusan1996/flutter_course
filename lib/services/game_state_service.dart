import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/case_model.dart';
import '../models/clue_model.dart';
import '../models/suspect_model.dart';
import '../models/question_model.dart';

class GameStateService {
  static final GameStateService _instance = GameStateService._internal();
  factory GameStateService() => _instance;
  GameStateService._internal();

  List<Case> _cases = [];
  List<Clue> _clues = [];
  List<Suspect> _suspects = [];
  List<Question> _questions = [];
  
  Set<String> _unlockedClues = {};
  Set<int> _completedChapters = {};
  Map<String, int> _interrogationCounts = {};

  // Getters
  List<Case> get cases => _cases;
  List<Clue> get clues => _clues;
  List<Suspect> get suspects => _suspects;
  List<Question> get questions => _questions;
  Set<String> get unlockedClues => _unlockedClues;
  Set<int> get completedChapters => _completedChapters;

  // Load all game data
  Future<void> loadGameData() async {
    await Future.wait([
      _loadCases(),
      _loadClues(),
      _loadSuspects(),
      _loadQuestions(),
      _loadProgress(),
    ]);
  }

  Future<void> _loadCases() async {
    final String jsonString = await rootBundle.loadString('assets/data/cases.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    _cases = jsonData.map((json) => Case.fromJson(json)).toList();
  }

  Future<void> _loadClues() async {
    final String jsonString = await rootBundle.loadString('assets/data/clues.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    _clues = jsonData.map((json) => Clue.fromJson(json)).toList();
  }

  Future<void> _loadSuspects() async {
    final String jsonString = await rootBundle.loadString('assets/data/suspects.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    _suspects = jsonData.map((json) => Suspect.fromJson(json)).toList();
  }

  Future<void> _loadQuestions() async {
    final String jsonString = await rootBundle.loadString('assets/data/questions.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    _questions = jsonData.map((json) => Question.fromJson(json)).toList();
  }

  // Load progress from SharedPreferences
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load unlocked clues
    final unlockedCluesList = prefs.getStringList('unlocked_clues') ?? [];
    _unlockedClues = Set.from(unlockedCluesList);
    
    // Update clue unlock status
    for (var clue in _clues) {
      clue.isUnlocked = _unlockedClues.contains(clue.id) || clue.isUnlocked;
    }
    
    // Load completed chapters
    final completedChaptersList = prefs.getStringList('completed_chapters') ?? [];
    _completedChapters = Set.from(completedChaptersList.map((e) => int.parse(e)));
    
    // Load interrogation counts
    final interrogationCountsJson = prefs.getString('interrogation_counts') ?? '{}';
    final Map<String, dynamic> countsMap = json.decode(interrogationCountsJson);
    _interrogationCounts = countsMap.map((key, value) => MapEntry(key, value as int));
  }

  // Save progress to SharedPreferences
  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setStringList('unlocked_clues', _unlockedClues.toList());
    await prefs.setStringList('completed_chapters', _completedChapters.map((e) => e.toString()).toList());
    await prefs.setString('interrogation_counts', json.encode(_interrogationCounts));
  }

  // Unlock a clue
  void unlockClue(String clueId) {
    _unlockedClues.add(clueId);
    final clue = _clues.firstWhere((c) => c.id == clueId, orElse: () => _clues.first);
    clue.isUnlocked = true;
    saveProgress();
  }

  // Complete a chapter
  void completeChapter(int chapterId) {
    _completedChapters.add(chapterId);
    saveProgress();
  }

  // Get questions for a suspect
  List<Question> getQuestionsForSuspect(String suspectId) {
    return _questions.where((q) => q.suspectId == suspectId).toList();
  }

  // Get clues for a chapter
  List<Clue> getCluesForChapter(int chapterId) {
    return _clues.where((c) => c.chapterId == chapterId).toList();
  }

  // Get unlocked clues for a chapter
  List<Clue> getUnlockedCluesForChapter(int chapterId) {
    return _clues.where((c) => c.chapterId == chapterId && c.isUnlocked).toList();
  }

  // Increment interrogation count
  void incrementInterrogationCount(String suspectId) {
    _interrogationCounts[suspectId] = (_interrogationCounts[suspectId] ?? 0) + 1;
    saveProgress();
  }

  // Get interrogation count
  int getInterrogationCount(String suspectId) {
    return _interrogationCounts[suspectId] ?? 0;
  }

  // Check if can interrogate (limit 3 times per suspect)
  bool canInterrogate(String suspectId) {
    return getInterrogationCount(suspectId) < 3;
  }

  // Reset game progress
  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _unlockedClues.clear();
    _completedChapters.clear();
    _interrogationCounts.clear();
    
    for (var clue in _clues) {
      clue.isUnlocked = false;
    }
  }
}
