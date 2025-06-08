import 'package:flutter/material.dart';
import 'package:flutter_resume_app/theme/Background/dark_matter_background.dart';
import 'package:flutter_resume_app/theme/Background/galaxy_blue_background.dart';
import 'package:flutter_resume_app/theme/Background/pastel_sky_background.dart';
import 'package:provider/provider.dart';

import 'theme_provider.dart';

class DynamicBackground extends StatelessWidget {
  final Widget child;

  const DynamicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    switch (theme) {
      case AppTheme.galaxyBlue:
        return GalaxyBlueBackground(child: child);
      case AppTheme.darkMatter:
        return DarkMatterBackground(child: child);
      case AppTheme.pastelSky:
        return PastelSkyBackground(child: child);
    }
  }
}
