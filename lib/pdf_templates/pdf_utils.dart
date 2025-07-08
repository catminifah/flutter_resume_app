import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Estimate the height of a widget for pagination purposes.
double estimateWidgetHeight(pw.Widget widget) {
  if (widget is pw.SizedBox) {
    try {
      final height = (widget as dynamic).height;
      if (height is double) return height;
    } catch (_) {}
    return 10;
  }

  if (widget is pw.Text) {
    try {
      final text = (widget as dynamic).text.toString();
      final style = (widget as dynamic).style;
      final fontSize = style?.fontSize ?? 12.0;
      final lineCount = (text.length / 80).ceil(); // Estimate: 80 chars per line
      return fontSize * lineCount + 4;
    } catch (_) {
      return 16.0;
    }
  }

  if (widget is pw.Row) {
    try {
      final children = (widget as dynamic).children;
      final heights = children.map(estimateWidgetHeight).toList();
      return heights.reduce((a, b) => a > b ? a : b) + 4;
    } catch (_) {
      return 20.0;
    }
  }

  if (widget is pw.Column) {
    try {
      final children = (widget as dynamic).children;
      return children.fold<double>( 0.0, (sum, child) => sum + estimateWidgetHeight(child));
    } catch (_) {
      return 40.0;
    }
  }

  if (widget is pw.Padding) {
    try {
      final child = (widget as dynamic).child;
      final padding = (widget as dynamic).padding as pw.EdgeInsets;
      return estimateWidgetHeight(child) + padding.top + padding.bottom;
    } catch (_) {
      return 20.0;
    }
  }

  if (widget is pw.Divider) return 8;

  return 20.0;
}

/// Split widgets into pages based on maxHeightPerPage
List<List<pw.Widget>> paginateWidgets(
  List<pw.Widget> widgets,
  double maxHeightPerPage,
) {
  final List<List<pw.Widget>> pages = [];
  List<pw.Widget> currentPage = [];
  double currentHeight = 0;

  for (var widget in widgets) {
    final double estimatedHeight = estimateWidgetHeight(widget);

    if (estimatedHeight > maxHeightPerPage) {
      print('Widget too tall for a single page: $estimatedHeight > $maxHeightPerPage');
    }

    if (currentHeight + estimatedHeight > maxHeightPerPage && currentPage.isNotEmpty) {
      pages.add(currentPage);
      currentPage = [];
      currentHeight = 0;
    }

    currentPage.add(widget);
    currentHeight += estimatedHeight;
  }

  if (currentPage.isNotEmpty) {
    pages.add(currentPage);
  }

  return pages;
}

/// Split long string into paragraphs (as multiple Text widgets) for better pagination.
List<pw.Widget> splitTextToParagraphs(
  String text, {
  double fontSize = 10,
  PdfColor color = PdfColors.grey800,
  pw.Font? font,
}) {
  const int maxLength = 100;
  final paragraphs = <pw.Widget>[];
  final buffer = StringBuffer();
  int currentLength = 0;

  final words = RegExp(r'(\s+|[^\s]+)').allMatches(text).map((m) => m.group(0)!).toList();

  for (final word in words) {
    if (currentLength + word.length > maxLength) {
      if (buffer.isNotEmpty) {
        paragraphs.add(
          pw.Text(buffer.toString().trim(),
              style: pw.TextStyle(fontSize: fontSize, color: color, font: font)),
        );
        buffer.clear();
        currentLength = 0;
      }
    }
    buffer.write(word);
    currentLength += word.length;
  }
  
  if (buffer.isNotEmpty) {
    paragraphs.add(
      pw.Text(buffer.toString().trim(),
          style: pw.TextStyle(fontSize: fontSize, color: color, font: font)),
    );
  }

  return paragraphs;
}
