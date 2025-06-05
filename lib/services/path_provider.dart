import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

Future<File> savePdfToFile(pw.Document pdf) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/resume.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}