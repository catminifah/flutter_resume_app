class Certification {
  String title;
  String issuer;
  String date;

  Certification({
    required this.title,
    required this.issuer,
    required this.date,
  });

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
    title: json['title'],
    issuer: json['issuer'],
    date: json['date'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'issuer': issuer,
    'date': date,
  };
}
