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

  List<pw.Widget> generateLeftColumnWidgets(
  ResumeModel resume,
  pw.Font ARIBLKFont,
  Uint8List emailIcon,
  Uint8List phoneIcon,
  Uint8List addressIcon,
  Uint8List wabIcon, {
  bool showProfileImage = false,
}) {
  final widgets = <pw.Widget>[];

  final languages = resume.languages
      .map((lang) => {
            'name': lang.language.trim(),
            'level': lang.proficiency.trim(),
          })
      .where((lang) => lang['name']!.isNotEmpty || lang['level']!.isNotEmpty)
      .toList();

  // Profile Image
  if (showProfileImage && resume.profileImage != null) {
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
            child: pw.ClipOval(
              child: pw.Image(
                pw.MemoryImage(resume.profileImage!),
                fit: pw.BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      pw.SizedBox(height: 10),
    ]);
  }

  // Name
  if (resume.firstname.isNotEmpty) {
    widgets.add(pw.Text(
      '${resume.firstname[0].toUpperCase()}${resume.firstname.substring(1)}',
      style: pw.TextStyle(
        fontSize: 22,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        font: ARIBLKFont,
      ),
    ));
  }
  if (resume.lastname.isNotEmpty) {
    widgets.add(pw.Text(
      '${resume.lastname[0].toUpperCase()}${resume.lastname.substring(1)}',
      style: pw.TextStyle(
        fontSize: 22,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        font: ARIBLKFont,
      ),
    ));
  }
  if (resume.firstname.isNotEmpty || resume.lastname.isNotEmpty) {
    widgets.addAll([
      pw.SizedBox(height: 10),
      pw.Divider(thickness: 1, color: PdfColors.white),
    ]);
  }

  // Contact Info
  if (resume.email.isNotEmpty) {
    widgets.addAll([
      pw.Row(children: [
        pw.Image(pw.MemoryImage(emailIcon), width: 12, height: 12),
        pw.SizedBox(width: 5),
        pw.Expanded(
          child: pw.Text(resume.email,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
        ),
      ]),
      pw.SizedBox(height: 5),
    ]);
  }

  if (resume.phoneNumber.isNotEmpty) {
    widgets.addAll([
      pw.Row(children: [
        pw.Image(pw.MemoryImage(phoneIcon), width: 12, height: 12),
        pw.SizedBox(width: 5),
        pw.Text(resume.phoneNumber,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
      ]),
      pw.SizedBox(height: 5),
    ]);
  }

  if (resume.address.isNotEmpty) {
    widgets.addAll([
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Image(pw.MemoryImage(addressIcon), width: 12, height: 12),
        pw.SizedBox(width: 5),
        pw.Expanded(
          child: pw.Text(resume.address,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
        ),
      ]),
      pw.SizedBox(height: 5),
    ]);
  }

  for (final website in resume.websites.where((w) => w.trim().isNotEmpty)) {
    widgets.addAll([
      pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Image(pw.MemoryImage(wabIcon), width: 12, height: 12),
        pw.SizedBox(width: 5),
        pw.Expanded(
          child: pw.Text(website.trim(),
              style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
        ),
      ]),
      pw.SizedBox(height: 5),
    ]);
  }

  if (resume.email.isNotEmpty ||
      resume.phoneNumber.isNotEmpty ||
      resume.address.isNotEmpty ||
      resume.websites.any((w) => w.trim().isNotEmpty)) {
    widgets.addAll([
      pw.SizedBox(height: 5),
      pw.Divider(thickness: 1, color: PdfColors.white),
    ]);
  }

  // Languages
  if (languages.isNotEmpty) {
    widgets.addAll([
      pw.Text('Languages',
          style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white)),
      pw.SizedBox(height: 5),
    ]);

    for (final lang in languages) {
      final name = lang['name']!;
      final level = lang['level']!;
      final display = level.isNotEmpty ? '$name ($level)' : name;

      widgets.add(
        pw.Padding(
          padding: pw.EdgeInsets.only(left: 10, bottom: 2),
          child: pw.Row(children: [
            pw.Container(
              width: 3,
              height: 3,
              decoration:
                  pw.BoxDecoration(shape: pw.BoxShape.circle, color: PdfColors.white),
            ),
            pw.SizedBox(width: 5),
            pw.Text(display,
                style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
          ]),
        ),
      );
    }

    widgets.add(pw.SizedBox(height: 10));
  }

  // Skills
  for (final skillCategory in resume.skills) {
      final title = skillCategory.category.trim();
      final skills =
          skillCategory.items.where((s) => s.trim().isNotEmpty).toList();

      if (title.isEmpty && skills.isEmpty) continue;

      if (title.isNotEmpty) {
        widgets.addAll([
          pw.Text(title,
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white)),
          pw.SizedBox(height: 5),
        ]);
      }

      for (final skill in skills) {
        widgets.add(
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 10, bottom: 2),
            child: pw.Row(children: [
              pw.Container(
                width: 3,
                height: 3,
                decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle, color: PdfColors.white),
              ),
              pw.SizedBox(width: 5),
              pw.Text(skill,
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.white)),
            ]),
          ),
        );
      }

      widgets.add(pw.SizedBox(height: 10));
    }

    widgets.add(pw.SizedBox(height: 5));

    return widgets;
  }

  List<pw.Widget> splitTextToParagraphs(
    String text, {
    double fontSize = 10,
    PdfColor color = PdfColors.grey800,
    pw.Font? font,
  }) {
    const int maxLength = 100;
    final paragraphs = <pw.Widget>[];

    for (int i = 0; i < text.length; i += maxLength) {
      final end = (i + maxLength > text.length) ? text.length : i + maxLength;
      final chunk = text.substring(i, end);
      paragraphs.add(
        pw.Text(chunk,
            style: pw.TextStyle(fontSize: fontSize, color: color, font: font)),
      );
    }

    return paragraphs;
  }

  Map<String, List<pw.Widget>> generateRightColumnWidgets(
    ResumeModel resume,
    pw.Font EBGaramondBoldFont,
    pw.Font EBGaramondFont,
  ) {
    final profileSection = <pw.Widget>[];
    final educationSection = <pw.Widget>[];
    final experienceSection = <pw.Widget>[];
    final projectSection = <pw.Widget>[];
    final certificationSection = <pw.Widget>[];

    // PROFILE
    if (resume.aboutMe.isNotEmpty) {
      profileSection.addAll([
        pw.Text('PROFILE',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue)),
        pw.SizedBox(height: 5),
        ...splitTextToParagraphs(resume.aboutMe,
            font: EBGaramondFont, fontSize: 10, color: PdfColors.grey),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 1, color: PdfColors.grey),
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
                color: PdfColors.blue)),
        pw.SizedBox(height: 5),
      ]);

      for (final edu in resume.educationList) {
        if (edu.school.trim().isEmpty && edu.degree.trim().isEmpty) continue;

        final duration =
            '${edu.startDate.trim()} - ${edu.endDate.trim().isEmpty ? 'Present' : edu.endDate.trim()}';

        if (edu.school.isNotEmpty) {
          educationSection.add(pw.Text(edu.school,
              style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  font: EBGaramondBoldFont)));
        }

        if (duration.isNotEmpty) {
          educationSection.add(pw.Text(duration,
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)));
        }

        if (edu.degree.isNotEmpty) {
          educationSection.add(pw.Text(edu.degree,
              style: pw.TextStyle(
                  fontSize: 13,
                  color: PdfColors.grey900,
                  font: EBGaramondFont)));
        }

        educationSection.add(pw.SizedBox(height: 10));
      }

      educationSection.add(pw.Divider(thickness: 1, color: PdfColors.grey));
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
                color: PdfColors.blue)),
        pw.SizedBox(height: 5),
      ]);

      for (final work in resume.experiences) {
        final duration =
            '${work.startDate.trim()} - ${work.endDate.trim().isEmpty ? 'Present' : work.endDate.trim()}';

        experienceSection.add(pw.Text(work.company,
            style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                font: EBGaramondBoldFont)));

        experienceSection.add(pw.Text(duration,
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)));

        if (work.position.trim().isNotEmpty) {
          experienceSection.add(pw.Text(work.position,
              style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey900,
                  font: EBGaramondFont)));
        }

        if (work.description.trim().isNotEmpty) {
          experienceSection.addAll([
            ...splitTextToParagraphs(work.description,
                fontSize: 10, color: PdfColors.grey800),
          ]);
          experienceSection.add(pw.SizedBox(height: 10));
        }
      }

      experienceSection.add(pw.Divider(thickness: 1, color: PdfColors.grey));
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
                color: PdfColors.blue)),
        pw.SizedBox(height: 5),
      ]);

      for (final p in projects) {
        if (p['title']!.isNotEmpty) {
          projectSection.add(
            pw.Text(p['title']!,
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    font: EBGaramondBoldFont)),
          );
        }

        if (p['tech']!.isNotEmpty) {
          projectSection.add(pw.Text(p['tech']!,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800)));
        }

        if (p['description']!.isNotEmpty) {
          projectSection.addAll([
            ...splitTextToParagraphs(p['description']!,
                fontSize: 10, color: PdfColors.grey800),
          ]);
        }

        if (p['link']!.isNotEmpty) {
          projectSection.add(pw.Text(p['link']!,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.blue)));
          projectSection.add(pw.SizedBox(height: 10));
        }
      }

      projectSection.add(pw.Divider(thickness: 1, color: PdfColors.grey));
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
                color: PdfColors.blue)),
        pw.SizedBox(height: 5),
      ]);

      for (final c in certifications) {
        if (c['title']!.isNotEmpty) {
          certificationSection.add(pw.Text(c['title']!,
              style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  font: EBGaramondBoldFont)));
        }

        if (c['date']!.isNotEmpty) {
          certificationSection.add(pw.Text(c['date']!,
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey)));
        }

        if (c['issuer']!.isNotEmpty) {
          certificationSection.add(pw.Text(c['issuer']!,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800)));
          certificationSection.add(pw.SizedBox(height: 10));
        }
      }

      certificationSection.add(pw.Divider(thickness: 1, color: PdfColors.grey));
    }

    return {
      'profile': profileSection,
      'education': educationSection,
      'experience': experienceSection,
      'projects': projectSection,
      'certifications': certificationSection,
    };
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
      try {
        final text = (widget as dynamic).text.toString();
        final style = (widget as dynamic).style;
        final fontSize = style?.fontSize ?? 12.0;
        final lineCount = (text.length / 80).ceil();
        return fontSize * lineCount + 4;
      } catch (_) {
        return 16.0;
      }
    }

    if (widget is pw.Row) {
      try {
        final children = (widget as dynamic).children;
        final heights = children.map(estimateWidgetHeight).toList();
        return heights.reduce((a, b) => a > b ? a : b) + 4;
      } catch (_) {
        return 20.0;
      }
    }

    if (widget is pw.Column) {
      try {
        final children = (widget as dynamic).children;
        return children.fold<double>(
            0.0, (sum, child) => sum + estimateWidgetHeight(child));
      } catch (_) {
        return 40.0;
      }
    }

    if (widget is pw.Padding) {
      try {
        final child = (widget as dynamic).child;
        final padding = (widget as dynamic).padding as pw.EdgeInsets;
        return estimateWidgetHeight(child) + padding.top + padding.bottom;
      } catch (_) {
        return 20.0;
      }
    }

    if (widget is pw.Divider) return 8;

    return 20.0;
  }

  List<List<pw.Widget>> paginateWidgets( List<pw.Widget> widgets, double maxHeightPerPage) {
    final List<List<pw.Widget>> pages = [];
    List<pw.Widget> currentPage = [];
    double currentHeight = 0;

    for (var widget in widgets) {
      final double estimatedHeight = estimateWidgetHeight(widget);

      if (estimatedHeight > maxHeightPerPage) {
        print('⚠️ Widget estimated too tall for a single page: $estimatedHeight > $maxHeightPerPage');
      }

      if (currentHeight + estimatedHeight > maxHeightPerPage && currentPage.isNotEmpty) {
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

    final profileSection = rightColumnWidgets['profile']!;
    final remainingWidgets = [
      ...rightColumnWidgets['education']!,
      ...rightColumnWidgets['experience']!,
      ...rightColumnWidgets['projects']!,
      ...rightColumnWidgets['certifications']!,
    ];

    final profileHeight = profileSection.fold<double>(
      0.0, (sum, w) => sum + estimateWidgetHeight(w),
    );

    final maxHeight = 1000.0;
    final leftPages = paginateWidgets(leftColumnWidgets, maxHeight);
    final rightPages = paginateWidgets(remainingWidgets, maxHeight - profileHeight);
    final totalPages = max(leftPages.length, rightPages.length);

    if (rightPages.isNotEmpty) {
      rightPages[0].insertAll(0, profileSection);
    } else {
      rightPages.add([...profileSection]);
    }

    while (leftPages.length < totalPages) {
      leftPages.add([]);
    }
    while (rightPages.length < totalPages) {
      rightPages.add([]);
    }

    for (int i = 0; i < totalPages; i++) {
      print('>>> Rendering page $i');
      print('   Left: ${leftPages[i].length} widgets');
      print('   Right: ${rightPages[i].length} widgets');
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

      final leftContent = <pw.Widget>[
        if (profileImageWidget != null) ...[
          profileImageWidget,
          pw.SizedBox(height: 10),
        ],
        ...((i < leftPages.length) ? leftPages[i] : []),
      ];
      final List<pw.Widget> rightContent = i < rightPages.length ? rightPages[i] : [];

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column with Gradient Background
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
                        children: leftContent,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Column
              pw.Container(
                padding: pw.EdgeInsets.only(left: 20, right: 20, top: 20),
                width: PdfPageFormat.a4.width - 200,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: rightContent,
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