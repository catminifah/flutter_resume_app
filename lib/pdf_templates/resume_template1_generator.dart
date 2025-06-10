import 'package:flutter/services.dart' show rootBundle, Uint8List, ByteData;
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ResumeTemplate1Generator {
  Future<Uint8List> loadIcon(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  Future<Future<Uint8List>> generatePdfFromResume(ResumeModel resume) async {
    final pdf = pw.Document();

    final bgImageData = await rootBundle.load('images/background.jpg');
    final bgImageBytes = bgImageData.buffer.asUint8List();

    final pageWidth = PdfPageFormat.a4.width;
    final pageHeight = PdfPageFormat.a4.height;

    final emailIcon = await loadIcon('assets/icons/email.png');
    final phoneIcon = await loadIcon('assets/icons/phone.png');
    final addressIcon = await loadIcon('assets/icons/address.png');
    final wabIcon = await loadIcon('assets/icons/web.png');

    final ARIBLKFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/ARIBLK.TTF'));
    final EBGaramondBoldFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond-Bold.ttf'));
    final EBGaramondFont =
        pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond.ttf'));

    final languages = List.generate(
      resume.languages.length,
      (index) => {
        'name': resume.languages[index].language.trim(),
        'level': resume.languages[index].proficiency.trim(),
      },
    );

    List<Map<String, String>> getProjects() {
      final List<Map<String, String>> projects = [];
      for (int i = 0; i < resume.projects.length; i++) {
        projects.add({
          'title': resume.projects[i].name.trim(),
          'description': resume.projects[i].description.trim(),
          'link': resume.projects[i].link.trim(),
          'tech': resume.projects[i].tech.trim(),
        });
      }
      return projects;
    }

    List<Map<String, String>> getCertifications() {
      final List<Map<String, String>> certifications = [];
      for (int i = 0; i < resume.certifications.length; i++) {
        certifications.add({
          'title': resume.certifications[i].title.trim(),
          'issuer': resume.certifications[i].issuer.trim(),
          'date': resume.certifications[i].date.trim(),
        });
      }
      return certifications;
    }

    List<Map<String, String>> getExperiences() {
      final List<Map<String, String>> experience = [];
      for (int i = 0; i < resume.experiences.length; i++) {
        experience.add({
          'company': resume.experiences[i].company.trim(),
          'position': resume.experiences[i].position.trim(),
          'startDate': resume.experiences[i].startDate.trim(),
          'endDate': resume.experiences[i].endDate.trim(),
          'description': resume.experiences[i].description.trim(),
        });
      }
      return experience;
    }

    final projects = getProjects();
    final certifications = getCertifications();
    final experiences = getExperiences();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(pageWidth, pageHeight),
        build: (context) => pw.Container(
          padding: pw.EdgeInsets.all(0),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column - Profile & Skills
              pw.Container(
                width: 200,
                //color: PdfColors.blue100,
                //padding: pw.EdgeInsets.all(10),
                child: pw.Stack(children: [
                  pw.Positioned.fill(
                    child: pw.CustomPaint(
                      painter: (PdfGraphics canvas, PdfPoint size) {
                        final colors = [
                          PdfColor.fromInt(0xFFE2E2B6), // #E2E2B6
                          PdfColor.fromInt(0xFF6EACDA), // #6EACDA
                          PdfColor.fromInt(0xFF03346E), // #03346E
                          PdfColor.fromInt(0xFF021526), // #021526
                        ];

                        final steps = colors.length - 1;
                        final segmentHeight = size.y / steps;

                        for (int i = 0; i < steps; i++) {
                          for (double y = 0; y < segmentHeight; y++) {
                            final t = y / segmentHeight;
                            final r = colors[i].red +
                                t * (colors[i + 1].red - colors[i].red);
                            final g = colors[i].green +
                                t * (colors[i + 1].green - colors[i].green);
                            final b = colors[i].blue +
                                t * (colors[i + 1].blue - colors[i].blue);

                            canvas
                              ..setFillColor(PdfColor(r, g, b))
                              ..drawRect(0, i * segmentHeight + y, size.x, 1)
                              ..fillPath();
                          }
                        }
                      },
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Profile Image
                        if (resume.profileImage != null)
                          pw.Center(
                            child: pw.Container(
                              width: 120,
                              height: 120,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                border: pw.Border.all(
                                    color: PdfColors.white, width: 2),
                                //color: PdfColors.white,
                              ),
                              child: pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Container(
                                  width: 110,
                                  height: 110,
                                  decoration: pw.BoxDecoration(
                                    shape: pw.BoxShape.circle,
                                    //color: PdfColors.blue100,
                                  ),
                                  child: pw.Padding(
                                    padding: pw.EdgeInsets.all(5),
                                    child: pw.ClipOval(
                                      child: pw.Container(
                                        width: 100,
                                        height: 100,
                                        child: pw.Image(
                                          pw.MemoryImage(resume.profileImage!),
                                          fit: pw.BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        pw.SizedBox(height: 10),
                        // Name
                        pw.Text(
                          resume.firstname.isNotEmpty
                              ? '${resume.firstname[0].toUpperCase()}${resume.firstname.substring(1)}'
                              : '',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                            font: ARIBLKFont,
                          ),
                          softWrap: true,
                        ),
                        pw.Text(
                          resume.lastname.isNotEmpty
                              ? '${resume.lastname[0].toUpperCase()}${resume.lastname.substring(1)}'
                              : '',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                            font: ARIBLKFont,
                          ),
                          softWrap: true,
                        ),
                        if (resume.lastname.isEmpty && resume.firstname.isNotEmpty || resume.firstname.isNotEmpty) ...[
                          pw.SizedBox(height: 10),
                          pw.Divider(thickness: 1, color: PdfColors.white),
                        ],

                        // Email
                        if (resume.email.isNotEmpty) ...[
                          pw.Row(
                            children: [
                              pw.Image(pw.MemoryImage(emailIcon),
                                  width: 12, height: 12),
                              pw.SizedBox(width: 5),
                              pw.Text(
                                resume.email,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.white,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                        ],

                        // NumberPhone
                        if (resume.phoneNumber.isNotEmpty) ...[
                          pw.Row(
                            children: [
                              pw.Image(pw.MemoryImage(phoneIcon),
                                  width: 12, height: 12),
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
                              pw.Image(pw.MemoryImage(addressIcon),
                                  width: 12, height: 12),
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

                        //pw.Divider(thickness: 1, color: PdfColors.white),

                        if (resume.websites.isNotEmpty) ...[
                          ...resume.websites.asMap().entries.map((entry) {
                            int index = entry.key;
                            String website = entry.value;

                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                /*pw.Text('Website Title: ${titleController.text}',
                                style: pw.TextStyle(fontSize: 10)),*/
                                if (website.isNotEmpty)
                                  pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
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
                                    style: pw.TextStyle( fontSize: 10, color: PdfColors.white),
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
                          final bool isCategoryEmpty = categoryTitle.isEmpty && allSkillsEmpty;

                          if (isCategoryEmpty) return pw.SizedBox();

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
                              if (categoryTitle.isNotEmpty)
                                pw.SizedBox(height: 5),
                              ...skills.map((skillController) {
                                final skillText = skillController.trim();
                                if (skillText.isEmpty) return pw.SizedBox();

                                return pw.Padding(
                                  padding: const pw.EdgeInsets.only( left: 10, bottom: 2),
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
                                            fontSize: 10,
                                            color: PdfColors.white),
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
                ]),
              ),

              // Right Column - PROFILLE & Experience & Education
              pw.Expanded(
                child: pw.Container(
                  padding: pw.EdgeInsets.only(left: 20, right: 20),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 20),
                      // PROFILLE
                      if (resume.aboutMe.isNotEmpty)
                        pw.Text('PROFILLE',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue)),
                      if (resume.aboutMe.isNotEmpty) ...[
                        pw.SizedBox(height: 5),
                        pw.Text(resume.aboutMe,
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.grey)),
                        pw.SizedBox(height: 10),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                      ],

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
                                color: PdfColors.blue)),
                        pw.SizedBox(height: 5),
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
                                if (resume.educationList[index].startDate.trim().isNotEmpty || resume.educationList[index].endDate.trim().isNotEmpty)
                                  pw.Text(
                                    resume.educationList[index].startDate.trim().isNotEmpty && resume.educationList[index].endDate.trim().isNotEmpty
                                        ? '${resume.educationList[index].startDate.trim()} - ${resume.educationList[index].endDate.trim()}'
                                        : resume.educationList[index].startDate.trim().isNotEmpty
                                            ? resume.educationList[index].startDate.trim()
                                            : resume.educationList[index].endDate.trim(),
                                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
                                  ),
                                pw.SizedBox(width: 5),
                              ]),
                              /*if (_startEducation[index].text.isNotEmpty||_endEducation[index].text.isNotEmpty)
                            pw.SizedBox(height: 5),*/
                              /*if (_startEducation[index].text.isNotEmpty||_endEducation[index].text.isNotEmpty)
                            pw.SizedBox(height: 5),*/
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
                      ],

                      if (resume.educationList.isNotEmpty &&
                          resume.educationList.any((edu) =>
                              edu.startDate.trim().isNotEmpty ||
                              edu.endDate.trim().isNotEmpty ||
                              edu.school.trim().isNotEmpty ||
                              edu.degree.trim().isNotEmpty))
                        pw.Divider(thickness: 1, color: PdfColors.grey),

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
                                color: PdfColors.blue)),
                        pw.SizedBox(height: 5),
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
                                  style: pw.TextStyle(
                                      fontSize: 8, color: PdfColors.grey),
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
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                      ],

                      //Project
                      if (projects
                          .any((p) => p.values.any((v) => v.isNotEmpty))) ...[
                        pw.Text('Projects',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue)),
                        pw.SizedBox(height: 5),
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
                                        fontSize: 10,
                                        color: PdfColors.grey800)),
                              if (project['description']!.isNotEmpty)
                                pw.Text(project['description']!,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey800)),
                              if (project['link']!.isNotEmpty)
                                pw.Text('${project['link']}',
                                    style: pw.TextStyle(
                                        fontSize: 10, color: PdfColors.blue)),
                              pw.SizedBox(height: 10),
                            ],
                          );
                        }),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                      ],
                      // Certifications
                      if (certifications
                          .any((c) => c.values.any((v) => v.isNotEmpty))) ...[
                        pw.Text('Certifications',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue)),
                        pw.SizedBox(height: 5),
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
                                        fontSize: 10,
                                        color: PdfColors.grey800)),
                              pw.SizedBox(height: 10),
                            ],
                          );
                        }),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    /*// Save PDF to file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/resume.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;*/
    return pdf.save();
  }
}
