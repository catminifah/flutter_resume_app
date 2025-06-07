import 'package:flutter/material.dart';
import 'package:flutter_resume_app/colors/background_color.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/models/resume_model.dart';
import 'package:flutter_resume_app/models/resume_service.dart';
import 'package:flutter_resume_app/onboarding/onboarding_home_widget_state.dart';
import 'package:flutter_resume_app/pages/resume_editor.dart';
import 'package:flutter_resume_app/size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinkling_stars/twinkling_stars.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final orientation = MediaQuery.of(context).orientation;
    print("Orientation changed: $orientation");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    bool isTablet = Device.get().isTablet;
    bool isPhone = Device.get().isPhone;
    
    return Scaffold(
      //backgroundColor: Colors.transparent,
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
          //---------------------------------------- background star -------------------------------------//
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
                      //---------------------------------------- AppBar -------------------------------------//
                      _buildAppBar(isLandscape),
                      //---------------------------------------- AppBar -------------------------------------//
                      SizedBox(height: isLandscape ? SizeConfig.scaleH(0) : SizeConfig.scaleH(10)),
                      //------------------------------------- Onboarding -------------------------------------//
                      OnboardingWidgetState(),
                      //------------------------------------- Onboarding -------------------------------------//
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
                          _buildNewResumeButton(isLandscape),
                          const SizedBox(height: 10),
                          _buildMyResumeHeader(isLandscape),
                          //const SizedBox(height: 8),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 8),
                          Expanded(child: buildResumeListFuture(),),
                          const SizedBox(height: 8),
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
  /////////////////////////////////////////////////// Widget //////////////////////////////////////////////////////////////////
  //------------------------------ Widget App bar ----------------------------------------//
  Widget _buildAppBar(var isLandscape) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            width: isLandscape ? SizeConfig.scaleW(125) : SizeConfig.scaleW(95),
            height: SizeConfig.scaleH(40),
            child: Stack(
              children: [
                Container(
                  padding:const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withOpacity(0.5),
                        Colors.blueAccent.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
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
                        Text(
                          'Resume',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isLandscape ? 12.sp : 25.sp,
                            fontFamily: 'SweetLollipop',
                            letterSpacing: 1,
                            wordSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Creat',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isLandscape ? 12.sp : 25.sp,
                  fontFamily: 'SweetLollipop',
                  letterSpacing: 1,
                  wordSpacing: 4,
                ),
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  SizedBox(
                    width: SizeConfig.scaleW(24),
                  ),
                  Text(
                    'e',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isLandscape ? 12.sp : 25.sp,
                      fontFamily: 'SweetLollipop',
                      letterSpacing: 1,
                      wordSpacing: 4,
                    ),
                  ),
                  Positioned(
                    top: isLandscape ? 2 : 2,
                    right: isLandscape ? 2 : 8,
                    child: Icon(
                      Icons.star,
                      size: 9,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  Positioned(
                    top: -1,
                    right: isLandscape ? 0 : 5,
                    child: Icon(
                      Icons.star,
                      size: 6,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.help_outline, color: Colors.white70),
          SizedBox(width: SizeConfig.scaleW(10)),
          const Icon(Icons.settings, color: Colors.white70),
        ],
      ),
    );
  }
  //------------------------------ Widget App bar ----------------------------------------//

  //------------------------------ Widget Button New Resume ----------------------------------------//
  Widget _buildNewResumeButton(var isLandscape) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResumeEditor()),
                );
              },
              child: SizedBox(
                height: SizeConfig.scaleH(80),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF4E71FF).withOpacity(0.9),
                            Color(0xFF8DD8FF).withOpacity(0.9),
                            Color(0xFFBBFBFF).withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: TwinklingStarsBackground(
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
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons_home/new_resume.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: SizeConfig.scaleW(8)),
                          Text(
                            'New\nResume',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: isLandscape ? 8.sp : 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF010A1A).withOpacity(0.9),
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: SizeConfig.scaleH(80),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF9A9E).withOpacity(0.9),
                            Color(0xFFFECFEF).withOpacity(0.9),
                            Color(0xFFF6F3FF).withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: TwinklingStarsBackground(
                          starColors: PastelStarColor.iPastelStarColor,
                          starShapes: [
                            StarShape.fivePoint,
                            StarShape.sparkle3,
                            StarShape.star4,
                          ],
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons_home/guidebook_resume.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: SizeConfig.scaleW(8)),
                          Text(
                            'App\nGuide',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: isLandscape ? 8.sp : 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF010A1A).withOpacity(0.9),
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //------------------------------ Widget Button New Resume ----------------------------------------//

  //------------------------------ Widget Resume Header ----------------------------------------//
  Widget _buildMyResumeHeader(var isLandscape) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud, size: 20, color: Colors.white70),
          SizedBox(width: SizeConfig.scaleW(4)),
          Text('My resume',
            style: TextStyle(
              fontFamily: 'Orbitron',
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: isLandscape ? 5.sp : 12.sp,
            )
          ),
          //const Spacer(),
          /*const Icon(Icons.cloud, size: 20, color: Colors.white70),
          SizedBox(width: SizeConfig.scaleW(4)),
          Text('Cloud storage',
            style: GoogleFonts.orbitron(
              color: Colors.white70,
              fontSize: isLandscape ? 5.sp : 12.sp,
            )
          ),*/
        ],
      ),
    );
  }

  //------------------------------ Widget Resume Header ----------------------------------------//
  Widget buildResumeListFuture() {
    return FutureBuilder<List<ResumeModel>>(
      future: ResumeService.loadAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text(/*'No resumes found.'*/'',style: TextStyle(color: Colors.white70)));
        }

        final resumes = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          itemCount: resumes.length,
          itemBuilder: (context, index) {
            final item = resumes[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4E71FF).withOpacity(0.2),
                          const Color(0xFF8DD8FF).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric( horizontal: 15, vertical: 2),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child:
                            const Icon(Icons.description, color: Colors.white),
                      ),
                      title: Text(
                        '${item.firstname} ${item.lastname}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        item.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white70),
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResumeEditor( resume: item,),
                              ),
                            ).then((_) => setState(() {}));
                          } else if (value == 'delete') {
                            await ResumeService.deleteResume(item.id);
                            setState(() {}); // reload list
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem( value: 'edit', child: Text('Edit')),
                          const PopupMenuItem( value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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