class Project {
  String name;
  String description;
  String link;
  String tech;

  Project({
    required this.name,
    required this.description,
    required this.link,
    required this.tech,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    name: json['name'],
    description: json['description'],
    link: json['link'],
    tech: json['tech'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'link': link,
    'tech': tech,
  };
}
