class Education {
  String school;
  String degree;
  String field;
  String startDate;
  String endDate;

  Education({
    required this.school,
    required this.degree,
    required this.field,
    required this.startDate,
    required this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    school: json['school'],
    degree: json['degree'],
    field: json['field'],
    startDate: json['startDate'],
    endDate: json['endDate'],
  );

  Map<String, dynamic> toJson() => {
    'school': school,
    'degree': degree,
    'field': field,
    'startDate': startDate,
    'endDate': endDate,
  };
}
