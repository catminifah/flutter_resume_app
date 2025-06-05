class Education {
  String school;
  String degree;
  String startDate;
  String endDate;

  Education({
    required this.school,
    required this.degree,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    school: json['school'],
    degree: json['degree'],
    startDate: json['startDate'],
    endDate: json['endDate'],
  );

  Map<String, dynamic> toJson() => {
    'school': school,
    'degree': degree,
    'startDate': startDate,
    'endDate': endDate,
  };
}