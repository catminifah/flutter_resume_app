import 'package:share_plus/share_plus.dart';
import 'dart:io';

Future<void> sharePdf(File file) async {
  try {
    await Share.shareXFiles([XFile(file.path)], text: 'Check out my resume!');
  } catch (e) {
    print('Error sharing PDF: $e');
  }
}