import 'package:flutter/material.dart';
import 'package:flutter_resume_app/colors/background_color.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {

    SizeConfig.init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          //---------------------------------------- background color -------------------------------------//
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: BackgroundColors.iBackgroundColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          //---------------------------------------- background color -------------------------------------//
          //---------------------------------------- background star --------------------------------------//
          TwinklingStarsBackground(
            starColors: const [Colors.white],
            starShapes: [
              StarShape.diamond,
              StarShape.fivePoint,
              StarShape.sixPoint,
              StarShape.sparkle3
            ],
            child: const SizedBox.expand(),
          ),
          //---------------------------------------- background star -------------------------------------//
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                                  gradient: LinearGradient(
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
                                        starShapes: [
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
                        ],
                      ),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyHeaderDelegate(
                    minHeight: 200,
                    maxHeight: 400,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*_buildNewResumeButton(isLandscape),
                          const SizedBox(height: 8),
                          _buildMyResumeHeader(isLandscape),
                          const SizedBox(height: 8),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 8),
                          Expanded(child: buildResumeListFuture(),),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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