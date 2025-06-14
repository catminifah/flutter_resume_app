import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, SystemChrome, SystemUiOverlayStyle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_resume_app/models/certification.dart';
import 'package:flutter_resume_app/models/education.dart';
import 'package:flutter_resume_app/models/experience.dart';
import 'package:flutter_resume_app/models/language_skill.dart';
import 'package:flutter_resume_app/models/project.dart';
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:flutter_resume_app/models/skill_category.dart';
import 'package:flutter_resume_app/pdf_templates/resume_template1_generator.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:path_provider/path_provider.dart';

class ResumePreviewScreen extends StatefulWidget {
  const ResumePreviewScreen({Key? key}) : super(key: key);

  @override
  _ResumePreviewScreenState createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  String? _localPdfPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generatePdfWithSampleData();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _generatePdfWithSampleData() async {
    final sampleResume = ResumeModel(
      firstname: 'Lisarut',
      lastname: 'Monjen',
      email: 'lisarut_mo.chef@example.com',
      phoneNumber: '098-888-1234',
      address: '123 Dessert Lane, Bangkok',
      aboutMe: 'A passionate dessert chef with 8+ years of experience specializing in Thai and French sweets. Focused on innovation and quality.',
      websites: [],
      skills: [
        SkillCategory(
          category: 'Cooking',
          items: ['Choux pastry', 'Macaron', 'Fondant'],
        ),
        SkillCategory(
          category: 'Soft Skills',
          items: ['Kitchen coordination', 'Mentoring assistants'],
        ),
      ],
      projects: [
        Project(
          name: 'Thai-French Fusion Dessert Menu',
          description: 'Developed a seasonal dessert menu combining Thai ingredients with French techniques.',
          tech: 'Thai herbs, French pastry methods',
          link: 'https://lisaratmana-desserts.com/fusion2024',
        ),
      ],
      certifications: [
        Certification(
          title: 'Advanced Pastry Certificate',
          issuer: 'Le Cordon Bleu, Paris',
          date: 'May 2021',
        ),
      ],
      languages: [
        LanguageSkill(language: 'Thai', proficiency: 'Native'),
        LanguageSkill(language: 'English', proficiency: 'Fluent'),
        LanguageSkill(language: 'French', proficiency: 'Intermediate'),
      ],
      profileImage: (await rootBundle.load('assets/images/profile_resume.jpeg')).buffer.asUint8List(),
      id: '',
      experiences: [
        Experience(
          company: 'Sweet & Co. Bakery',
          position: 'Head Pastry Chef',
          startDate: 'January 2018',
          endDate: 'Present',
          description: 'Led a team of 6 pastry chefs, created seasonal dessert menus, and managed kitchen operations.',
        ),
        Experience(
          company: 'Delice Desserts',
          position: 'Junior Dessert Chef',
          startDate: 'June 2015',
          endDate: 'December 2017',
          description: 'Assisted in preparing French pastries and collaborated with the senior team to innovate recipes.',
        ),
      ],
      educationList: [
        Education(
          school: 'Le Cordon Bleu, Bangkok',
          degree: 'Diplôme de Pâtisserie',
          startDate: '',
          endDate: '2015',
        ),
        Education(
          school: 'Bangkok Culinary School',
          degree: 'Certificate in Culinary Arts',
          startDate: '',
          endDate: '2013',
        ),
      ],
    );

    final generator = ResumeTemplate1Generator();
    final pdfBytes = await generator.generatePdfFromResume(sampleResume);

    final outputDir = await getTemporaryDirectory();
    final file = File('${outputDir.path}/sample_resume.pdf');
    final pdfUint8List = await pdfBytes;
    await file.writeAsBytes(pdfUint8List);

    if (!mounted) return;

    setState(() {
      _localPdfPath = file.path;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicBackground(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _localPdfPath != null
              ? Padding(
                  padding: const EdgeInsets.all(0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: PDFView(
                        filePath: _localPdfPath!,
                        enableSwipe: true,
                        swipeHorizontal: false,
                        autoSpacing: true,
                        pageFling: true,
                      ),
                    ),
                  ),
                )
              : const Center(child: Text('Failed to load PDF')),
    ));
  }

}