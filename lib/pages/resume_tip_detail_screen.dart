import 'package:flutter/material.dart';
import 'package:flutter_resume_app/data/resume_tip_item.dart';
import 'package:flutter_resume_app/star/star_dashed_border_painter.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';

class ResumeTipDetailScreen extends StatefulWidget {
  final ResumeTipItem tip;
  const ResumeTipDetailScreen({required this.tip, super.key});

  @override
  State<ResumeTipDetailScreen> createState() => _ResumeTipDetailScreenState();
}

class _ResumeTipDetailScreenState extends State<ResumeTipDetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(widget.tip.image), context);
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      backgroundColor: Colors.black,
      body: DynamicBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: imageHeight,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.transparent,
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    widget.tip.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      _buildTipCard(
                        context,
                        title: widget.tip.title,
                        descriptionWidget: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4,
                              fontFamily: 'Orbitron',
                            ),
                            children: _buildDescriptionWithIcons(
                                widget.tip.description),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context, {
    required String title,
    required Widget descriptionWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            painter: StarDashedBorderPainter(),
            child: Container(
              width: constraints.maxWidth,
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
                  descriptionWidget,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<InlineSpan> _buildDescriptionWithIcons(String text) {
    final iconMap = <String, (IconData, Color)>{
      '(check_circle)': (Icons.check_circle_outline, Colors.greenAccent),
      '(block)': (Icons.block_outlined, Colors.redAccent),
      '(warning_amber)': (Icons.warning_amber_outlined, Colors.orangeAccent),
      '(vpn_key)': (Icons.vpn_key_outlined, Colors.lightBlueAccent),
      '(track_changes)': (Icons.track_changes_outlined, Colors.deepPurpleAccent),
      '(school)': (Icons.school_outlined, Colors.amberAccent),
      '(psychology)': (Icons.psychology_outlined, Colors.purpleAccent),
      '(push_pin)': (Icons.push_pin_outlined, Colors.pinkAccent),
      '(link)': (Icons.link_outlined, Colors.indigoAccent),
      '(star)': (Icons.star_border_outlined, Colors.yellowAccent),
      '(emoji_events)': (Icons.emoji_events_outlined, Colors.tealAccent),
      '(error_outline)': (Icons.error_outline_outlined, Colors.deepOrangeAccent),
    };

    final regex = RegExp(r'\((check_circle|block|warning_amber|vpn_key|track_changes|school|psychology|push_pin|link|star|emoji_events|error_outline)\)');

    final parts = text.splitMapJoin(
          regex,
          onMatch: (m) => '|||${m.group(0)}|||',
          onNonMatch: (n) => '|||TXT:$n|||',
        ).split('|||');

    return parts.where((e) => e.isNotEmpty).map<InlineSpan>((part) {
      if (part.startsWith('TXT:')) {
        return TextSpan(
          text: part.substring(4),
          style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        );
      } else if (iconMap.containsKey(part)) {
        return WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
              child: Icon(
                iconMap[part]!.$1,
                size: 20,
                color: iconMap[part]!.$2,
              )
          ),
        );
      } else {
        return TextSpan(text: part);
      }
    }).toList();
  }
}
