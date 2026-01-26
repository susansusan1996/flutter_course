class Case {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  Case({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
