import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getResumeFile() async {
    final path = await _localPath;
    return File('$path/resume_data.json');
  }
}