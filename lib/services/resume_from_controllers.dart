import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/models/certification.dart';
import 'package:flutter_resume_app/models/education.dart';
import 'package:flutter_resume_app/models/experience.dart';
import 'package:flutter_resume_app/models/language_skill.dart';
import 'package:flutter_resume_app/models/project.dart';
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:flutter_resume_app/models/skill_category.dart';

ResumeModel getResumeFromControllers({
  required TextEditingController firstnameController,
  required TextEditingController lastnameController,
  required TextEditingController emailController,
  required TextEditingController addressController,
  required TextEditingController phoneNumberController,
  required TextEditingController aboutMeController,
  required List<TextEditingController> websiteControllers,
  required List<TextEditingController> skillTitles,
  required List<String?> selectedSkillCategories,
  required List<List<TextEditingController>> skillControllers,
  required List<TextEditingController> companyName,
  required List<TextEditingController> position,
  required List<TextEditingController> startdatejob,
  required List<TextEditingController> enddatejob,
  required List<TextEditingController> detailjob,
  required List<TextEditingController> universityName,
  required List<TextEditingController> degreeTitle,
  required List<TextEditingController> startEducation,
  required List<TextEditingController> endEducation,
  required List<TextEditingController> projectTitleControllers,
  required List<TextEditingController> projectDescriptionControllers,
  required List<TextEditingController> projectLinkControllers,
  required List<TextEditingController> projectTechControllers,
  required List<TextEditingController> certificationTitleControllers,
  required List<TextEditingController> certificationIssuerControllers,
  required List<TextEditingController> certificationDateControllers,
  required List<TextEditingController> languageNameControllers,
  required List<TextEditingController> languageproficiencyControllers,
  Uint8List? profileImage,
}) {
  return ResumeModel(
    id: UniqueKey().toString(),
    firstname: firstnameController.text.trim(),
    lastname: lastnameController.text.trim(),
    email: emailController.text.trim(),
    address: addressController.text.trim(),
    phoneNumber: phoneNumberController.text.trim(),
    aboutMe: aboutMeController.text.trim(),
    websites: websiteControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList(),
    skills: List.generate(skillTitles.length, (i) {
      String category;
      if (selectedSkillCategories[i] == 'Custom') {
        category = skillTitles[i].text.trim();
        if (category.isEmpty) {
          category = 'Custom';
        }
      } else {
        category = selectedSkillCategories[i] ?? 'Other';
      }
      return SkillCategory(
        category: category,
        items: skillControllers[i].map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList(),
      );
    }),
    experiences: List.generate(companyName.length, (i) => Experience(
      company: companyName[i].text.trim(),
      position: position[i].text.trim(),
      startDate: startdatejob[i].text.trim(),
      endDate: enddatejob[i].text.trim(),
      description: detailjob[i].text.trim(),
    )),
    educationList: List.generate(universityName.length, (i) => Education(
      school: universityName[i].text.trim(),
      degree: degreeTitle[i].text.trim(),
      startDate: startEducation[i].text.trim(),
      endDate: endEducation[i].text.trim(),
    )),
    projects: List.generate(projectTitleControllers.length, (i) => Project(
      name: projectTitleControllers[i].text.trim(),
      description: projectDescriptionControllers[i].text.trim(),
      link: projectLinkControllers[i].text.trim(),
      tech: projectTechControllers[i].text.trim(),
    )),
    certifications: List.generate(certificationTitleControllers.length, (i) => Certification(
      title: certificationTitleControllers[i].text.trim(),
      issuer: certificationIssuerControllers[i].text.trim(),
      date: certificationDateControllers[i].text.trim(),
    )),
    languages: List.generate(languageNameControllers.length, (i) => LanguageSkill(
      language: languageNameControllers[i].text.trim(),
      proficiency: languageproficiencyControllers[i].text.trim(),
    )),
    profileImage: profileImage,
  );
}
