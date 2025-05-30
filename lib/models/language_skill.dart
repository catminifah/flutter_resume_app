class LanguageSkill {
  String language;
  String proficiency;

  LanguageSkill({
    required this.language,
    required this.proficiency,
  });

  factory LanguageSkill.fromJson(Map<String, dynamic> json) => LanguageSkill(
    language: json['language'],
    proficiency: json['proficiency'],
  );

  Map<String, dynamic> toJson() => {
    'language': language,
    'proficiency': proficiency,
  };
}
