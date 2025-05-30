class Project {
  String name;
  String description;
  String link;

  Project({
    required this.name,
    required this.description,
    required this.link,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    name: json['name'],
    description: json['description'],
    link: json['link'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'link': link,
  };
}
