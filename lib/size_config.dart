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
    screenW = _mediaQueryData?.size.width;
    screenH = _mediaQueryData?.size.height;

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
  }

  static double scaleW(double inputWidth) => inputWidth * blockW!;
  static double scaleH(double inputHeight) => inputHeight * blockH!;
}