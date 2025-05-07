import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ResumeApp());
}

class ResumeApp extends StatelessWidget {
  const ResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Resume',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ResumeHomePage(),
    );
  }
}

class ResumeHomePage extends StatefulWidget {
  const ResumeHomePage({super.key});

  @override
  State<ResumeHomePage> createState() => _ResumeHomePageState();
}

class _ResumeHomePageState extends State<ResumeHomePage> {
  // Personal Information
  final TextEditingController _FirstnameController = TextEditingController();
  final TextEditingController _LastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  // Personal Websites
  final List<TextEditingController> _websiteControllers = [];
  List<TextEditingController> _websiteTitles = [];

  // Skills
  final List<String> _skillCategoryOptions = [
    'Programming',
    'Tools',
    'Soft Skills',
    'Hard Skills',
    'Languages',
    'Other',
    'Custom'
  ];

  final List<TextEditingController> __skillTitles = [];
  final List<List<TextEditingController>> _skillControllers = [];
  final List<String?> _selectedSkillCategories = [];
  final List<bool> _isCustomCategory = [];

  // Work Experience
  final List<TextEditingController> _ExperienceControllers = [];
  final List<TextEditingController> _companyName = [];
  final List<TextEditingController> _jobTitle = [];
  final List<TextEditingController> _startdatejob = [];
  final List<TextEditingController> _enddatejob = [];
  final List<TextEditingController> _detailjob = [];

  // Education
  final List<TextEditingController> _educationControllers = [];
  final List<TextEditingController> _degreeTitle = [];
  final List<TextEditingController> _universityName = [];
  final List<TextEditingController> _startEducation = [];
  final List<TextEditingController> _endEducation = [];

  // Projects
  final List<TextEditingController> _projectTitleControllers = [];
  final List<TextEditingController> _projectDescriptionControllers = [];
  final List<TextEditingController> _projectLinkControllers = [];
  final List<TextEditingController> _projectTechControllers = [];

  // Certifications
  final List<TextEditingController> _certificationTitleControllers = [];
  final List<TextEditingController> _certificationIssuerControllers = [];
  final List<TextEditingController> _certificationDateControllers = [];

  // Languages
  final List<TextEditingController> _languageNameControllers = [];
  final List<TextEditingController> _languageLevelControllers = [];

  // Profile Image
  File? _profileImage;

