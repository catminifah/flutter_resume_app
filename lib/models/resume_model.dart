class ResumeModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String address;
  String aboutMe;
  List<String> websites;
  List<String> skills;
  List<WorkExperience> experiences;
  List<Education> educations;

  ResumeModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.aboutMe,
    required this.websites,
    required this.skills,
    required this.experiences,
    required this.educations,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      aboutMe: json['aboutMe'],
      websites: List<String>.from(json['websites']),
      skills: List<String>.from(json['skills']),
      experiences: (json['experiences'] as List)
          .map((e) => WorkExperience.fromJson(e))
          .toList(),
      educations: (json['educations'] as List)
          .map((e) => Education.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'address': address,
        'aboutMe': aboutMe,
        'websites': websites,
        'skills': skills,
        'experiences': experiences.map((e) => e.toJson()).toList(),
        'educations': educations.map((e) => e.toJson()).toList(),
      };
}

class WorkExperience {
  String company;
  String jobTitle;
  String startDate;
  String endDate;
  String description;

  WorkExperience({
    required this.company,
    required this.jobTitle,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      company: json['company'],
      jobTitle: json['jobTitle'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'company': company,
        'jobTitle': jobTitle,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
      };
}

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

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      school: json['school'],
      degree: json['degree'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'school': school,
        'degree': degree,
        'startDate': startDate,
        'endDate': endDate,
      };
}
