class Clue {
  final String id;
  final int chapterId;
  final String title;
  final String description;
  final String imageUrl;
  final String time;
  final String credibility;
  bool isUnlocked;

  Clue({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.time,
    required this.credibility,
    this.isUnlocked = false,
  });

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      id: json['id'],
      chapterId: json['chapterId'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      time: json['time'],
      credibility: json['credibility'],
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'time': time,
      'credibility': credibility,
      'isUnlocked': isUnlocked,
    };
  }
}
