import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/models/certification.dart';
import 'package:flutter_resume_app/models/education.dart';
import 'package:flutter_resume_app/models/experience.dart';
import 'package:flutter_resume_app/models/language_skill.dart';
import 'package:flutter_resume_app/models/project.dart';
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:flutter_resume_app/models/resume_service.dart';
import 'package:flutter_resume_app/models/skill_category.dart';
import 'package:flutter_resume_app/pages/resume_export_pdf.dart';
import 'package:flutter_resume_app/pdf_templates/resume_template1_generator.dart';
import 'package:flutter_resume_app/pdf_templates/resume_template2_generator.dart';
import 'package:flutter_resume_app/pdf_templates/resume_template3_generator.dart';
import 'package:flutter_resume_app/services/resume_from_controllers.dart';
import 'package:flutter_resume_app/services/shared_preferences.dart';
import 'package:flutter_resume_app/star/glowing_star_button.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:flutter_resume_app/widgets/size_config.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ResumeEditor extends StatefulWidget {
  final ResumeModel? resume;
  const ResumeEditor({super.key, this.resume});

  @override
  State<ResumeEditor> createState() => _ResumeEditorState();
}

class _ResumeEditorState extends State<ResumeEditor> {
  // Personal Information
  final TextEditingController _FirstnameController = TextEditingController();
  final TextEditingController _LastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  // Personal Websites
  final List<TextEditingController> _websiteControllers = [];

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
  //bool _isButton1Highlighted = false;
  //bool _isButton2Highlighted = false;

  String? resumeId;

