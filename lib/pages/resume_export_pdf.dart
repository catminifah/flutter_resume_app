import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ResumeExportPDF extends StatefulWidget {
  final Uint8List? pdfBytes;

  const ResumeExportPDF({Key? key, this.pdfBytes}) : super(key: key);

  @override
  State<ResumeExportPDF> createState() => _ResumeExportPDFState();
}

class _ResumeExportPDFState extends State<ResumeExportPDF> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _savePdfTempFile();
  }

  Future<void> _savePdfTempFile() async {
    if (widget.pdfBytes == null) return;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/user_resume.pdf');
    await file.writeAsBytes(widget.pdfBytes!);
    if (mounted) {
      setState(() {
        localPath = file.path;
      });
    }
  }

  Future<void> _saveToDownloads() async {
    if (widget.pdfBytes == null) return;

    final status = await Permission.storage.request();
    
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to save file')),
      );
      return;
    }

    //final downloadsDir = Directory('/storage/emulated/0/Download');
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    if (downloadsDir == null) {
      throw Exception('Cannot find suitable directory to save file.');
    }

    final fileName = 'resume_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${downloadsDir.path}/$fileName');

    await file.writeAsBytes(widget.pdfBytes!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved to ${file.path}')),
    );
  }

  Future<void> _sharePdf() async {
    if (localPath == null) return;

    await Share.shareXFiles(
      [XFile(localPath!)],
      text: 'Check out my resume!',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (localPath == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: DynamicBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // PDF Viewer
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: PDFView(
                    filePath: localPath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: false,
                    pageFling: true,
                    fitPolicy: FitPolicy.WIDTH,
                    preventLinkNavigation: false,
                  ),
                ),

                const SizedBox(height: 16),

                // Save & Share Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text('Save'),
                        onPressed: _saveToDownloads,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                        ),
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        onPressed: _sharePdf,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
