class SkillCategory {
  final String category;
  final List<String> items;

  SkillCategory({
    required this.category,
    required this.items,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      category: json['category'] ?? '',
      items: List<String>.from(json['items'] ?? []),
    );
  }
  Map<String, dynamic> toJson() => {
    'category': category,
    'skills': items,
  };
}
