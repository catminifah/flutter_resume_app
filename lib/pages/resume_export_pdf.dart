import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_resume_app/star/glowing_star_button.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ResumeExportPDF extends StatefulWidget {
  final Uint8List? pdfBytes;

  const ResumeExportPDF({super.key, this.pdfBytes});

  @override
  State<ResumeExportPDF> createState() => _ResumeExportPDFState();
}

class _ResumeExportPDFState extends State<ResumeExportPDF> {
  String? localPath;
  int _pages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
  }

  @override
  void initState() {
    super.initState();
    _savePdfTempFile();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
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

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  }

  Future<void> _saveToDownloads() async {
    if (widget.pdfBytes == null) return;

    final status = await Permission.storage.request();

    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory("/storage/emulated/0/Download");
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }
    
    final fileName = 'resume_${DateTime.now().millisecondsSinceEpoch}.pdf';

    if (downloadsDir != null) {
      final file = File("${downloadsDir.path}/$fileName");
      await file.writeAsBytes(widget.pdfBytes!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to ${file.path}')),
      );
    }
    
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
              children: <Widget>[
                const SizedBox(height: 12),
              const Text(
                'Resume Preview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.pdfBytes != null)
                        Text(
                          'Size: ${_formatBytes(widget.pdfBytes!.lengthInBytes)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      
                      if (_pages > 0)
                        Text(
                          'Page ${_currentPage + 1} of $_pages',
                          style: const TextStyle(color: Colors.white70),
                        ),
                    ],
                  ),
              ),
              
              const SizedBox(height: 12),
                // PDF Viewer
                Expanded(
                  //height: MediaQuery.of(context).size.height * 0.65,
                  child: PDFView(
                    filePath: localPath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: false,
                    pageFling: true,
                    fitPolicy: FitPolicy.WIDTH,
                    preventLinkNavigation: false,
                    onRender: (pages) {
                      setState(() => _pages = pages!);
                    },
                    onViewCreated: (controller) {
                      _pdfViewController = controller;
                    },
                    onPageChanged: (page, total) {
                      setState(() {
                        _currentPage = page!;
                        _pages = total!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Save & Share Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GlowingStarButton(
                        onPressed: _saveToDownloads,
                        color: Colors.tealAccent.withOpacity(0.9),
                        child: const Icon(
                          Icons.download,
                          color: Colors.black38,
                          size: 30,
                        ),
                      ),
                      /*ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                        ),
                        icon: const Icon(Icons.download),
                        label: const Text('Save'),
                        onPressed: _saveToDownloads,
                      ),*/
                      GlowingStarButton(
                        onPressed: _sharePdf,
                        color: Colors.indigoAccent.withOpacity(0.9),
                        child: const Icon(
                          Icons.share,
                          color: Colors.black38,
                          size: 30,
                        ),
                      ),
                      /*ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                        ),
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        onPressed: _sharePdf,
                      ),*/
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
