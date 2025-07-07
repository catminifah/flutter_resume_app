import 'dart:math';

import 'package:flutter/services.dart' show rootBundle, Uint8List, ByteData;
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:flutter_resume_app/pdf_templates/pdf_utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

class ResumeTemplate2Generator {
  Future<Uint8List> loadIcon(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  /*List<pw.Widget> generateLeftColumnWidgets(
      ResumeModel resume,
      pw.Font EBGaramondBoldFont,
      pw.Font EBGaramondFont,
      pdf.PdfColor backgroundColor) {
    final certifications = <Map<String, String>>[];
    for (final cert in resume.certifications) {
      certifications.add({
        'title': cert.title.trim(),
        'issuer': cert.issuer.trim(),
        'date': cert.date.trim(),
      });
    }

    final projects = <Map<String, String>>[];
    for (final proj in resume.projects) {
      projects.add({
        'title': proj.name.trim(),
        'description': proj.description.trim(),
        'link': proj.link.trim(),
        'tech': proj.tech.trim(),
      });
    }
    final widgets = <pw.Widget>[];
    final fullnameSection = <pw.Widget>[];
    final profileSection = <pw.Widget>[];
    final educationSection = <pw.Widget>[];
    final experienceSection = <pw.Widget>[];
    final projectSection = <pw.Widget>[];
    final certificationSection = <pw.Widget>[];

    widgets.add(
      pw.SizedBox(height: 20),
    );

    // Full NAME
    if (resume.firstname.isNotEmpty || resume.lastname.isNotEmpty) {
      fullnameSection.add(
        pw.Text(
          '${resume.firstname.toUpperCase()} ${resume.lastname.toUpperCase()}',
          style: pw.TextStyle(
            fontSize: 25,
            fontWeight: pw.FontWeight.normal,
            color: backgroundColor,
          ),
          softWrap: true,
        ),
      );
      fullnameSection.add(
        pw.SizedBox(height: 10),
      );
    }

    // PROFILLE
    if (resume.aboutMe.isNotEmpty) {
      profileSection.add(
        pw.Text('PROFILLE',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: backgroundColor)),
      );
      profileSection.add(
        pw.Divider(thickness: 1, color: PdfColors.grey),
      );
    }
    if (resume.aboutMe.isNotEmpty) {
      profileSection.addAll([
        ...splitTextToParagraphs(resume.aboutMe,fontSize: 10, color: PdfColors.grey),
      ]);
      profileSection.add(
        pw.SizedBox(height: 10),
      );
    }

    // Education
    if (resume.educationList.isNotEmpty &&
                  resume.educationList.any((edu) =>
                      edu.startDate.trim().isNotEmpty ||
                      edu.endDate.trim().isNotEmpty ||
                      edu.school.trim().isNotEmpty ||
                      edu.degree.trim().isNotEmpty)) {
                educationSection.addAll([pw.Text('Education',
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: backgroundColor)),
                pw.Divider(thickness: 1, color: PdfColors.grey),]);
                ...resume.educationList.asMap().entries.map((entry) {
                  int index = entry.key;
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        if (resume.educationList[index].school.isNotEmpty)
                          pw.Text(resume.educationList[index].school,
                              style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  font: EBGaramondBoldFont)),
                        pw.SizedBox(width: 5),
                        if (resume.educationList[index].startDate
                                .trim()
                                .isNotEmpty ||
                            resume.educationList[index].endDate
                                .trim()
                                .isNotEmpty)
                          pw.Text(
                            resume.educationList[index].startDate
                                        .trim()
                                        .isNotEmpty &&
                                    resume.educationList[index].endDate
                                        .trim()
                                        .isNotEmpty
                                ? '${resume.educationList[index].startDate.trim()} - ${resume.educationList[index].endDate.trim()}'
                                : resume.educationList[index].startDate
                                        .trim()
                                        .isNotEmpty
                                    ? resume.educationList[index].startDate
                                        .trim()
                                    : resume.educationList[index].endDate
                                        .trim(),
                            style: pw.TextStyle(
                                fontSize: 8, color: PdfColors.grey),
                          ),
                        pw.SizedBox(width: 5),
                      ]),
                      if (resume.educationList[index].degree.isNotEmpty)
                        pw.Text(resume.educationList[index].degree,
                            style: pw.TextStyle(
                                fontSize: 13,
                                color: PdfColors.grey900,
                                font: EBGaramondFont)),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }),
                pw.SizedBox(height: 10),
              }

    return [
      pw.Expanded(
        child: pw.Container(
          padding: pw.EdgeInsets.only(left: 20, right: 20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              //pw.SizedBox(height: 20),
              // Full NAME
              /*if (resume.firstname.isNotEmpty ||
                  resume.lastname.isNotEmpty) ...[
                pw.Text(
                  '${resume.firstname.toUpperCase()} ${resume.lastname.toUpperCase()}',
                  style: pw.TextStyle(
                    fontSize: 25,
                    fontWeight: pw.FontWeight.normal,
                    color: backgroundColor,
                  ),
                  softWrap: true,
                ),
                pw.SizedBox(height: 10),
              ],*/

              // PROFILLE
              /*if (resume.aboutMe.isNotEmpty) ...[
                pw.Text('PROFILLE',
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: backgroundColor)),
                pw.Divider(thickness: 1, color: PdfColors.grey),
              ],
              if (resume.aboutMe.isNotEmpty) ...[
                pw.Text(resume.aboutMe,
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                pw.SizedBox(height: 10),
              ],*/

              // Education
              if (resume.educationList.isNotEmpty &&
                  resume.educationList.any((edu) =>
                      edu.startDate.trim().isNotEmpty ||
                      edu.endDate.trim().isNotEmpty ||
                      edu.school.trim().isNotEmpty ||
                      edu.degree.trim().isNotEmpty)) ...[
                pw.Text('Education',
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: backgroundColor)),
                pw.Divider(thickness: 1, color: PdfColors.grey),
                ...resume.educationList.asMap().entries.map((entry) {
                  int index = entry.key;
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        if (resume.educationList[index].school.isNotEmpty)
                          pw.Text(resume.educationList[index].school,
                              style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  font: EBGaramondBoldFont)),
                        pw.SizedBox(width: 5),
                        if (resume.educationList[index].startDate
                                .trim()
                                .isNotEmpty ||
                            resume.educationList[index].endDate
                                .trim()
                                .isNotEmpty)
                          pw.Text(
                            resume.educationList[index].startDate
                                        .trim()
                                        .isNotEmpty &&
                                    resume.educationList[index].endDate
                                        .trim()
                                        .isNotEmpty
                                ? '${resume.educationList[index].startDate.trim()} - ${resume.educationList[index].endDate.trim()}'
                                : resume.educationList[index].startDate
                                        .trim()
                                        .isNotEmpty
                                    ? resume.educationList[index].startDate
                                        .trim()
                                    : resume.educationList[index].endDate
                                        .trim(),
                            style: pw.TextStyle(
                                fontSize: 8, color: PdfColors.grey),
                          ),
                        pw.SizedBox(width: 5),
                      ]),
                      if (resume.educationList[index].degree.isNotEmpty)
                        pw.Text(resume.educationList[index].degree,
                            style: pw.TextStyle(
                                fontSize: 13,
                                color: PdfColors.grey900,
                                font: EBGaramondFont)),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }),
                pw.SizedBox(height: 10),
              ],

              // Work Experience
              if (resume.experiences.any((work) =>
                  work.company.trim().isNotEmpty ||
                  work.description.trim().isNotEmpty ||
                  work.startDate.trim().isNotEmpty ||
                  work.endDate.trim().isNotEmpty ||
                  work.position.trim().isNotEmpty)) ...[
                pw.Text('Work Experience',
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: backgroundColor)),
                pw.Divider(thickness: 1, color: PdfColors.grey),
                ...resume.experiences.map((work) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text(work.company,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                font: EBGaramondBoldFont)),
                        pw.SizedBox(width: 5),
                        pw.Text(
                          '${work.startDate} - ${work.endDate.isEmpty ? 'PRESENT' : work.endDate}',
                          style:
                              pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                        ),
                      ]),
                      pw.Text(work.position,
                          style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.normal,
                              color: PdfColors.grey900,
                              font: EBGaramondFont)),
                      pw.SizedBox(width: 5),
                      pw.Text(work.description,
                          style: pw.TextStyle(
                              fontSize: 10, color: PdfColors.grey800)),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }),
                pw.SizedBox(height: 10),
              ],

              //Project
              if (projects.any((p) => p.values.any((v) => v.isNotEmpty))) ...[
                pw.Text('Projects',
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: backgroundColor)),
                pw.Divider(thickness: 1, color: PdfColors.grey),
                ...projects.map((project) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (project['title']!.isNotEmpty)
                        pw.Text(project['title']!,
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                font: EBGaramondBoldFont)),
                      if (project['tech']!.isNotEmpty)
                        pw.Text('${project['tech']}',
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.grey800)),
                      if (project['description']!.isNotEmpty)
                        pw.Text(project['description']!,
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.grey800)),
                      if (project['link']!.isNotEmpty)
                        pw.Text('${project['link']}',
                            style: pw.TextStyle(
                                fontSize: 10, color: backgroundColor)),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }),
                pw.SizedBox(height: 10),
              ],
              // Certifications
              if (certifications
                  .any((c) => c.values.any((v) => v.isNotEmpty))) ...[
                pw.Text('Certifications',
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: backgroundColor)),
                pw.Divider(thickness: 1, color: PdfColors.grey),
                ...certifications.map((cert) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        if (cert['title']!.isNotEmpty)
                          pw.Text(cert['title']!,
                              style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  font: EBGaramondBoldFont)),
                        pw.SizedBox(width: 5),
                        if (cert['date']!.isNotEmpty)
                          pw.Text('${cert['date']}',
                              style: pw.TextStyle(
                                  fontSize: 8, color: PdfColors.grey)),
                        pw.SizedBox(width: 5),
                      ]),
                      if (cert['issuer']!.isNotEmpty)
                        pw.Text('${cert['issuer']}',
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.grey800)),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }),
              ]
            ],
          ),
        ),
      ),
    ];
  }*/

  Map<String, List<pw.Widget>> generateLeftColumnWidgets(
    ResumeModel resume,
    pw.Font EBGaramondBoldFont,
    pw.Font EBGaramondFont,
    pdf.PdfColor backgroundColor,
  ) {
    final widgets = <pw.Widget>[];
    final profileSection = <pw.Widget>[];
    final educationSection = <pw.Widget>[];
    final experienceSection = <pw.Widget>[];
    final projectSection = <pw.Widget>[];
    final certificationSection = <pw.Widget>[];

    // Full Name
    if (resume.firstname.isNotEmpty || resume.lastname.isNotEmpty) {
      widgets.add(
        pw.Text(
          '${resume.firstname.toUpperCase()} ${resume.lastname.toUpperCase()}',
          style: pw.TextStyle(
            fontSize: 25,
            fontWeight: pw.FontWeight.normal,
            color: backgroundColor,
          ),
          softWrap: true,
        ),
      );
      widgets.add(pw.SizedBox(height: 10));
    }

    // PROFILE
    if (resume.aboutMe.isNotEmpty) {
      profileSection.addAll([
        pw.Text('PROFILE',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: backgroundColor)),
        pw.Divider(thickness: 1, color: PdfColors.grey),
        ...splitTextToParagraphs(
          resume.aboutMe,
          font: EBGaramondFont,
          fontSize: 10,
          color: PdfColors.grey,
        ),
        pw.SizedBox(height: 10),
      ]);
    }

    // EDUCATION
    if (resume.educationList.any((edu) =>
        edu.startDate.trim().isNotEmpty ||
        edu.endDate.trim().isNotEmpty ||
        edu.school.trim().isNotEmpty ||
        edu.degree.trim().isNotEmpty)) {
      educationSection.addAll([
        pw.Text('Education',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: backgroundColor)),
        pw.Divider(thickness: 1, color: PdfColors.grey),
      ]);

      for (final edu in resume.educationList) {
        final duration =
            '${edu.startDate.trim()} - ${edu.endDate.trim().isEmpty ? 'Present' : edu.endDate.trim()}';

        educationSection.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (edu.school.isNotEmpty)
                pw.Text(edu.school,
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        font: EBGaramondBoldFont)),
              if (duration.trim() != ' - Present')
                pw.Text(duration,
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              if (edu.degree.isNotEmpty)
                pw.Text(edu.degree,
                    style: pw.TextStyle(
                        fontSize: 13,
                        color: PdfColors.grey900,
                        font: EBGaramondFont)),
              pw.SizedBox(height: 10),
            ],
          ),
        );
      }
    }

    // EXPERIENCE
    if (resume.experiences.any((exp) =>
        exp.company.trim().isNotEmpty ||
        exp.description.trim().isNotEmpty ||
        exp.startDate.trim().isNotEmpty ||
        exp.endDate.trim().isNotEmpty ||
        exp.position.trim().isNotEmpty)) {
      experienceSection.addAll([
        pw.Text('Work Experience',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: backgroundColor)),
        pw.Divider(thickness: 1, color: PdfColors.grey),
      ]);

      for (final work in resume.experiences) {
        final duration =
            '${work.startDate.trim()} - ${work.endDate.trim().isEmpty ? 'Present' : work.endDate.trim()}';

        experienceSection.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(children: [
                if (work.company.isNotEmpty)
                  pw.Text(work.company,
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          font: EBGaramondBoldFont)),
                pw.SizedBox(width: 5),
                pw.Text(duration,
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              ]),
              if (work.position.isNotEmpty)
                pw.Text(work.position,
                    style: pw.TextStyle(
                        fontSize: 12,
                        font: EBGaramondFont,
                        color: PdfColors.grey900)),
              if (work.description.isNotEmpty)
                ...splitTextToParagraphs(work.description,
                    fontSize: 10, color: PdfColors.grey800),
              pw.SizedBox(height: 10),
            ],
          ),
        );
      }
    }

    // PROJECTS
    final projects = resume.projects
        .map((proj) => {
              'title': proj.name.trim(),
              'description': proj.description.trim(),
              'link': proj.link.trim(),
              'tech': proj.tech.trim(),
            })
        .toList();

    if (projects.any((p) => p.values.any((v) => v.isNotEmpty))) {
      projectSection.addAll([
        pw.Text('Projects',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: backgroundColor)),
        pw.Divider(thickness: 1, color: PdfColors.grey),
      ]);

      for (final project in projects) {
        projectSection.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (project['title']!.isNotEmpty)
                pw.Text(project['title']!,
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        font: EBGaramondBoldFont)),
              if (project['tech']!.isNotEmpty)
                pw.Text(project['tech']!,
                    style:
                        pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              if (project['description']!.isNotEmpty)
                ...splitTextToParagraphs(project['description']!,
                    fontSize: 10, color: PdfColors.grey800),
              if (project['link']!.isNotEmpty)
                pw.Text(project['link']!,
                    style: pw.TextStyle(fontSize: 10, color: backgroundColor)),
              pw.SizedBox(height: 10),
            ],
          ),
        );
      }
    }

    // CERTIFICATIONS
    final certifications = resume.certifications
        .map((cert) => {
              'title': cert.title.trim(),
              'issuer': cert.issuer.trim(),
              'date': cert.date.trim(),
            })
        .toList();

    if (certifications.any((c) => c.values.any((v) => v.isNotEmpty))) {
      certificationSection.addAll([
        pw.Text('Certifications',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: backgroundColor)),
        pw.Divider(thickness: 1, color: PdfColors.grey),
      ]);

      for (final cert in certifications) {
        certificationSection.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(children: [
                if (cert['title']!.isNotEmpty)
                  pw.Text(cert['title']!,
                      style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          font: EBGaramondBoldFont)),
                pw.SizedBox(width: 5),
                if (cert['date']!.isNotEmpty)
                  pw.Text(cert['date']!,
                      style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              ]),
              if (cert['issuer']!.isNotEmpty)
                pw.Text(cert['issuer']!,
                    style:
                        pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              pw.SizedBox(height: 10),
            ],
          ),
        );
      }
    }

    return {
      'widgets': widgets,
      'profile': profileSection,
      'education': educationSection,
      'experience': experienceSection,
      'projects': projectSection,
      'certifications': certificationSection,
    };
  }


  List<pw.Widget> generateRightColumnWidgets(
      ResumeModel resume,
      Uint8List emailIcon,
      Uint8List phoneIcon,
      Uint8List addressIcon,
      Uint8List wabIcon,
      pdf.PdfColor backgroundColor,
      {bool showProfileImage = false}) {
    final languages = List.generate(
      resume.languages.length,
      (index) => {
        'name': resume.languages[index].language.trim(),
        'level': resume.languages[index].proficiency.trim(),
      },
    );
    final widgets = <pw.Widget>[];
    if (showProfileImage && resume.profileImage != null) {
      widgets.add(
        pw.Container(
          width: 170,
          height: 170,
          decoration: pw.BoxDecoration(
            color: backgroundColor,
          ),
          child: pw.Image(
            pw.MemoryImage(resume.profileImage!),
            fit: pw.BoxFit.cover,
          ),
        ),
      );
    }

    widgets.add(
      pw.Container(
        padding: pw.EdgeInsets.all(10),
        color: backgroundColor,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Email
            if (resume.email.isNotEmpty) ...[
              pw.Row(
                children: [
                  pw.Image(pw.MemoryImage(emailIcon), width: 12, height: 12),
                  pw.SizedBox(width: 5),
                  pw.Expanded(
                    child: pw.Text(
                      resume.email,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.white,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
            ],

            // NumberPhone
            if (resume.phoneNumber.isNotEmpty) ...[
              pw.Row(
                children: [
                  pw.Image(pw.MemoryImage(phoneIcon), width: 12, height: 12),
                  pw.SizedBox(width: 5),
                  pw.Text(resume.phoneNumber,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.white,
                      )),
                ],
              ),
              pw.SizedBox(height: 5),
            ],

            // Address
            if (resume.address.isNotEmpty) ...[
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(pw.MemoryImage(addressIcon), width: 12, height: 12),
                  pw.SizedBox(width: 5),
                  pw.Expanded(
                    child: pw.Text(
                      resume.address,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.white,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
            ],

            if (resume.websites.isNotEmpty) ...[
              ...resume.websites.asMap().entries.map((entry) {
                int index = entry.key;
                String website = entry.value;

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (website.isNotEmpty)
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Image(pw.MemoryImage(wabIcon),
                              width: 12, height: 12),
                          pw.SizedBox(width: 5),
                          pw.Expanded(
                            child: pw.Text(
                              website,
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.white,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }),
              pw.SizedBox(height: 10),
            ],

            if (resume.email.isNotEmpty ||
                resume.phoneNumber.isNotEmpty ||
                resume.address.isNotEmpty ||
                resume.websites.isNotEmpty) ...[
              pw.Divider(thickness: 1, color: PdfColors.white),
            ],

            // Languages
            if (languages.any((l) => l.values.any((v) => v.isNotEmpty))) ...[
              pw.Text(
                'Languages',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 5),
              ...languages.map((lang) {
                final name = lang['name']?.trim() ?? '';
                final level = lang['level']?.trim() ?? '';
                if (name.isEmpty && level.isEmpty) {
                  return pw.SizedBox();
                }

                return pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10, bottom: 2),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 3,
                        height: 3,
                        margin: const pw.EdgeInsets.only(bottom: 1),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.SizedBox(width: 5),
                      pw.Text(
                        level.isNotEmpty ? '$name ($level)' : name,
                        style:
                            pw.TextStyle(fontSize: 10, color: PdfColors.white),
                      ),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 10),
            ],

            // Skills Summary
            ...resume.skills.asMap().entries.map((entry) {
              final int categoryIndex = entry.key;
              final skillCategory = entry.value;

              final String categoryTitle = skillCategory.category.trim();
              final List<String> skills = skillCategory.items;
              final bool allSkillsEmpty = skills.every((s) => s.trim().isEmpty);
              final bool isCategoryEmpty =
                  categoryTitle.isEmpty && allSkillsEmpty;

              //if (isCategoryEmpty) return pw.SizedBox();

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (categoryTitle.isNotEmpty)
                    pw.Text(
                      categoryTitle,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  if (categoryTitle.isNotEmpty) pw.SizedBox(height: 5),
                  ...skills.map((skillController) {
                    final skillText = skillController.trim();
                    if (skillText.isEmpty) return pw.SizedBox();

                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, bottom: 2),
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 3,
                            height: 3,
                            margin: const pw.EdgeInsets.only(bottom: 1),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.white,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            skillText,
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.white),
                          ),
                        ],
                      ),
                    );
                  }),
                  pw.SizedBox(height: 10),
                ],
              );
            }),
            pw.SizedBox(height: 5),
          ],
        ),
      ),
    );

    return widgets;
  }

  /*List<List<pw.Widget>> paginateWidgets(
      List<pw.Widget> widgets, double maxHeightPerPage) {
    final List<List<pw.Widget>> pages = [];
    List<pw.Widget> currentPage = [];
    double currentHeight = 0;

    for (var widget in widgets) {
      currentPage.add(widget);
      currentHeight += 20;
      if (currentHeight >= maxHeightPerPage) {
        pages.add(currentPage);
        currentPage = [];
        currentHeight = 0;
      }
    }
    if (currentPage.isNotEmpty) pages.add(currentPage);
    return pages;
  }*/

  Future<Future<Uint8List>> generatePdfFromResume(ResumeModel resume) async {
    final pdf = pw.Document();

    final pageWidth = PdfPageFormat.a4.width;
    final pageHeight = PdfPageFormat.a4.height;

    final emailIcon = await loadIcon('assets/icons/email_white.png');
    final phoneIcon = await loadIcon('assets/icons/phone_white.png');
    final addressIcon = await loadIcon('assets/icons/address_white.png');
    final wabIcon = await loadIcon('assets/icons/web_white.png');

    final ARIBLKFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/ARIBLK.TTF'));
    final EBGaramondBoldFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond-Bold.ttf'));
    final EBGaramondFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond.ttf'));
    final ebgaramondBold =
        pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond-Bold.ttf'));

    final PdfColor backgroundColor = PdfColor(0, 0, 0);

    final  leftColumnWidgets = generateLeftColumnWidgets( resume, EBGaramondBoldFont, EBGaramondFont, backgroundColor);
    final rightColumnWidgets = generateRightColumnWidgets( resume, emailIcon, phoneIcon, addressIcon, wabIcon, backgroundColor);


    final profileSection = leftColumnWidgets['widgets']!;
    final remainingWidgets = [
      ...leftColumnWidgets['profileSection']!,
      ...leftColumnWidgets['profile']!,
      ...leftColumnWidgets['education']!,
      ...leftColumnWidgets['experience']!,
      ...leftColumnWidgets['projects']!,
      ...leftColumnWidgets['certifications']!,
    ];

    final profileHeight = profileSection.fold<double>(
      0.0, (sum, w) => sum + estimateWidgetHeight(w),
    );

    final maxHeight = 1000.0;
    final leftPages = paginateWidgets(remainingWidgets, maxHeight);
    final rightPages = paginateWidgets(rightColumnWidgets, maxHeight - profileHeight);
    final totalPages = max(leftPages.length, rightPages.length);

    if (leftPages.isNotEmpty) {
      leftPages[0].insertAll(0, profileSection);
    } else {
      leftPages.add([...profileSection]);
    }

    while (rightPages.length < totalPages) {
      rightPages.add([]);
    }
    while (leftPages.length < totalPages) {
      leftPages.add([]);
    }

    for (int i = 0; i < totalPages; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: PdfPageFormat.a4.width - 170,
                padding: pw.EdgeInsets.only(left: 20, right: 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: i < leftPages.length ? leftPages[i] : [],
                ),
              ),
              pw.Container(
                width: 170,
                color: backgroundColor,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: i < rightPages.length
                      ? generateRightColumnWidgets(
                          resume,
                          emailIcon,
                          phoneIcon,
                          addressIcon,
                          wabIcon,
                          backgroundColor,
                          showProfileImage: i == 0,
                        )
                      : [],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return pdf.save();
  }
}
