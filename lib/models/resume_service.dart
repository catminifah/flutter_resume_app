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
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final data = json.decode(content);
      return (data as List).map((e) => ResumeModel.fromJson(e)).toList();
    } catch (e) {
      print('Error loading resumes: $e');
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

  //----------------- new resume -----------------------//
  static Future<void> create(ResumeModel resume) async {
    final resumes = await loadAll();
    resumes.add(resume);
    await saveAll(resumes);
  }

  //----------------- update resume -------------------//
  static Future<void> update(ResumeModel updatedResume) async {
    final resumes = await loadAll();
    final index = resumes.indexWhere((r) => r.id == updatedResume.id);
    if (index != -1) {
      resumes[index] = updatedResume;
      await saveAll(resumes);
    }
  }

  //-------------- select resume from id ----------------//
  static Future<ResumeModel?> loadById(String id) async {
    final resumes = await loadAll();
    try {
      return resumes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

}
