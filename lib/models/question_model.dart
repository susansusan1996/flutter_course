class Question {
  final String id;
  final String suspectId;
  final String question;
  final String answer;
  final String unlocksClue;

  Question({
    required this.id,
    required this.suspectId,
    required this.question,
    required this.answer,
    required this.unlocksClue,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      suspectId: json['suspectId'],
      question: json['question'],
      answer: json['answer'],
      unlocksClue: json['unlocksClue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'suspectId': suspectId,
      'question': question,
      'answer': answer,
      'unlocksClue': unlocksClue,
    };
  }
}
