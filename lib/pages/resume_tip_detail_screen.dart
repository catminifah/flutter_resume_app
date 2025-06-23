import 'package:flutter/material.dart';
import 'package:flutter_resume_app/data/resume_tip_item.dart';
import 'package:flutter_resume_app/star/star_dashed_border_painter.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';

class ResumeTipDetailScreen extends StatelessWidget {
  final ResumeTipItem tip;
  const ResumeTipDetailScreen({required this.tip, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tip.title),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black, // หรือ DynamicBackground ก็ได้
      body: DynamicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildTipCard(context, title: tip.title, description: tip.description),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, {required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomPaint(
        painter: StarDashedBorderPainter(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Orbitron',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                  fontFamily: 'Orbitron',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
