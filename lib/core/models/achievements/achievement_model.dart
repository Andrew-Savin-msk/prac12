class Achievement {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isUnlocked = false,
  });
}

