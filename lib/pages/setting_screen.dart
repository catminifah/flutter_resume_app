import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/widgets/size_config.dart';
import 'package:flutter_resume_app/star/starry_background_painter.dart';
import 'package:flutter_resume_app/star/twinkling_star_icon.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:flutter_resume_app/theme/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
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
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                    child: CustomPaint(
                      painter: StarryBackgroundPainter(starCount: 40),
                    ),
                  ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Select Language',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                        Divider(color: Colors.white24.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        ListTile(
                          title: const Text('English',
                              style: TextStyle(color: Colors.white,fontFamily: 'Orbitron',)),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('ภาษาไทย',
                              style: TextStyle(color: Colors.white,fontFamily: 'Orbitron',)),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _clearCache() async {
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared successfully')),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: StarryBackgroundPainter(starCount: 40),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Select Theme',
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Orbitron',
                            color: Colors.white,
                          ),
                        ),
                        Divider(color: Colors.white24.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        _buildThemeOption('Pastel Sky'),
                        _buildThemeOption('Galaxy Blue'),
                        _buildThemeOption('Dark Matter'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildThemeOption(String themeName) {
    return ListTile(
      horizontalTitleGap: 3,
      leading: TwinklingStarIcon(
        size: 15,
        colorPool: themeName == 'Galaxy Blue'
            ? [Color(0xFF4F91FF), Color(0xFF70D7FF), Colors.white]
            : themeName == 'Dark Matter'
                ? [
                    Color.fromARGB(255, 200, 160, 218),
                    Color.fromARGB(255, 157, 133, 214),
                    Colors.deepPurpleAccent
                  ]
                : [Color(0xFFEFA6B3), Color(0xFF7FB7B7), Colors.white],
      ),
      title: Text(
        themeName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'MidnightConstellations',
        ),
      ),
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


  void _showClearCacheDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 210,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF03001C).withOpacity(0.8),
                        Color(0xFF301E67).withOpacity(0.8),
                        Color(0xFF5B8FB9).withOpacity(0.8),
                        Color(0xFFB6EADA).withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                TwinklingStarsBackground(
                  starColors: const [Colors.white],
                  starShapes: [
                    StarShape.diamond,
                    StarShape.fivePoint,
                    StarShape.sixPoint,
                    StarShape.sparkle3,
                  ],
                  child: const SizedBox.expand(),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Clear Cache',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Orbitron',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Are you sure you want to clear the cache?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: 'Orbitron',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _clearCache();
                            },
                            /*style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10.withOpacity(0.3),
                              foregroundColor: Colors.white,
                            ),*/
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Resume Star',
          style: TextStyle(
            fontFamily: 'SOLAR_SPACE_DEMO',
            fontSize: 36,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: <Color>[
                  Colors.purple,
                  Colors.blueAccent,
                ],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2025 YourName',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'An aesthetic resume builder with starry background themes.',
              style: TextStyle(
                fontFamily: 'MidnightConstellations',
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
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
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF03001C).withOpacity(0.8),
                          Color(0xFF301E67).withOpacity(0.8),
                          Color(0xFF5B8FB9).withOpacity(0.8),
                          Color(0xFFB6EADA).withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
                                'assets/icons_image/setting_resume.png',
                                width: MediaQuery.of(context).size.height / 5,
                                height: MediaQuery.of(context).size.height / 5,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 25),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    PastelStarColor.SkyBlue,
                                    PastelStarColor.Mauvelous
                                  ],
                                ).createShader(Rect.fromLTWH( 0, 0, bounds.width, bounds.height)),
                                child: Text(
                                  'Setting',
                                  style: TextStyle(
                                    fontSize: isLandscape ? 20.sp : 25.sp,
                                    fontFamily: 'SweetLollipop',
                                    letterSpacing: 1,
                                    wordSpacing: 4,
                                    color: Colors.white,
                                  ),
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
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white24),
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
                          icon: Icons.cleaning_services,
                          title: 'Clear Cache',
                          subtitle: 'Remove temporary stored data',
                          onTap: _showClearCacheDialog,
                        ),
                        const Divider(color: Colors.white24),
                        _buildSettingTile(
                          icon: Icons.info_outline,
                          title: 'About App',
                          subtitle: 'Version 1.0.0',
                          onTap: () => _showCustomAboutDialog(context),
                        ),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: isLandscape ? 10.sp : 16.sp),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.white70, fontSize: isLandscape ? 8.sp : 13.sp))
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white.withOpacity(0.05),
      //contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}