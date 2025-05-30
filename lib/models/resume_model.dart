import 'package:flutter_resume_app/models/certification.dart';
import 'package:flutter_resume_app/models/education.dart';
import 'package:flutter_resume_app/models/experience.dart';
import 'package:flutter_resume_app/models/language_skill.dart';
import 'package:flutter_resume_app/models/project.dart';
import 'package:flutter_resume_app/models/skill_category.dart';

class ResumeModel {
  String id;
  String firstname;
  String lastname;
  String email;
  String address;
  String phoneNumber;
  String aboutMe;
  List<String> websites;
  List<SkillCategory> skills;
  List<Experience> experiences;
  List<Education> educationList;
  List<Project> projects;
  List<Certification> certifications;
  List<LanguageSkill> languages;

  ResumeModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.aboutMe,
    required this.websites,
    required this.skills,
    required this.experiences,
    required this.educationList,
    required this.projects,
    required this.certifications,
    required this.languages,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) => ResumeModel(
    id: json['id'],
    firstname: json['firstname'],
    lastname: json['lastname'],
    email: json['email'],
    address: json['address'],
    phoneNumber: json['phoneNumber'],
    aboutMe: json['aboutMe'],
    websites: List<String>.from(json['websites']),
    skills: (json['skills'] as List).map((e) => SkillCategory.fromJson(e)).toList(),
    experiences: (json['experiences'] as List).map((e) => Experience.fromJson(e)).toList(),
    educationList: (json['educationList'] as List).map((e) => Education.fromJson(e)).toList(),
    projects: (json['projects'] as List).map((e) => Project.fromJson(e)).toList(),
    certifications: (json['certifications'] as List).map((e) => Certification.fromJson(e)).toList(),
    languages: (json['languages'] as List).map((e) => LanguageSkill.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'address': address,
    'phoneNumber': phoneNumber,
    'aboutMe': aboutMe,
    'websites': websites,
    'skills': skills.map((e) => e.toJson()).toList(),
    'experiences': experiences.map((e) => e.toJson()).toList(),
    'educationList': educationList.map((e) => e.toJson()).toList(),
    'projects': projects.map((e) => e.toJson()).toList(),
    'certifications': certifications.map((e) => e.toJson()).toList(),
    'languages': languages.map((e) => e.toJson()).toList(),
  };
}
