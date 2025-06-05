import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/colors/background_color.dart';
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:flutter_resume_app/pdf_templates/resume_template1_generator.dart';
import 'package:twinkling_stars/twinkling_stars.dart';
import 'dart:io';

class ResumePreviewScreen extends StatefulWidget {
  final ResumeModel resume;

  const ResumePreviewScreen({Key? key, required this.resume}) : super(key: key);

  @override
  _ResumePreviewScreenState createState() => _ResumePreviewScreenState();
}

class _ResumePreviewScreenState extends State<ResumePreviewScreen> {
  bool _isLoading = true;
  Uint8List? _pdfBytes;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final file = await ResumeTemplate1Generator.generatePdfFromResume(widget.resume);

    // โหลดเป็น bytes สำหรับ SfPdfViewer.memory
    final bytes = await file.readAsBytes();
    setState(() {
      _pdfBytes = bytes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---------- Background Gradient ------------
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: BackgroundColors.iBackgroundColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ---------- Twinkling Stars ------------
          const TwinklingStarsBackground(
            starColors: [Colors.white],
            starShapes: [
              StarShape.diamond,
              StarShape.fivePoint,
              StarShape.sixPoint,
              StarShape.sparkle3,
            ],
            child: SizedBox.expand(),
          ),

          // ---------- PDF Preview ------------
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _pdfBytes != null
                    ? SfPdfViewer.memory(_pdfBytes!)
                    : const Center(child: Text('Failed to load PDF')),
          ),
        ],
      ),
    );
  }
}
