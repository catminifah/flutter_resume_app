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
import 'dart:typed_data';

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
  final TextEditingController _FirstnameController = TextEditingController();
  final TextEditingController _LastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  final List<TextEditingController> _websiteControllers = [];
  List<TextEditingController> _websiteTitles = [];
  
  final List<TextEditingController> __skillTitles = [];
  final List<TextEditingController> _skillControllers = [];

  final List<TextEditingController> _ExperienceControllers = [];
  final List<TextEditingController> _companyName = [];
  final List<TextEditingController> _jobTitle = [];
  final List<TextEditingController> _startdatejob = [];
  final List<TextEditingController> _enddatejob = [];
  final List<TextEditingController> _detailjob = [];

  final List<TextEditingController> _educationControllers = [];
  final List<TextEditingController> _degreeTitle = [];
  final List<TextEditingController> _universityName = [];
  final List<TextEditingController> _startEducation = [];
  final List<TextEditingController> _endEducation = [];

  final ResumeDataStorage _storage = ResumeDataStorage();
  File? _profileImage;
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
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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

    final ARIBLKFont = pw.Font.ttf(await rootBundle.load('assets/fonts/ARIBLK.TTF'));
    final EBGaramondBoldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond-Bold.ttf'));
    final EBGaramondFont = pw.Font.ttf(await rootBundle.load('assets/fonts/EBGaramond.ttf'));

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
                          PdfColor.fromInt(0xFF021526), // #021526
                          PdfColor.fromInt(0xFF03346E), // #03346E
                          PdfColor.fromInt(0xFF6EACDA), // #6EACDA
                          PdfColor.fromInt(0xFFE2E2B6), // #E2E2B6
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
                                border: pw.Border.all(color: PdfColors.white, width: 2),
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
                        if (_emailController.text.isNotEmpty)
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
                        if (_emailController.text.isNotEmpty)
                          pw.SizedBox(height: 5),
                        // NumberPhone
                        if (_phoneNumberController.text.isNotEmpty)
                          pw.Row(
                            children: [
                              pw.Image(pw.MemoryImage(phoneIcon),
                                  width: 12, height: 12),
                              pw.SizedBox(width: 5),
                              pw.Text(_phoneNumberController.text,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.white,
                                )
                              ),
                            ],
                          ),
                        if (_phoneNumberController.text.isNotEmpty)
                          pw.SizedBox(height: 5),
                        // Address
                        if (_addressController.text.isNotEmpty)
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
                        if (_addressController.text.isNotEmpty)
                          pw.SizedBox(height: 5),

                        //pw.Divider(thickness: 1, color: PdfColors.white),

                        if (_websiteControllers.isNotEmpty)
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
                                          '${controller.text}',
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

                        if (_websiteControllers.isNotEmpty)
                          pw.SizedBox(height: 10),
                        if (_websiteControllers.isNotEmpty ||
                            _addressController.text.isNotEmpty ||
                            _phoneNumberController.text.isNotEmpty ||
                            _emailController.text.isNotEmpty)
                          pw.Divider(thickness: 1, color: PdfColors.white),

                        // Skills Summary
                        if (_skillControllers.isNotEmpty)
                          pw.Text('Skills',
                            style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blueGrey900
                            )
                          ),
                        pw.SizedBox(height: 5),
                        ..._skillControllers.map((controller) {
                          return pw.Column(
                            children: [
                              if (controller.text.isNotEmpty)
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                      width: 5,
                                      height: 5,
                                      decoration: pw.BoxDecoration(
                                        color: PdfColor.fromInt(0xFFE2E2B6),
                                        shape: pw.BoxShape.circle,
                                      ),
                                    ),
                                    pw.SizedBox(width: 5),
                                    pw.Text(controller.text,
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.white,
                                      )
                                    ),
                                  ],
                                ),
                              pw.SizedBox(height: 2),
                            ],
                          );
                        }),
                        pw.SizedBox(height: 5),
                      ],
                    ),
                  ),
                  
                  ]
                ),
              ),

              // Right Column - PROFILLE & Experience & Education
              pw.Expanded(
                child: pw.Container(
                  padding: pw.EdgeInsets.only(left: 20,right: 20),
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
                        pw.Text('${_aboutMeController.text}',
                            style: pw.TextStyle(
                                fontSize: 10, color: PdfColors.grey)),
                      if (_aboutMeController.text.isNotEmpty)
                        pw.SizedBox(height: 10),

                      if (_aboutMeController.text.isNotEmpty)
                      pw.Divider(thickness: 1, color: PdfColors.grey),

                      // Education
                      if (_educationControllers.any((controller) => controller.text.isNotEmpty) ||
                          _startEducation.any((controller) => controller.text.isNotEmpty) ||
                          _endEducation.any((controller) => controller.text.isNotEmpty) ||
                          _universityName.any((controller) => controller.text.isNotEmpty) ||
                          _degreeTitle.any((controller) => controller.text.isNotEmpty))
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
                            pw.Row(
                              children: [
                                pw.Text(
                                _universityName[index].text.isNotEmpty
                                    ? '${_universityName[index].text[0].toUpperCase()}${_universityName[index].text.substring(1)}'
                                    : '',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  font: EBGaramondBoldFont
                                ),
                              ),
                              pw.SizedBox(width: 5),
                              pw.Text(
                                _startEducation[index].text.isNotEmpty
                                    ? '${_startEducation[index].text} - ${_endEducation[index].text}'
                                    : _endEducation[index].text,
                                style: pw.TextStyle(
                                    fontSize: 8, color: PdfColors.grey),
                              ),
                              ]
                            ),
                            /*if (_startEducation[index].text.isNotEmpty||_endEducation[index].text.isNotEmpty)
                            pw.SizedBox(height: 5),*/
                            /*if (_startEducation[index].text.isNotEmpty||_endEducation[index].text.isNotEmpty)
                            pw.SizedBox(height: 5),*/
                            if (_degreeTitle[index].text.isNotEmpty)
                            pw.Text(
                                _degreeTitle[index].text,
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    color: PdfColors.grey900,
                                    font: EBGaramondFont
                                    )),
                            pw.SizedBox(height: 10),
                          ],
                        );
                      }),

                      if (_educationControllers.any((controller) => controller.text.isNotEmpty) ||
                          _startEducation.any((controller) => controller.text.isNotEmpty) ||
                          _endEducation.any((controller) => controller.text.isNotEmpty) ||
                          _universityName.any((controller) => controller.text.isNotEmpty) ||
                          _degreeTitle.any((controller) => controller.text.isNotEmpty))
                      pw.Divider(thickness: 1, color: PdfColors.grey),
                      
                      // Work Experience
                      if (_ExperienceControllers.any((controller) => controller.text.isNotEmpty) ||
                          _jobTitle.any((controller) => controller.text.isNotEmpty) ||
                          _companyName.any((controller) => controller.text.isNotEmpty) ||
                          _startdatejob.any((controller) => controller.text.isNotEmpty) ||
                          _enddatejob.any((controller) => controller.text.isNotEmpty) ||
                          _detailjob.any((controller) => controller.text.isNotEmpty)
                          )
                      pw.Text('Work Experience',
                          style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue)),
                      pw.SizedBox(height: 5),
                      ..._ExperienceControllers.asMap().entries.map((entry) {
                        int index = entry.key;
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(
                                _companyName[index].text,
                                style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    font: EBGaramondBoldFont
                                  )
                                ),
                                pw.SizedBox(width: 5),
                                pw.Text(
                                '${_startdatejob[index].text} - ${_enddatejob[index].text.isEmpty ? 'PRESENT' : _enddatejob[index].text}',
                                style: pw.TextStyle(
                                    fontSize: 8, color: PdfColors.grey),
                              ),
                              ]
                            ),
                            
                            pw.Text(
                                _jobTitle[index].text,
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.normal,
                                    color: PdfColors.grey900,
                                    font: EBGaramondFont
                                    )
                                ),

                            pw.SizedBox(width: 5),
                            pw.Text('${_detailjob[index].text}',
                                style: pw.TextStyle(fontSize: 10,color: PdfColors.grey800)),
                            pw.SizedBox(height: 10),
                          ],
                        );
                      }),

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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data saved successfully!')));
    setState(() {
      _isButton1Highlighted = false;
    });
    
  }

  Future<void> _sharePdf() async {
    _isButton2Highlighted = true;
    final pdfFile = await _generatePdf();
    await Share.shareXFiles([XFile(pdfFile.path)], text: 'Check out my resume!');
    setState(() {
      _isButton2Highlighted = false;
    });
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

  void _addSkillField() {
    setState(() {
      _skillControllers.add(TextEditingController());
    });
  }

  void _removeSkillField(int index) {
    if (_skillControllers.isNotEmpty) {
      setState(() {
        _skillControllers.removeAt(index);
      });
    }
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

  Future<void> _selectDate(BuildContext context,bool check,int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      if(check){
        setState(() {
          _startdatejob[index].text = DateFormat('dd/MM/yyyy').format(pickedDate);
        });
      }else{
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Flutter Resume')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
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
                          labelStyle: TextStyle(color: Color(0xFF6200EE)),
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
                          labelStyle: TextStyle(color: Color(0xFF6200EE)),
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
                    labelStyle: TextStyle(color: Color(0xFF6200EE)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    icon: const Icon(Icons.home_outlined),
                    labelStyle: const TextStyle(color: Color(0xFF6200EE)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xFF6200EE),
                          width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Color(0xFF6200EE), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xFF6200EE),
                          width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    icon: Icon(Icons.phone_outlined),
                    labelStyle: TextStyle(color: Color(0xFF6200EE)),
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
                    labelStyle: const TextStyle(color: Color(0xFF6200EE)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xFF6200EE),
                          width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Color(0xFF6200EE), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xFF6200EE),
                          width: 2),
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
                  TextEditingController titleController = _websiteTitles[index];
      
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Website Title',
                          icon: Icon(Icons.title),
                          labelStyle: TextStyle(color: Color(0xFF6200EE)),
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
                                labelStyle: TextStyle(color: Color(0xFF6200EE)),
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
                //------------------------------------------------------Skill------------------------------------------------------//
                Row(
                  children: [
                    const Text('Skill: '),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: _addSkillField,
                    ),
                  ],
                ),
                ..._skillControllers.asMap().entries.map((entry) {
                  int index = entry.key;
                  TextEditingController controller = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                labelText: 'Skill',
                                icon: Icon(Icons.note_add_outlined),
                                labelStyle: TextStyle(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () => _removeSkillField(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
                //------------------------------------------------------Skill------------------------------------------------------//
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
                  TextEditingController jobTitleController = _jobTitle[index];
                  TextEditingController startDateController = _startdatejob[index];
                  TextEditingController endDateController = _enddatejob[index];
                  TextEditingController detailController = _detailjob[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
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
                          labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: jobTitleController,
                        decoration: const InputDecoration(
                          labelText: 'Job Title',
                          icon: Icon(Icons.badge_outlined),
                          labelStyle: TextStyle(color: Color(0xFF6200EE)),
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
                                suffixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                                labelStyle:
                                    const TextStyle(color: Color(0xFF6200EE)),
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
                                suffixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                                labelStyle:
                                    const TextStyle(color: Color(0xFF6200EE)),
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
                                const TextStyle(color: Color(0xFF6200EE)),
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
                  TextEditingController startDateEducationController = _startEducation[index];
                  TextEditingController endDateEducationController   = _endEducation[index];
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
                          labelStyle: TextStyle(color: Color(0xFF6200EE)),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _universityName[index],
                        decoration: const InputDecoration(
                          labelText: 'University Name',
                          icon: Icon(Icons.account_balance),
                          labelStyle: TextStyle(color: Color(0xFF6200EE)),
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
                                suffixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                                labelStyle:
                                    const TextStyle(color: Color(0xFF6200EE)),
                              ),
                              onTap:  () async {
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
                                          initialDate: DateTime(selectedYear),
                                          selectedDate: DateTime(selectedYear),
                                          onChanged: (DateTime dateTime) {
                                            Navigator.pop(context);
                                            setState(() {
                                              startDateEducationController.text = dateTime.year.toString();
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
                                suffixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                                labelStyle:
                                    const TextStyle(color: Color(0xFF6200EE)),
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
                                          initialDate: DateTime(selectedYear),
                                          selectedDate: DateTime(selectedYear),
                                          onChanged: (DateTime dateTime) {
                                            Navigator.pop(context);
                                            setState(() {
                                              endDateEducationController.text = dateTime.year.toString();
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }
}