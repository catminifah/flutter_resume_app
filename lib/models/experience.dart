class Experience {
  String company;
  String position;
  String startDate;
  String endDate;
  String description;

  Experience({
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    company: json['company'],
    position: json['position'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'company': company,
    'position': position,
    'startDate': startDate,
    'endDate': endDate,
    'description': description,
  };
}
