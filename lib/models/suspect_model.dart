class Suspect {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final String alibi;
  final String imageUrl;
  final String gender; // "男" or "女"

  Suspect({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    required this.alibi,
    required this.imageUrl,
    required this.gender,
  });

  factory Suspect.fromJson(Map<String, dynamic> json) {
    return Suspect(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      occupation: json['occupation'],
      alibi: json['alibi'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'occupation': occupation,
      'alibi': alibi,
      'imageUrl': imageUrl,
      'gender': gender,
    };
  }
}
