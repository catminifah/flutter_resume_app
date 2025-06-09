import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/size_config.dart';
import 'package:flutter_resume_app/star/starry_background_painter.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:flutter_resume_app/theme/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Select Language',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('ภาษาไทย',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final maxHeight = mediaQuery.size.height * 0.6;
        final bottomInset = mediaQuery.viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: bottomInset + 16,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: StarryBackgroundPainter(starCount: 40),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Select Theme',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        _buildThemeOption('Pastel Sky'),
                        _buildThemeOption('Galaxy Blue'),
                        _buildThemeOption('Dark Matter'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildThemeOption(String themeName) {
    return ListTile(
      title: Text(themeName, style: const TextStyle(color: Colors.white)),
      onTap: () {
        final provider = context.read<ThemeProvider>();
        if (themeName == 'Galaxy Blue') {
          provider.setTheme(AppTheme.galaxyBlue);
        } else if (themeName == 'Dark Matter') {
          provider.setTheme(AppTheme.darkMatter);
        } else if (themeName == 'Pastel Sky') {
          provider.setTheme(AppTheme.pastelSky);
        }
        Navigator.pop(context);
      },
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[100],
        title: const Text('Reset All Data?'),
        content: const Text('This will erase all resumes and settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data has been reset.')),
              );
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Resume Star',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 YourName',
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text( 'An aesthetic resume builder with starry background themes.'),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      extendBody: true,
      body: DynamicBackground(
        child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.blueAccent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              TwinklingStarsBackground(
                                starCount: 150,
                                starColors: PastelStarColor.iPastelStarColor,
                                starShapes: const [
                                  StarShape.diamond,
                                  StarShape.fivePoint,
                                  StarShape.sixPoint,
                                  StarShape.sparkle3,
                                  StarShape.star4,
                                ],
                                child: const SizedBox.expand(),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/icons_home/setting_resume.png',
                                    width: MediaQuery.of(context).size.height / 5,
                                    height: MediaQuery.of(context).size.height / 5,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 25),
                                  Text(
                                    'Setting',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isLandscape ? 20.sp : 30.sp,
                                      fontFamily: 'SweetLollipop',
                                      letterSpacing: 1,
                                      wordSpacing: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    minHeight: 200,
                    maxHeight: 600,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints( maxWidth: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      _buildSettingTile(
                                        icon: Icons.language,
                                        title: 'Language',
                                        subtitle: 'English',
                                        onTap: _showLanguageDialog,
                                      ),
                                      const Divider(color: Colors.white24),
                                      _buildSettingTile(
                                        icon: Icons.palette,
                                        title: 'Theme',
                                        subtitle: 'Starry Night',
                                        onTap: _showThemeDialog,
                                      ),
                                      const Divider(color: Colors.white24),
                                      _buildSettingTile(
                                        icon: Icons.restart_alt,
                                        title: 'Reset All Data',
                                        subtitle: 'Clear all resume entries',
                                        onTap: _showResetConfirmationDialog,
                                      ),
                                      const Divider(color: Colors.white24),
                                      _buildSettingTile(
                                        icon: Icons.info_outline,
                                        title: 'About App',
                                        subtitle: 'Version 1.0.0',
                                        onTap: _showAboutDialog,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.white70, fontSize: 13.sp))
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
