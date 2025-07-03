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
import 'package:flutter_resume_app/pdf_templates/resume_template2_generator.dart';
import 'package:flutter_resume_app/pdf_templates/resume_template3_generator.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

class ResumePreviewScreen extends StatefulWidget {
  const ResumePreviewScreen({super.key});

  @override
  _ResumePreviewScreenState createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  bool _isLoading = true;

  String? _pdfPathTemplate1;
  String? _pdfPathTemplate2;
  String? _pdfPathTemplate3;

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

    final outputDir = await getTemporaryDirectory();

    //---------------------------------- Template 1 ---------------------------------//
    final pdf1Bytes = await ResumeTemplate1Generator().generatePdfFromResume(sampleResume);
    final file1 = File('${outputDir.path}/resume_template1.pdf');
    await file1.writeAsBytes(await pdf1Bytes);

    //---------------------------------- Template 2 ---------------------------------//
    final pdf2Bytes = await ResumeTemplate2Generator().generatePdfFromResume(sampleResume);
    final file2 = File('${outputDir.path}/resume_template2.pdf');
    await file2.writeAsBytes(await pdf2Bytes);

    //---------------------------------- Template 3 ---------------------------------//
    final pdf3Bytes = await ResumeTemplate3Generator().generatePdfFromResume(sampleResume);
    final file3 = File('${outputDir.path}/resume_template3.pdf');
    await file3.writeAsBytes(await pdf3Bytes);

    if (!mounted) return;
    setState(() {
      _pdfPathTemplate1 = file1.path;
      _pdfPathTemplate2 = file2.path;
      _pdfPathTemplate3 = file3.path;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: DynamicBackground(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : isLandscape
                  ? PageView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPdfWithTitle("Template 1", _pdfPathTemplate1, size),
                        _buildPdfWithTitle("Template 2", _pdfPathTemplate2, size),
                        _buildPdfWithTitle("Template 3", _pdfPathTemplate3, size),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(8.0),
                      children: [
                        Text("Template 1",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'MidnightConstellations')),
                        const SizedBox(height: 8),
                        _buildPdfViewer(_pdfPathTemplate1, size),
                        const SizedBox(height: 24),
                        Text("Template 2",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'MidnightConstellations')),
                        const SizedBox(height: 8),
                        _buildPdfViewer(_pdfPathTemplate2, size),
                        const SizedBox(height: 24),
                        Text("Template 3",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'MidnightConstellations')),
                        const SizedBox(height: 8),
                        _buildPdfViewer(_pdfPathTemplate3, size),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildPdfWithTitle(String title, String? path, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'MidnightConstellations',
          ),
        ),
        Expanded(
          child: _buildPdfViewer(path, screenSize),
        ),
      ],
    );
  }

  Widget _buildPdfViewer(String? path, Size screenSize) {
    if (path == null) {
      return const Text('PDF not available', style: TextStyle(color: Colors.white));
    }

    final isLandscape = screenSize.width > screenSize.height;

    Widget pdf = PDFView(
      filePath: path,
      enableSwipe: true,
      swipeHorizontal: isLandscape,
      autoSpacing: false,
      pageFling: true,
      fitPolicy: FitPolicy.WIDTH,
    );

    if (isLandscape) {
      return Center(
        child: SizedBox(
          width: screenSize.width * 0.3,
          height: screenSize.height * 0.83,
          child: ClipRRect(
            //borderRadius: BorderRadius.circular(12),
            child: pdf,
          ),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 0.707,
      child: pdf,
    );
  }

}