  String? _selectedTemplate;
  final List<String> _templateOptions = [
    'Template 1',
    'Template 2',
    'Template 3',
  ];

  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
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
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _profileImage = File(croppedFile.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image cropping failed.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<Uint8List> loadIcon(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  void _addWebsiteField() {
    if (_websiteControllers.length < 3) {
      setState(() {
        _websiteControllers.add(TextEditingController());
      });
    }
  }

  void _removeWebsiteField(int index) {
    if (_websiteControllers.isNotEmpty) {
      setState(() {
        _websiteControllers.removeAt(index);
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

  Future<void> onSavePressed() async {
    final websitesList = _websiteControllers.map((e) => e.text.trim()).toList();

    final skillCategoriesList = <SkillCategory>[];
    for (int i = 0; i < _selectedSkillCategories.length; i++) {
      final category = __skillTitles[i].text.trim().isNotEmpty
          ? __skillTitles[i].text.trim()
          : (_selectedSkillCategories[i] ?? 'Unknown');
      final skills = _skillControllers[i].map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
      if (skills.isNotEmpty) {
        skillCategoriesList.add(
          SkillCategory(category: category, items: skills),
        );
      }
    }

    final experienceList = <Experience>[];
    for (int i = 0; i < _companyName.length; i++) {
      experienceList.add(Experience(
        company: _companyName[i].text.trim(),
        position: _jobTitle[i].text.trim(),
        startDate: _startdatejob[i].text.trim(),
        endDate: _enddatejob[i].text.trim(),
        description: _detailjob[i].text.trim(),
      ));
    }

    final educationList = <Education>[];
    for (int i = 0; i < _degreeTitle.length; i++) {
      educationList.add(Education(
        degree: _degreeTitle[i].text.trim(),
        school: _universityName[i].text.trim(),
        startDate: _startEducation[i].text.trim(),
        endDate: _endEducation[i].text.trim(),
      ));
    }

    final projectList = <Project>[];
    for (int i = 0; i < _projectTitleControllers.length; i++) {
      projectList.add(Project(
          name: _projectTitleControllers[i].text.trim(),
          description: _projectDescriptionControllers[i].text.trim(),
          link: _projectLinkControllers[i].text.trim(),
          tech: _projectTechControllers[i].text.trim()));
    }

    final certificationList = <Certification>[];
    for (int i = 0; i < _certificationTitleControllers.length; i++) {
      certificationList.add(Certification(
        title: _certificationTitleControllers[i].text.trim(),
        issuer: _certificationIssuerControllers[i].text.trim(),
        date: _certificationDateControllers[i].text.trim(),
      ));
    }

    final languageList = <LanguageSkill>[];
    for (int i = 0; i < _languageNameControllers.length; i++) {
      languageList.add(LanguageSkill(
        language: _languageNameControllers[i].text.trim(),
        proficiency: _languageLevelControllers[i].text.trim(),
      ));
    }

    final profileImageBytes = _profileImage != null ? await _profileImage!.readAsBytes() : null;

    final resume = ResumeModel(
      id: resumeId ?? const Uuid().v4(),
      firstname: _FirstnameController.text.trim(),
      lastname: _LastnameController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      aboutMe: _aboutMeController.text.trim(),
      websites: websitesList,
      skills: skillCategoriesList,
      experiences: experienceList,
      educationList: educationList,
      projects: projectList,
      certifications: certificationList,
      languages: languageList,
      profileImage: profileImageBytes,
    );
    if (resumeId == null) {
      await ResumeService.create(resume);
      resumeId = resume.id;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("new resume succeed")));
    } else {
      await ResumeService.update(resume);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("update resume")));
    }
  }

  Future<void> _generateAndPreviewResumePdf() async {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a resume template first")),
      );
      return;
    }

    setState(() => isNavigating = true);
    await Future.delayed(const Duration(seconds: 1));
    final websitesList = _websiteControllers.map((e) => e.text.trim()).toList();

    final profileImageBytes = _profileImage != null ? await _profileImage!.readAsBytes() : null;

    final processedSkillTitles = <TextEditingController>[];
    for (int i = 0; i < __skillTitles.length; i++) {
      if (_selectedSkillCategories[i] == 'Custom') {
        processedSkillTitles.add(TextEditingController(text: __skillTitles[i].text.trim()));
      } else {
        processedSkillTitles.add(TextEditingController(
            text: _selectedSkillCategories[i] ?? 'Other'));
      }
    }
    final resume = getResumeFromControllers(
      firstnameController: _FirstnameController,
      lastnameController: _LastnameController,
      emailController: _emailController,
      addressController: _addressController,
      phoneNumberController: _phoneNumberController,
      aboutMeController: _aboutMeController,
      websiteControllers: _websiteControllers,
      skillTitles: processedSkillTitles,
      selectedSkillCategories: _selectedSkillCategories,
      skillControllers: _skillControllers,
      companyName: _companyName,
      position: _jobTitle,
      startdatejob: _startdatejob,
      enddatejob: _enddatejob,
      detailjob: _detailjob,
      universityName: _universityName,
      degreeTitle: _degreeTitle,
      startEducation: _startEducation,
      endEducation: _endEducation,
      projectTitleControllers: _projectTitleControllers,
      projectDescriptionControllers: _projectDescriptionControllers,
      projectLinkControllers: _projectLinkControllers,
      projectTechControllers: _projectTechControllers,
      certificationTitleControllers: _certificationTitleControllers,
      certificationIssuerControllers: _certificationIssuerControllers,
      certificationDateControllers: _certificationDateControllers,
      languageNameControllers: _languageNameControllers,
      languageproficiencyControllers: _languageLevelControllers,
      profileImage: _profileImage != null ? await _profileImage!.readAsBytes() : null,
    );
    Uint8List? pdfBytes;
    if (_selectedTemplate == 'Template 1') {
      pdfBytes = await await ResumeTemplate1Generator().generatePdfFromResume(resume);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResumeExportPDF(pdfBytes: pdfBytes),
        ),
      );
      setState(() => isNavigating = false);
    } else if (_selectedTemplate == 'Template 2') {
      pdfBytes =
          await await ResumeTemplate2Generator().generatePdfFromResume(resume);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResumeExportPDF(pdfBytes: pdfBytes),
        ),
      );

      setState(() => isNavigating = false);
    } else if (_selectedTemplate == 'Template 3') {
      pdfBytes =
          await await ResumeTemplate3Generator().generatePdfFromResume(resume);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResumeExportPDF(pdfBytes: pdfBytes),
        ),
      );

      setState(() => isNavigating = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unknown template selected")),
      );
      setState(() => isNavigating = false);
      return;
    }
  }

  //////////////////////////////////////////////////////// UI ///////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    return AbsorbPointer(
      absorbing: isNavigating,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return false;
        },
        child: DynamicBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            //appBar: AppBar(title: const Text('Flutter')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                    _buildPhoto(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildFirstName(),
                        SizedBox(width: 8),
                        _buildLastName(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildEmail(),
                    const SizedBox(height: 10),
                    _buildAddress(),
                    const SizedBox(height: 10),
                    _buildPhoneNumber(),
                    const SizedBox(height: 10),
                    _buildAboutMe(),
                    const SizedBox(height: 10),
                    //------------------------------------------------------Website------------------------------------------------------//
                    _buildWebsite(),
                    //------------------------------------------------------Website------------------------------------------------------//
                    const SizedBox(height: 10),
                    //---------------------------------------------- Skill Section ------------------------------------------------------//
                    _buildSkillSection(),
                    //---------------------------------------------- Skill Section ------------------------------------------------------//
                    const SizedBox(height: 10),
                    //----------------------------------------------------Languages------------------------------------------------------//
                    _buildLanguages(),
                    //----------------------------------------------------Languages------------------------------------------------------//
                    const SizedBox(height: 10),
                    //------------------------------------------------------Experience------------------------------------------------------//
                    _buildExperience(),
                    //------------------------------------------------------Experience------------------------------------------------------//
                    const SizedBox(height: 10),
                    //------------------------------------------------------Education------------------------------------------------------//
                    _buildEducation(),
                    //------------------------------------------------------Education------------------------------------------------------//
                    const SizedBox(height: 10),
                    //------------------------------------------------------Projects------------------------------------------------------//
                    _buildProjects(),
                    //------------------------------------------------------Projects------------------------------------------------------//
                    const SizedBox(height: 10),
                    //-------------------------------------------------Certifications-----------------------------------------------------//
                    _buildCertifications(),
                    //-------------------------------------------------Certifications-----------------------------------------------------//
                    const SizedBox(height: 5),
                    const Divider(thickness: 1, color: Colors.white24),
                    const SizedBox(height: 5),
                    //------------------------------------------------------button------------------------------------------------------//
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tip: Save to reuse or edit later",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GlowingStarButton(
                              onPressed: onSavePressed,
                              color: Colors.greenAccent.withOpacity(0.9),
                              child: const Icon(
                                Icons.save_outlined,
                                color: Colors.black38,
                                size: 30,
                              ),
                            ),
      
                            const SizedBox(width: 12),
      
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.white.withOpacity(0.2),
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedTemplate,
                                      style: const TextStyle(color: Colors.white),
                                      dropdownColor: const Color.fromARGB(255, 228, 228, 228).withOpacity(0.9),
                                      elevation: 2,
                                      isDense: true,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTemplate = value;
                                        });
                                      },
                                      items: _templateOptions.map((templateName) {
                                        return DropdownMenuItem<String>(
                                          value: templateName,
                                          child: Text(
                                            templateName,
                                            style: const TextStyle(
                                                color: Colors.black87),
                                          ),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.1),
                                        hintText: 'Select Template',
                                        hintStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric( horizontal: 12, vertical: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
      
                            const SizedBox(width: 12),
      
                            GlowingStarButton(
                              onPressed: () async {
                                _generateAndPreviewResumePdf();
                              },
                              color: Colors.yellowAccent.withOpacity(0.9),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
      
                    //------------------------------------------------------button------------------------------------------------------//
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Profile + photo
        GestureDetector(
          onTap: _pickImage,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: _profileImage != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_profileImage!),
                      )
                    : const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
              ),
            ),
          ),
        ),
        //---- botton delete photo -------//
        if (_profileImage != null)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _profileImage = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.remove,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFirstName() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 0,
            sigmaX: 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(1)),
              cursorColor: Colors.white,
              keyboardType: TextInputType.text,
              controller: _FirstnameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: 'FirstName',
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                //labelText: 'FirstName',
                prefixIcon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLastName() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 0,
            sigmaX: 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(1)),
              cursorColor: Colors.white,
              keyboardType: TextInputType.text,
              controller: _LastnameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: 'LastName',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.supervisor_account_outlined,
                  color: Colors.white,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
                labelStyle: TextStyle(color: Colors.white,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return SizedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 0,
            sigmaX: 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(1)),
              cursorColor: Colors.white,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: 'Email',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.attach_email_outlined,
                  color: Colors.white,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddress() {
    return SizedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 0,
            sigmaX: 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: _addressController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: 'Address',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return SizedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 0,
            sigmaX: 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: _phoneNumberController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: 'Phone Number',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.white,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutMe() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 0,
          sigmaX: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: _aboutMeController,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.center,
            maxLines: 5,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'About Me',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebsite() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 0,
          sigmaX: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Website: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: _addWebsiteField,
                  ),
                ],
              ),
              ..._websiteControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.link, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Website URL',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.white),
                          onPressed: () => _removeWebsiteField(index),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 0,sigmaX: 0,),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.build, color: Colors.white),
                  ),
                  const Text(
                    'Skills:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.category, color: Colors.white),
                        ),
                        Expanded(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white.withOpacity(0.2),
                              dividerColor: Colors.transparent,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: DropdownButtonFormField<String>(
                                value: _selectedSkillCategories[index],
                                style: const TextStyle(color: Colors.white),
                                dropdownColor: const Color.fromARGB(255, 228, 228, 228).withOpacity(0.8),
                                elevation: 0,
                                isDense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSkillCategories[index] = value;
                                    _isCustomCategory[index] = value == 'Custom';
                                    if (value != 'Custom') {
                                      customTitleController.text = value!;
                                    } else {
                                      customTitleController.clear();
                                    }
                                  });
                                },
                                items: _skillCategoryOptions.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle( color: Colors.black54),
                                    ),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  hintText: 'Skill Category',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                          onPressed: () => _addSkillItem(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.white),
                          onPressed: () => _removeSkillCategoryWithItems(index),
                        ),
                      ],
                    ),
                    if (_isCustomCategory[index]) ...[
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: customTitleController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Custom Category Name',
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric( horizontal: 12, vertical: 10),
                            prefixIcon: const Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 5),
                    ..._skillControllers[index].asMap().entries.map((skillEntry) {
                      int skillIndex = skillEntry.key;
                      TextEditingController skillController = skillEntry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0)),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: skillController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Skill',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                              onPressed: () => _removeSkillItem(index, skillIndex),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguages() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 0,
          sigmaX: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.translate, color: Colors.white),
                  ),
                  const Text(
                    'Languages: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: _addLanguageField,
                  ),
                ],
              ),
              ..._languageNameControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController nameController = _languageNameControllers[index];
                TextEditingController levelController = _languageLevelControllers[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.language, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Language Name',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.bar_chart, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: levelController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Proficiency Level',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.white),
                          onPressed: () => _removeLanguageField(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperience() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 0,
          sigmaX: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.work_outline, color: Colors.white),
                  ),
                  const Text(
                    'Experience: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: _addExperienceField,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._ExperienceControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController companyNameController = _companyName[index];
                TextEditingController jobTitleController = _jobTitle[index];
                TextEditingController startDateController = _startdatejob[index];
                TextEditingController endDateController = _enddatejob[index];
                TextEditingController detailController = _detailjob[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.apartment_outlined, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: companyNameController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Company Name',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.white),
                          onPressed: () => _removeExperienceField(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.badge_outlined, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: jobTitleController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Job Title',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.calendar_today, color: Colors.white),
                        ),

                        // Start Date Stack
                        Expanded(
                          child: Stack(
                            children: [
                              TextField(
                                controller: startDateController,
                                readOnly: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Start Date',
                                  hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () => _selectDate(context, true, index),
                              ),
                              if (startDateController.text.isNotEmpty)
                                Positioned(
                                  top: 0,
                                  right: 40,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        startDateController.clear();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // End Date Stack
                        Expanded(
                          child: Stack(
                            children: [
                              TextField(
                                controller: endDateController,
                                readOnly: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'End Date',
                                  hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () => _selectDate(context, false, index),
                              ),
                              if (endDateController.text.isNotEmpty)
                                Positioned(
                                  top: 0,
                                  right: 40,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        endDateController.clear();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: detailController,
                                maxLines: null,
                                expands: true,
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Job Description',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.description_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducation() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 0,
          sigmaX: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.school, color: Colors.white),
                  ),
                  const Text(
                    'Education:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: _addEducationField,
                  ),
                ],
              ),
              ..._educationControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController startDateEducationController = _startEducation[index];
                TextEditingController endDateEducationController = _endEducation[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.account_balance, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _universityName[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'University Name',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.white),
                          onPressed: () => _removeEducationField(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.school, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _degreeTitle[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Degree Title',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.calendar_today, color: Colors.white),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              TextField(
                                controller: startDateEducationController,
                                readOnly: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Start Year',
                                  hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                            lastDate: DateTime(DateTime.now().year),
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
                              if (startDateEducationController.text.isNotEmpty)
                                Positioned(
                                  top: 0,
                                  right: 90,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        startDateEducationController.clear();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Stack(
                            children: [
                              TextField(
                                controller: endDateEducationController,
                                readOnly: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'End Year',
                                  hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                            lastDate: DateTime(DateTime.now().year),
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
                              if (endDateEducationController.text.isNotEmpty)
                                Positioned(
                                  top: 0,
                                  right: 90,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        endDateEducationController.clear();
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjects(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 0,
          sigmaX: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          //padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.work_outline, color: Colors.white),
                  ),
                  const Text(
                    'Projects:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: _addProjectField,
                  ),
                ],
              ),
              ..._projectTitleControllers.asMap().entries.map((entry) {
                int index = entry.key;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.title, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _projectTitleControllers[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Project Title',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.white),
                          onPressed: () => _removeProjectField(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.description, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _projectDescriptionControllers[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.link, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _projectLinkControllers[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Project Link',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.code, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _projectTechControllers[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Technologies Used',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertifications() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 0,
          sigmaX: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          //padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.card_membership, color: Colors.white),
                  ),
                  const Text(
                    'Certifications:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                    onPressed: _addCertificationField,
                  ),
                ],
              ),
              ..._certificationTitleControllers.asMap().entries.map((entry) {
                int index = entry.key;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.label, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _certificationTitleControllers[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Certification Title',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.white),
                          onPressed: () => _removeCertificationField(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.business, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _certificationIssuerControllers[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Issuer',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.calendar_today, color: Colors.white),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _certificationDateControllers[index],
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Date',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    //const Divider(thickness: 1, color: Colors.white24),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

}
