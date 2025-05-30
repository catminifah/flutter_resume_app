import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'resume_model.dart';

class ResumeService {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/resumes.json');
  }

  static Future<List<ResumeModel>> loadAll() async {
    try {
      final file = await _getFile();
      if (!(await file.exists())) return [];
      final data = json.decode(await file.readAsString());
      return (data as List).map((e) => ResumeModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveAll(List<ResumeModel> resumes) async {
    final file = await _getFile();
    final jsonData = resumes.map((e) => e.toJson()).toList();
    await file.writeAsString(json.encode(jsonData));
  }

  static Future<void> deleteResume(String id) async {
    final resumes = await loadAll();
    resumes.removeWhere((r) => r.id == id);
    await saveAll(resumes);
  }
}
