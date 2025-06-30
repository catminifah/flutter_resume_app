import 'dart:math';
import 'package:flutter/services.dart' show rootBundle, Uint8List, ByteData;
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ResumeTemplate1Generator {
  Future<Uint8List> loadIcon(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  List<pw.Widget> generateLeftColumnWidgets( ResumeModel resume,  pw.Font ARIBLKFont, Uint8List emailIcon, Uint8List phoneIcon,Uint8List addressIcon, Uint8List wabIcon, {bool showProfileImage = false}) {
    final languages = List.generate(
      resume.languages.length,
      (index) => {
        'name': resume.languages[index].language.trim(),
        'level': resume.languages[index].proficiency.trim(),
      },
    );
    final widgets = <pw.Widget>[];
    if (showProfileImage && resume.profileImage != null) {
      if (resume.profileImage != null) {
        widgets.addAll([
          pw.Center(
            child: pw.Container(
              width: 120,
              height: 120,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                border: pw.Border.all(color: PdfColors.white, width: 2),
              ),
              child: pw.Padding(
                padding: pw.EdgeInsets.all(2),
                child: pw.Container(
                  width: 110,
                  height: 110,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
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
        ]);
      }
    }

    widgets.addAll([
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
      if (resume.lastname.isEmpty && resume.firstname.isNotEmpty ||
          resume.firstname.isNotEmpty) ...[
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 1, color: PdfColors.white),
      ],

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
                    pw.Image(pw.MemoryImage(wabIcon), width: 12, height: 12),
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
      
      if (resume.email.isNotEmpty || resume.phoneNumber.isNotEmpty || resume.address.isNotEmpty || resume.websites.isNotEmpty) ...[
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
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.white),
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
                      style: pw.TextStyle(fontSize: 10, color: PdfColors.white),
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
    ]);

    return widgets;
  }

  List<pw.Widget> generateRightColumnWidgets(ResumeModel resume, pw.Font EBGaramondBoldFont, pw.Font EBGaramondFont) {
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
    return [
      // Right Column - PROFILLE & Experience & Education
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
        pw.Text(resume.aboutMe, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
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
                  style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
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
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              pw.SizedBox(height: 10),
            ],
          );
        }),
        pw.Divider(thickness: 1, color: PdfColors.grey),
      ],

      //Project
      if (projects.any((p) => p.values.any((v) => v.isNotEmpty))) ...[
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
                    style:
                        pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              if (project['description']!.isNotEmpty)
                pw.Text(project['description']!,
                    style:
                        pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              if (project['link']!.isNotEmpty)
                pw.Text('${project['link']}',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.blue)),
              pw.SizedBox(height: 10),
            ],
          );
        }),
        pw.Divider(thickness: 1, color: PdfColors.grey),
      ],
      // Certifications
      if (certifications.any((c) => c.values.any((v) => v.isNotEmpty))) ...[
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
                      style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                pw.SizedBox(width: 5),
              ]),
              if (cert['issuer']!.isNotEmpty)
                pw.Text('${cert['issuer']}',
                    style:
                        pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              pw.SizedBox(height: 10),
            ],
          );
        }),
        pw.Divider(thickness: 1, color: PdfColors.grey),
      ]
         
    ];
  }

  double estimateWidgetHeight(pw.Widget widget) {
    if (widget is pw.SizedBox) {
      try {
        final height = (widget as dynamic).height;
        if (height is double) return height;
      } catch (_) {}
      return 10;
    }

    if (widget is pw.Text) {
      final text = (widget as dynamic).text;
      final lines = text.toString().split('\n').length;
      return 14.0 * lines;
    }

    if (widget is pw.Divider) return 5;
    if (widget is pw.Row) return 20;
    if (widget is pw.Column) return 25;
    if (widget is pw.Image) return 100;

    return 20;
  }

  List<List<pw.Widget>> paginateWidgets(
      List<pw.Widget> widgets, double maxHeightPerPage) {
    final List<List<pw.Widget>> pages = [];
    List<pw.Widget> currentPage = [];
    double currentHeight = 0;

    for (var widget in widgets) {
      final double estimatedHeight = estimateWidgetHeight(widget);

      if (currentHeight + estimatedHeight > maxHeightPerPage &&
          currentPage.isNotEmpty) {
        pages.add(currentPage);
        currentPage = [];
        currentHeight = 0;
      }

      currentPage.add(widget);
      currentHeight += estimatedHeight;
    }

    if (currentPage.isNotEmpty) {
      pages.add(currentPage);
    }

    return pages;
  }

  Future<Future<Uint8List>> generatePdfFromResume(ResumeModel resume) async {
    final pdf = pw.Document();

    // final bgImageData = await rootBundle.load('images/background.jpg');
    // final bgImageBytes = bgImageData.buffer.asUint8List();

    final pageWidth = PdfPageFormat.a4.width;
    final pageHeight = PdfPageFormat.a4.height;

    final emailIcon = await loadIcon('assets/icons/email_white.png');
    final phoneIcon = await loadIcon('assets/icons/phone_white.png');
    final addressIcon = await loadIcon('assets/icons/address_white.png');
    final wabIcon = await loadIcon('assets/icons/web_white.png');

    final ARIBLKFont = pw.Font.ttf(await rootBundle.load('assets/fonts/ARIBLK.TTF'));
    final EBGaramondBoldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond-Bold.ttf'));
    final EBGaramondFont = pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond.ttf'));

    final leftColumnWidgets = generateLeftColumnWidgets( resume, ARIBLKFont, emailIcon, phoneIcon, addressIcon, wabIcon);
    final rightColumnWidgets = generateRightColumnWidgets( resume, EBGaramondBoldFont, EBGaramondFont);

    final leftPages = paginateWidgets(leftColumnWidgets, 700.0);
    final rightPages = paginateWidgets(rightColumnWidgets, 700.0);
    final totalPages = max(leftPages.length, rightPages.length);

    for (int i = 0; i < totalPages; i++) {
      final isFirstPage = i == 0;

      final profileImageWidget = (isFirstPage && resume.profileImage != null)
          ? pw.Center(
              child: pw.Container(
                width: 120,
                height: 120,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: PdfColors.white, width: 2),
                ),
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(2),
                  child: pw.Container(
                    width: 110,
                    height: 110,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
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
            )
          : null;

      final leftWidgets = i < leftPages.length ? leftPages[i] : [];

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column - Profile & Skills
              pw.Container(
                width: 200,
                child: pw.Stack(
                  children: [
                    pw.Positioned.fill(
                      child: pw.CustomPaint(
                        painter: (PdfGraphics canvas, PdfPoint size) {
                          final colors = [
                            PdfColor.fromInt(0xFFE2E2B6),
                            PdfColor.fromInt(0xFF6EACDA),
                            PdfColor.fromInt(0xFF03346E),
                            PdfColor.fromInt(0xFF021526),
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
                          if (profileImageWidget != null) ...[
                            profileImageWidget,
                            pw.SizedBox(height: 10),
                          ],
                          ...leftWidgets,
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right Column - PROFILLE & Experience & Education
              pw.Container(
                padding: pw.EdgeInsets.only(left: 20, right: 20),
                width: PdfPageFormat.a4.width - 200,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: i < rightPages.length ? rightPages[i] : [],
                ),
              ),
            ],
          ),
        ),
      );
    }


    /*final languages = List.generate(
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
                            final r = colors[i].red + t * (colors[i + 1].red - colors[i].red);
                            final g = colors[i].green + t * (colors[i + 1].green - colors[i].green);
                            final b = colors[i].blue + t * (colors[i + 1].blue - colors[i].blue);

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
                                border: pw.Border.all( color: PdfColors.white, width: 2),
                                //color: PdfColors.white,
                              ),
                              child: pw.Padding(
                                padding: pw.EdgeInsets.all(2),
                                child: pw.Container(
                                  width: 110,
                                  height: 110,
                                  decoration: pw.BoxDecoration(
                                    shape: pw.BoxShape.circle,
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

                        pw.Divider(thickness: 1, color: PdfColors.white),

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
                            style: pw.TextStyle( fontSize: 10, color: PdfColors.grey)),
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
                                  style: pw.TextStyle( fontSize: 8, color: PdfColors.grey),
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
                                  style: pw.TextStyle( fontSize: 10, color: PdfColors.grey800)),
                              pw.SizedBox(height: 10),
                            ],
                          );
                        }),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                      ],

                      //Project
                      if (projects.any((p) => p.values.any((v) => v.isNotEmpty))) ...[
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
                                    style: pw.TextStyle( fontSize: 10, color: PdfColors.blue)),
                              pw.SizedBox(height: 10),
                            ],
                          );
                        }),
                        pw.Divider(thickness: 1, color: PdfColors.grey),
                      ],
                      // Certifications
                      if (certifications.any((c) => c.values.any((v) => v.isNotEmpty))) ...[
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
                                      style: pw.TextStyle( fontSize: 8, color: PdfColors.grey)),
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
    );*/

    return pdf.save();
  }
}

// ออกแบบเทมเพลตหน้าเดียวก่อนแล้วค่อยแก้หน้าให้รองรับหลายหน้าทำเทมเพลตเดียวกันแบ่งฟังชันซ้ายขวาของข้อมูล