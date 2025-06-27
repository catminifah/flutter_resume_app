import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';

class ResumeExportPDF extends StatefulWidget {
  const ResumeExportPDF({super.key});

  @override
  State<ResumeExportPDF> createState() => _ResumeExportPDFState();
}

class _ResumeExportPDFState extends State<ResumeExportPDF> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      extendBody: true,
      body: DynamicBackground(
        child: SafeArea(child: Text(''),)));
  }
}