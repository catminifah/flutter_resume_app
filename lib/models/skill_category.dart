class SkillCategory {
  String category;
  List<String> skills;

  SkillCategory({required this.category, required this.skills});

  factory SkillCategory.fromJson(Map<String, dynamic> json) => SkillCategory(
    category: json['category'],
    skills: List<String>.from(json['skills']),
  );

  Map<String, dynamic> toJson() => {
    'category': category,
    'skills': skills,
  };
}
