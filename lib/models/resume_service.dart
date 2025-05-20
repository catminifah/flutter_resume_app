import 'dart:convert';
import 'dart:io';
import 'package:flutter_resume_app/models/file_helper.dart';

import '../models/resume_model.dart';

class ResumeService {
  Future<void> saveResume(ResumeModel resume) async {
    final file = await FileHelper.getResumeFile();
    final jsonStr = jsonEncode(resume.toJson());
    await file.writeAsString(jsonStr);
  }

  Future<ResumeModel?> loadResume() async {
    try {
      final file = await FileHelper.getResumeFile();
      if (await file.exists()) {
        final jsonStr = await file.readAsString();
        final data = jsonDecode(jsonStr);
        return ResumeModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error loading resume: $e");
      return null;
    }
  }

  Future<void> deleteResume() async {
    final file = await FileHelper.getResumeFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
