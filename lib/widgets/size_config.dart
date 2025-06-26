import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockW;
  static late double designWidth;
  static late double designHeight;
  static late double designWidthPortrait;
  static late double designHeightPortrait;
  static late double designWidthLandscape;
  static late double designHeightLandscape;

  static bool isPortrait = true;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData?.size.width ?? 0;
    screenH = _mediaQueryData?.size.height ?? 0;

    if (screenW == 0 || screenH == 0) {
      return;
    }

    isPortrait = (screenH! > screenW!);

    if (isPortrait) {
      designWidthPortrait = 375;
      designHeightPortrait = 812;

      blockW = (screenW! / designWidthPortrait);
      blockH = (screenH! / designHeightPortrait);
    } else {
      designWidthLandscape = 812;
      designHeightLandscape = 375;

      blockW = (screenW! / designWidthLandscape * 0.75);
      blockH = (screenH! / designHeightLandscape * 0.75);
    }

    print('[SizeConfig] w: $screenW h: $screenH orientation: ${isPortrait ? 'portrait' : 'landscape'}');
  }

  static double scaleW(double inputWidth) => (blockW ?? 1.0) * inputWidth;
  static double scaleH(double inputHeight) => (blockH ?? 1.0) * inputHeight;
}
