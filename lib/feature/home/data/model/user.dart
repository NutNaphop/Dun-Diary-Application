class User {
  final int id;
  final String title;
  final String image;
  final String profile;

  User({
    required this.id,
    required this.title,
    required this.image,
    required this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      image: json['url'],
      profile: json['thumbnailUrl'],
    );
  }
}