  // Resume Data Storage
  final ResumeDataStorage _storage = ResumeDataStorage();
  bool _isButton1Highlighted = false;
  bool _isButton2Highlighted = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    _FirstnameController.text = await _storage.loadData('name') ?? '';
    _LastnameController.text = await _storage.loadData('lastname') ?? '';
    _emailController.text = await _storage.loadData('email') ?? '';
    _addressController.text = await _storage.loadData('address') ?? '';
    _phoneNumberController.text = await _storage.loadData('phone') ?? '';
    _aboutMeController.text = await _storage.loadData('aboutme') ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<Uint8List> loadIcon(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  Future<File> _generatePdf() async {
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
      _languageNameControllers.length,
      (index) => {
        'name': _languageNameControllers[index].text.trim(),
        'level': _languageLevelControllers[index].text.trim(),
      },
    );
    final projects = getProjects();
    final certifications = getCertifications();

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
                        if (_profileImage != null)
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
                                          pw.MemoryImage(
                                              _profileImage!.readAsBytesSync()),
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
                          _FirstnameController.text.isNotEmpty
                              ? '${_FirstnameController.text[0].toUpperCase()}${_FirstnameController.text.substring(1)}'
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
                          _LastnameController.text.isNotEmpty
                              ? '${_LastnameController.text[0].toUpperCase()}${_LastnameController.text.substring(1)}'
                              : '',
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                            font: ARIBLKFont,
                          ),
                          softWrap: true,
                        ),
                        if (_LastnameController.text.isNotEmpty &&
                                _FirstnameController.text.isNotEmpty ||
                            _FirstnameController.text.isNotEmpty)
                          pw.SizedBox(height: 10),
                        if (_LastnameController.text.isNotEmpty &&
                                _FirstnameController.text.isNotEmpty ||
                            _FirstnameController.text.isNotEmpty)
                          pw.Divider(thickness: 1, color: PdfColors.white),
                        // Email
                        if (_emailController.text.isNotEmpty) ...[
                          pw.Row(
                            children: [
                              pw.Image(pw.MemoryImage(emailIcon),
                                  width: 12, height: 12),
                              pw.SizedBox(width: 5),
                              pw.Text(
                                _emailController.text,
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
                        if (_phoneNumberController.text.isNotEmpty) ...[
                          pw.Row(
                            children: [
                              pw.Image(pw.MemoryImage(phoneIcon),
                                  width: 12, height: 12),
                              pw.SizedBox(width: 5),
                              pw.Text(_phoneNumberController.text,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: PdfColors.white,
                                  )),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                        ],

                        // Address
                        if (_addressController.text.isNotEmpty) ...[
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Image(pw.MemoryImage(addressIcon),
                                  width: 12, height: 12),
                              pw.SizedBox(width: 5),
                              pw.Expanded(
                                child: pw.Text(
                                  _addressController.text,
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

                        if (_websiteControllers.isNotEmpty) ...[
                          ..._websiteControllers.asMap().entries.map((entry) {
                            int index = entry.key;
                            TextEditingController controller = entry.value;
                            TextEditingController titleController =
                                _websiteTitles[index];

                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                /*pw.Text('Website Title: ${titleController.text}',
                                style: pw.TextStyle(fontSize: 10)),*/
                                if (controller.text.isNotEmpty)
                                  pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Image(pw.MemoryImage(wabIcon),
                                          width: 12, height: 12),
                                      pw.SizedBox(width: 5),
                                      pw.Expanded(
                                        child: pw.Text(
                                          controller.text,
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
                        if (languages
                            .any((l) => l.values.any((v) => v.isNotEmpty))) ...[
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
                            if (name.isEmpty && level.isEmpty)
                              return pw.SizedBox();

                            return pw.Padding(
                              padding:
                                  const pw.EdgeInsets.only(left: 10, bottom: 2),
                              child: pw.Row(
                                children: [
                                  pw.Container(
                                    width: 5,
                                    height: 5,
                                    margin: const pw.EdgeInsets.only(top: 4),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.blueGrey900,
                                      shape: pw.BoxShape.circle,
                                    ),
                                  ),
                                  pw.SizedBox(width: 5),
                                  pw.Text(
                                    level.isNotEmpty ? '$name ($level)' : name,
                                    style: pw.TextStyle(
                                        fontSize: 10, color: PdfColors.white),
                                  ),
                                ],
                              ),
                            );
                          }),
                          pw.SizedBox(height: 10),
                        ],

                        // Skills Summary
                        ..._skillControllers.asMap().entries.map((entry) {
                          final int categoryIndex = entry.key;
                          final List<TextEditingController> skills =
                              entry.value;
                          final String categoryTitle =
                              __skillTitles[categoryIndex].text.trim();
                          final bool allSkillsEmpty = skills.every(
                              (controller) => controller.text.trim().isEmpty);
                          final bool isCategoryEmpty =
                              categoryTitle.isEmpty && allSkillsEmpty;

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
                                final skillText = skillController.text.trim();
                                if (skillText.isEmpty) return pw.SizedBox();

                                return pw.Padding(
                                  padding: const pw.EdgeInsets.only(
                                      left: 10, bottom: 2),
                                  child: pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 5,
                                        height: 5,
                                        margin:
                                            const pw.EdgeInsets.only(top: 4),
                                        decoration: pw.BoxDecoration(
                                          color: PdfColors.blueGrey900,
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
                      if (_aboutMeController.text.isNotEmpty)
                        pw.Text('PROFILLE',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue)),
                      if (_aboutMeController.text.isNotEmpty)
                        pw.SizedBox(height: 5),
                      if (_aboutMeController.text.isNotEmpty)
                        pw.Text(_aboutMeController.text,
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.grey)),
                      if (_aboutMeController.text.isNotEmpty)
                        pw.SizedBox(height: 10),

                      if (_aboutMeController.text.isNotEmpty)
                        pw.Divider(thickness: 1, color: PdfColors.grey),

                      // Education
                      if (_educationControllers.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _startEducation.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _endEducation.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _universityName.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _degreeTitle.any(
                              (controller) => controller.text.isNotEmpty)) ...[
                        pw.Text('Education',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue)),
                        pw.SizedBox(height: 5),
                        ..._educationControllers.asMap().entries.map((entry) {
                          int index = entry.key;
                          return pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(children: [
                                if (_startEducation[index]
                                        .text
                                        .trim()
                                        .isNotEmpty ||
                                    _endEducation[index].text.trim().isNotEmpty)
                                  pw.Text(
                                    _startEducation[index]
                                                .text
                                                .trim()
                                                .isNotEmpty &&
                                            _endEducation[index]
                                                .text
                                                .trim()
                                                .isNotEmpty
                                        ? '${_startEducation[index].text.trim()} - ${_endEducation[index].text.trim()}'
                                        : _startEducation[index]
                                                .text
                                                .trim()
                                                .isNotEmpty
                                            ? _startEducation[index].text.trim()
                                            : _endEducation[index].text.trim(),
                                    style: pw.TextStyle(
                                        fontSize: 8, color: PdfColors.grey),
                                  ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  _startEducation[index].text.isNotEmpty
                                      ? '${_startEducation[index].text} - ${_endEducation[index].text}'
                                      : _endEducation[index].text,
                                  style: pw.TextStyle(
                                      fontSize: 8, color: PdfColors.grey),
                                ),
                              ]),
                              /*if (_startEducation[index].text.isNotEmpty||_endEducation[index].text.isNotEmpty)
                            pw.SizedBox(height: 5),*/
                              /*if (_startEducation[index].text.isNotEmpty||_endEducation[index].text.isNotEmpty)
                            pw.SizedBox(height: 5),*/
                              if (_degreeTitle[index].text.isNotEmpty)
                                pw.Text(_degreeTitle[index].text,
                                    style: pw.TextStyle(
                                        fontSize: 13,
                                        color: PdfColors.grey900,
                                        font: EBGaramondFont)),
                              pw.SizedBox(height: 10),
                            ],
                          );
                        }),
                      ],

                      if (_educationControllers.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _startEducation.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _endEducation.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _universityName.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _degreeTitle
                              .any((controller) => controller.text.isNotEmpty))
                        pw.Divider(thickness: 1, color: PdfColors.grey),

                      // Work Experience
                      if (_ExperienceControllers.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _jobTitle.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _companyName.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _startdatejob.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _enddatejob.any(
                              (controller) => controller.text.isNotEmpty) ||
                          _detailjob.any(
                              (controller) => controller.text.isNotEmpty)) ...[
                        pw.Text('Work Experience',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue)),
                        pw.SizedBox(height: 5),
                        ..._ExperienceControllers.asMap().entries.map((entry) {
                          int index = entry.key;
                          final safeIndex =
                              index < _companyName.length ? index : 0;
                          return pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(children: [
                                pw.Text(_companyName[safeIndex].text,
                                    style: pw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: pw.FontWeight.bold,
                                        font: EBGaramondBoldFont)),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                  '${_startdatejob[safeIndex].text} - ${_enddatejob[safeIndex].text.isEmpty ? 'PRESENT' : _enddatejob[safeIndex].text}',
                                  style: pw.TextStyle(
                                      fontSize: 8, color: PdfColors.grey),
                                ),
                              ]),
                              pw.Text(_jobTitle[safeIndex].text,
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.normal,
                                      color: PdfColors.grey900,
                                      font: EBGaramondFont)),
                              pw.SizedBox(width: 5),
                              pw.Text(_detailjob[safeIndex].text,
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
                                pw.Text('Tech: ${project['tech']}',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey800)),
                              if (project['description']!.isNotEmpty)
                                pw.Text(project['description']!,
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey800)),
                              if (project['link']!.isNotEmpty)
                                pw.Text('Link: ${project['link']}',
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
                              if (cert['title']!.isNotEmpty)
                                pw.Text(cert['title']!,
                                    style: pw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: pw.FontWeight.bold,
                                        font: EBGaramondBoldFont)),
                              if (cert['issuer']!.isNotEmpty)
                                pw.Text('Issued by: ${cert['issuer']}',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.grey800)),
                              if (cert['date']!.isNotEmpty)
                                pw.Text('Date: ${cert['date']}',
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

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/resume.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _saveData() async {
    _isButton1Highlighted = true;
    await _storage.saveData('name', _FirstnameController.text);
    await _storage.saveData('lastname', _LastnameController.text);
    await _storage.saveData('email', _emailController.text);
    await _storage.saveData('address', _addressController.text);
    await _storage.saveData('phone', _phoneNumberController.text);
    await _storage.saveData('aboutme', _aboutMeController.text);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')));
    setState(() {
      _isButton1Highlighted = false;
    });
  }

  Future<void> _sharePdf() async {
    setState(() {
      _isButton2Highlighted = true;
    });

    try {
      final pdfFile = await _generatePdf();
      await Share.shareXFiles([XFile(pdfFile.path)],
          text: 'Check out my resume!');
    } catch (e) {
      print('Error sharing PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate or share PDF')),
      );
    } finally {
      setState(() {
        _isButton2Highlighted = false;
      });
    }
  }

  void _addWebsiteField() {
    if (_websiteControllers.length < 3) {
      if (_websiteControllers.length != _websiteTitles.length) {
        _websiteTitles = List.generate(
            _websiteControllers.length, (index) => TextEditingController());
      }
      setState(() {
        _websiteControllers.add(TextEditingController());
        _websiteTitles.add(TextEditingController());
      });
    }
  }

  void _removeWebsiteField(int index) {
    if (_websiteControllers.isNotEmpty) {
      setState(() {
        _websiteControllers.removeAt(index);
        _websiteTitles.removeAt(index);
      });
    }
  }

  void _addSkillCategoryWithItem() {
    setState(() {
      __skillTitles.add(TextEditingController());
      _skillControllers.add([TextEditingController()]);
      _selectedSkillCategories.add(null);
      _isCustomCategory.add(false);
    });
  }

  void _removeSkillCategoryWithItems(int index) {
    setState(() {
      if (index >= 0 && index < __skillTitles.length) {
        __skillTitles.removeAt(index);
        _skillControllers.removeAt(index);
        _selectedSkillCategories.removeAt(index);
        _isCustomCategory.removeAt(index);
      }
    });
  }

  void _addSkillItem(int categoryIndex) {
    setState(() {
      if (categoryIndex >= 0 && categoryIndex < _skillControllers.length) {
        _skillControllers[categoryIndex].add(TextEditingController());
      }
    });
  }

  void _removeSkillItem(int categoryIndex, int itemIndex) {
    setState(() {
      if (categoryIndex < _skillControllers.length &&
          itemIndex < _skillControllers[categoryIndex].length) {
        _skillControllers[categoryIndex].removeAt(itemIndex);
      }
    });
  }

  void _addLanguageField() {
    setState(() {
      _languageNameControllers.add(TextEditingController());
      _languageLevelControllers.add(TextEditingController());
    });
  }

  void _removeLanguageField(int index) {
    setState(() {
      _languageNameControllers.removeAt(index);
      _languageLevelControllers.removeAt(index);
    });
  }

  List<Map<String, String>> getLanguages() {
    final List<Map<String, String>> languages = [];
    for (int i = 0; i < _languageNameControllers.length; i++) {
      languages.add({
        'name': _languageNameControllers[i].text.trim(),
        'level': _languageLevelControllers[i].text.trim(),
      });
    }
    return languages;
  }

  void _addExperienceField() {
    setState(() {
      _ExperienceControllers.add(TextEditingController());
      _companyName.add(TextEditingController());
      _jobTitle.add(TextEditingController());
      _startdatejob.add(TextEditingController());
      _enddatejob.add(TextEditingController());
      _detailjob.add(TextEditingController());
    });
  }

  void _removeExperienceField(int index) {
    if (_ExperienceControllers.isNotEmpty) {
      setState(() {
        _ExperienceControllers.removeAt(index);
        _companyName.removeAt(index);
        _jobTitle.removeAt(index);
        _startdatejob.removeAt(index);
        _enddatejob.removeAt(index);
        _detailjob.removeAt(index);
      });
    }
  }

  void _addEducationField() {
    setState(() {
      _educationControllers.add(TextEditingController());
      _degreeTitle.add(TextEditingController());
      _universityName.add(TextEditingController());
      _startEducation.add(TextEditingController());
      _endEducation.add(TextEditingController());
    });
  }

  void _removeEducationField(int index) {
    setState(() {
      _educationControllers.removeAt(index);
      _degreeTitle.removeAt(index);
      _universityName.removeAt(index);
      _startEducation.removeAt(index);
      _endEducation.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, bool check, int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      if (check) {
        setState(() {
          _startdatejob[index].text =
              DateFormat('dd/MM/yyyy').format(pickedDate);
        });
      } else {
        setState(() {
          _enddatejob[index].text = DateFormat('dd/MM/yyyy').format(pickedDate);
        });
      }
    }
  }

  /*Future<void> _selectDateEducation(BuildContext context,bool check,int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      if(check){
        setState(() {
          _startEducation[index].text = DateFormat('yyyy').format(pickedDate);
        });
      }else{
        setState(() {
          _endEducation[index].text = DateFormat('yyyy').format(pickedDate);
        });
      }
      
    }
  }*/

  void _addProjectField() {
    setState(() {
      _projectTitleControllers.add(TextEditingController());
      _projectDescriptionControllers.add(TextEditingController());
      _projectLinkControllers.add(TextEditingController());
      _projectTechControllers.add(TextEditingController());
    });
  }

  void _removeProjectField(int index) {
    setState(() {
      _projectTitleControllers.removeAt(index);
      _projectDescriptionControllers.removeAt(index);
      _projectLinkControllers.removeAt(index);
      _projectTechControllers.removeAt(index);
    });
  }

  void _addCertificationField() {
    setState(() {
      _certificationTitleControllers.add(TextEditingController());
      _certificationIssuerControllers.add(TextEditingController());
      _certificationDateControllers.add(TextEditingController());
    });
  }

  void _removeCertificationField(int index) {
    setState(() {
      _certificationTitleControllers.removeAt(index);
      _certificationIssuerControllers.removeAt(index);
      _certificationDateControllers.removeAt(index);
    });
  }

  List<Map<String, String>> getProjects() {
    final List<Map<String, String>> projects = [];
    for (int i = 0; i < _projectTitleControllers.length; i++) {
      projects.add({
        'title': _projectTitleControllers[i].text.trim(),
        'description': _projectDescriptionControllers[i].text.trim(),
        'link': _projectLinkControllers[i].text.trim(),
        'tech': _projectTechControllers[i].text.trim(),
      });
    }
    return projects;
  }

  List<Map<String, String>> getCertifications() {
    final List<Map<String, String>> certifications = [];
    for (int i = 0; i < _certificationTitleControllers.length; i++) {
      certifications.add({
        'title': _certificationTitleControllers[i].text.trim(),
        'issuer': _certificationIssuerControllers[i].text.trim(),
        'date': _certificationDateControllers[i].text.trim(),
      });
    }
    return certifications;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff183058),
                Color(0xff1E3C72),
                Color(0xff2A5298),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            //appBar: AppBar(title: const Text('Flutter')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20), // เว้นขอบบน
                        child: Text(
                          'Flutter Resume',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            wordSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? const Icon(Icons.add_a_photo, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _FirstnameController,
                            decoration: const InputDecoration(
                              labelText: 'FirstName',
                              icon: Icon(Icons.person_outlined),
                              labelStyle: TextStyle(color: Colors.white,),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _LastnameController,
                            decoration: const InputDecoration(
                              labelText: 'LastName',
                              icon: Icon(Icons.person_add_alt_1_outlined),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.attach_email_outlined),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        icon: const Icon(Icons.home_outlined),
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        icon: Icon(Icons.phone_outlined),
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _aboutMeController,
                      decoration: InputDecoration(
                        labelText: 'About Me',
                        icon: const Icon(Icons.info_outline),
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 2),
                        ),
                      ),
                      maxLines: 5,
                    ),
                    //------------------------------------------------------Website------------------------------------------------------//
                    Row(
                      children: [
                        const Text('Website: '),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addWebsiteField,
                        ),
                      ],
                    ),
                    ..._websiteControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      TextEditingController titleController =
                          _websiteTitles[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Website Title',
                              icon: Icon(Icons.title),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    labelText: 'Website URL',
                                    icon: Icon(Icons.link),
                                    labelStyle:
                                        TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () => _removeWebsiteField(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }),
                    //------------------------------------------------------Website------------------------------------------------------//
                    //---------------------------------------------- Skill Section ------------------------------------------------------//
                    Row(
                      children: [
                        const Text('Skill Categories: '),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addSkillCategoryWithItem,
                        ),
                      ],
                    ),
                    ...__skillTitles.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController customTitleController = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedSkillCategories[index],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSkillCategories[index] = value;
                                      _isCustomCategory[index] =
                                          value == 'Custom';
                                      if (value != 'Custom') {
                                        customTitleController.text = value!;
                                      } else {
                                        customTitleController.clear();
                                      }
                                    });
                                  },
                                  items: _skillCategoryOptions.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Skill Category',
                                    icon: Icon(Icons.category),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _addSkillItem(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () =>
                                    _removeSkillCategoryWithItems(index),
                              ),
                            ],
                          ),
                          if (_isCustomCategory[index]) ...[
                            const SizedBox(height: 5),
                            TextField(
                              controller: customTitleController,
                              decoration: const InputDecoration(
                                labelText: 'Custom Category Name',
                                icon: Icon(Icons.edit),
                              ),
                            ),
                          ],
                          const SizedBox(height: 5),
                          ..._skillControllers[index]
                              .asMap()
                              .entries
                              .map((skillEntry) {
                            int skillIndex = skillEntry.key;
                            TextEditingController skillController =
                                skillEntry.value;

                            return Row(
                              children: [
                                const SizedBox(width: 32),
                                Expanded(
                                  child: TextField(
                                    controller: skillController,
                                    decoration: const InputDecoration(
                                      labelText: 'Skill',
                                      icon: Icon(Icons.check),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () =>
                                      _removeSkillItem(index, skillIndex),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
                    //---------------------------------------------- Skill Section ------------------------------------------------------//
                    //----------------------------------------------------Languages------------------------------------------------------//
                    Row(
                      children: [
                        const Text('Languages: '),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addLanguageField,
                        ),
                      ],
                    ),
                    ..._languageNameControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController nameController =
                          _languageNameControllers[index];
                      TextEditingController levelController =
                          _languageLevelControllers[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Language ${index + 1}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.red),
                                onPressed: () => _removeLanguageField(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Language Name',
                              icon: Icon(Icons.language),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: levelController,
                            decoration: const InputDecoration(
                              labelText: 'Proficiency Level',
                              icon: Icon(Icons.bar_chart),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(thickness: 1),
                        ],
                      );
                    }),
                    //-------------------------------------------------------Languages------------------------------------------------------//

                    //------------------------------------------------------Experience------------------------------------------------------//
                    Row(
                      children: [
                        const Text('Experience: '),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addExperienceField,
                        ),
                      ],
                    ),
                    ..._ExperienceControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController companyNameController =
                          _companyName[index];
                      TextEditingController jobTitleController =
                          _jobTitle[index];
                      TextEditingController startDateController =
                          _startdatejob[index];
                      TextEditingController endDateController =
                          _enddatejob[index];
                      TextEditingController detailController =
                          _detailjob[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Experience ${index + 1}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.red),
                                onPressed: () => _removeExperienceField(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: companyNameController,
                            decoration: const InputDecoration(
                              labelText: 'Company Name',
                              icon: Icon(Icons.apartment_outlined),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: jobTitleController,
                            decoration: const InputDecoration(
                              labelText: 'Job Title',
                              icon: Icon(Icons.badge_outlined),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: startDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "Start Date",
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                    labelStyle: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  onTap: () {
                                    _selectDate(context, true, index);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: endDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "End Date",
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                    labelStyle: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  onTap: () {
                                    _selectDate(context, false, index);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 180,
                            child: TextField(
                              controller: detailController,
                              decoration: InputDecoration(
                                labelText: 'Job Description',
                                icon: const Icon(Icons.description_outlined),
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              maxLines: null,
                              expands: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(thickness: 1),
                        ],
                      );
                    }),
                    //------------------------------------------------------Experience------------------------------------------------------//
                    //------------------------------------------------------Education------------------------------------------------------//
                    Row(
                      children: [
                        const Text('Education: '),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addEducationField,
                        ),
                      ],
                    ),
                    ..._educationControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController startDateEducationController =
                          _startEducation[index];
                      TextEditingController endDateEducationController =
                          _endEducation[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Education ${index + 1}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.red),
                                onPressed: () => _removeEducationField(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _degreeTitle[index],
                            decoration: const InputDecoration(
                              labelText: 'Degree Title',
                              icon: Icon(Icons.school),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _universityName[index],
                            decoration: const InputDecoration(
                              labelText: 'University Name',
                              icon: Icon(Icons.account_balance),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: startDateEducationController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "Start Year",
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                    labelStyle: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  onTap: () async {
                                    int selectedYear = DateTime.now().year;
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Select Year'),
                                          content: SizedBox(
                                            width: 300,
                                            height: 300,
                                            child: YearPicker(
                                              firstDate: DateTime(1950),
                                              lastDate:
                                                  DateTime(DateTime.now().year),
                                              initialDate:
                                                  DateTime(selectedYear),
                                              selectedDate:
                                                  DateTime(selectedYear),
                                              onChanged: (DateTime dateTime) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  startDateEducationController
                                                          .text =
                                                      dateTime.year.toString();
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: endDateEducationController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "End Year",
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                    labelStyle: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  onTap: () async {
                                    int selectedYear = DateTime.now().year;

                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Select Year'),
                                          content: SizedBox(
                                            width: 300,
                                            height: 300,
                                            child: YearPicker(
                                              firstDate: DateTime(1950),
                                              lastDate:
                                                  DateTime(DateTime.now().year),
                                              initialDate:
                                                  DateTime(selectedYear),
                                              selectedDate:
                                                  DateTime(selectedYear),
                                              onChanged: (DateTime dateTime) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  endDateEducationController
                                                          .text =
                                                      dateTime.year.toString();
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(thickness: 1),
                        ],
                      );
                    }),
                    //------------------------------------------------------Education------------------------------------------------------//
                    //------------------------------------------------------Projects------------------------------------------------------//
                    Row(
                      children: [
                        const Text('Projects: '),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addProjectField, // ต้องสร้าง
                        ),
                      ],
                    ),
                    ..._projectTitleControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Project ${index + 1}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.red),
                                onPressed: () =>
                                    _removeProjectField(index), // ต้องสร้าง
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _projectTitleControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Project Title',
                              icon: Icon(Icons.title),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _projectDescriptionControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              icon: Icon(Icons.description),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _projectLinkControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Link',
                              icon: Icon(Icons.link),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _projectTechControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Technologies',
                              icon: Icon(Icons.code),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(thickness: 1),
                        ],
                      );
                    }),
                    //------------------------------------------------------Projects------------------------------------------------------//
                    //-------------------------------------------------Certifications-----------------------------------------------------//
                    Row(
                      children: [
                        const Text('Certifications: '),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addCertificationField, // ต้องสร้าง
                        ),
                      ],
                    ),
                    ..._certificationTitleControllers
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Certification ${index + 1}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.red),
                                onPressed: () => _removeCertificationField(
                                    index), // ต้องสร้าง
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _certificationTitleControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              icon: Icon(Icons.card_membership),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _certificationIssuerControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Issuer',
                              icon: Icon(Icons.business),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _certificationDateControllers[index],
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              icon: Icon(Icons.calendar_today),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Divider(thickness: 1),
                        ],
                      );
                    }),
                    //-------------------------------------------------Certifications-----------------------------------------------------//
                    const SizedBox(height: 30),
                    //------------------------------------------------------button------------------------------------------------------//
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: _saveData,
                              onHighlightChanged: (isHighlighted) {
                                setState(() {
                                  _isButton1Highlighted = isHighlighted;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isButton1Highlighted
                                      ? Colors.blue[900]
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.save,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    const Text(
                                      'Save Data',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: _sharePdf,
                              onHighlightChanged: (isHighlighted) {
                                setState(() {
                                  _isButton2Highlighted = isHighlighted;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isButton2Highlighted
                                      ? Colors.green[900]
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.picture_as_pdf,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    const Text(
                                      'Generate & Share PDF',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //------------------------------------------------------button------------------------------------------------------//
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
