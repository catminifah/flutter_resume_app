import 'package:flutter/material.dart';
import 'package:flutter_resume_app/onboarding/onboarding_home_widget_state.dart';
import 'package:flutter_resume_app/size_config.dart';
import 'package:flutter_resume_app/star/sparkle_burst.dart';
import 'package:flutter_resume_app/star/star8_painter.dart';
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
  final List<IconData> icons = [
    Icons.home,
    Icons.file_open_rounded,
    Icons.settings,
  ];

  final List<String> labels = ['Home', 'Create', 'Setting'];

  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<Color> selectedColors = const [
    Color(0xFFF7CFD8),
    Color(0xFFA6D6D6),
    Color(0xFF8E7DBE),
  ];

  final List<Color> selectediconColors = const [
    Color(0xFFB64F6A),
    Color(0xFF4F9C9C),
    Color(0xFF5A459B),
  ];

  late final List<GlobalKey> _itemKeys;

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
    _itemKeys = List.generate(icons.length, (_) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final List<Map<String, String>> resumes = [
      {
        'title': '20240526-01',
        'date': '26/05/2024 14:05',
        'size': '226MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
      {
        'title': '20240522-04',
        'date': '22/05/2024 12:52',
        'size': '37MB',
        'pages': '1 หน้า',
      },
    ];

    bool isTablet = Device.get().isTablet;
    bool isPhone = Device.get().isPhone;

    final actualHeight = isTablet == true ? SizeConfig.scaleH(220) : SizeConfig.scaleH(100);
    final THeight = isTablet == true ? SizeConfig.scaleH(500) : SizeConfig.scaleH(460);

    return Scaffold(
      //backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          //---------------------------------------- background color -------------------------------------//
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF010A1A),
                  Color(0xFF092E6E),
                  Color(0xFF254E99)
                ],
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
                          const SizedBox(height: 8),
                          _buildMyResumeHeader(isLandscape),
                          const SizedBox(height: 8),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 8),
                          Expanded(
                            child: buildResumeList(resumes),
                          ),
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
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 100,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF010A1A),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(icons.length, (index) {
                          final isSelected = _currentIndex == index;
                          final wasSelected = _previousIndex == index;
                          final selectedColor =
                              selectedColors[index % selectedColors.length];
                          final selectediconColor = selectediconColors[
                              index % selectediconColors.length];
                          final Offset offset;
                          return GestureDetector(
                            key: _itemKeys[index],
                            onTap: () {
                              final context = _itemKeys[index].currentContext;
                              if (context == null) return;
        
                              if (_currentIndex != index) {
                                setState(() {
                                  _previousIndex = _currentIndex;
                                  _currentIndex = index;
                                });

                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  final renderBox = context.findRenderObject();
                                  if (renderBox is RenderBox) {
                                    final position = renderBox.localToGlobal(Offset.zero);
                                    final overlay = Overlay.of(context);
                                    late final OverlayEntry overlayEntry;
        
                                    final isSelected = _currentIndex == index;
                                    final transformOffsetX = isSelected ? 0.0 : 90.0;
                                    final transformOffsetY = isSelected ? -35.0 : 0.0;
        
                                    overlayEntry = OverlayEntry(
                                      builder: (context) => SparkleBurstEffect(
                                        center: Offset(
                                          position.dx + renderBox.size.width / 2 + transformOffsetX,
                                          position.dy + renderBox.size.height / 2 + transformOffsetY,
                                        ),
                                        radius: 60,
                                        sparkleCount: 15,
                                        colors: [
                                          Color(0xFF7BD3EA),
                                          Color(0xFFA1EEBD),
                                          Color(0xFFF6F7C4),
                                          Color(0xFFF6D6D6),
                                        ],
                                        sizes: [8, 12, 16],
                                        starShapes: [
                                          StarShapes.fivePoint,
                                          StarShapes.sixPoint,
                                          StarShapes.diamond,
                                          StarShapes.sparkle3,
                                        ],
                                        duration: Duration(milliseconds: 800),
                                        onComplete: () {
                                          overlayEntry.remove();
                                        },
                                      ),
                                    );
        
                                    overlay.insert(overlayEntry);
                                  }
                                });
                                setState(() {
                                  _currentIndex = index;
                                });
                              }
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                if (wasSelected && _currentIndex != index)
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 400),
                                    top: 0,
                                    curve: Curves.easeOut,
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 400),
                                      opacity: 0,
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: selectedColor.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                  transform: Matrix4.translationValues( 0, isSelected ? -30 : 0, 0),
                                  width: 70,
                                  height: 70,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedRotation(
                                        turns: isSelected ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 1000),
                                        curve: Curves.easeOut,
                                        child: CustomPaint(
                                          painter: Star8Painter(color: isSelected ? selectedColor : Colors.transparent,),
                                          child: SizedBox( width: 70,height: 70,),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedScale(
                                            scale: isSelected ? 1.3 : 1.0,
                                            duration: const Duration(milliseconds: 300),
                                            child: Icon(
                                              icons[index],
                                              color: isSelected ? const Color(0xFF010A1A).withOpacity(0.6) : Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            labels[index],
                                            style: TextStyle(
                                              color: isSelected ? const Color(0xFF010A1A).withOpacity(0.6) : Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: IgnorePointer(
                      child: TwinklingStarsBackground(
                        starColors: const [
                          Color(0xFFFFE1E0),
                          Color(0xFFF49BAB),
                          Color(0xFF9B7EBD),
                          Color(0xFF7F55B1),
                        ],
                        starShapes: [
                          StarShape.diamond,
                          StarShape.fivePoint,
                          StarShape.sixPoint,
                          StarShape.sparkle3,
                        ],
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                          starColors: const [
                            Color(0xFFFFE1E0),
                            Color(0xFFF49BAB),
                            Color(0xFF9B7EBD),
                            Color(0xFF7F55B1),
                          ],
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
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: SizeConfig.scaleH(40),
          width: double.infinity,
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
                  border: Border.all(
                    color: Colors.white30,
                    style: BorderStyle.solid,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: TwinklingStarsBackground(
                    starColors: const [
                      Color(0xFFFFE1E0),
                      Color(0xFFF49BAB),
                      Color(0xFF9B7EBD),
                      Color(0xFF7F55B1),
                    ],
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
                    Icon(Icons.add,
                        color: Color(0xFF010A1A).withOpacity(0.9), size: 20),
                    SizedBox(width: SizeConfig.scaleW(8)),
                    Text(
                      'New Resume',
                      style: GoogleFonts.orbitron(
                        fontSize: isLandscape ? 8.sp : 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF010A1A).withOpacity(0.9),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //------------------------------ Widget Button New Resume ----------------------------------------//

  //------------------------------ Widget Resume Header ----------------------------------------//
  Widget _buildMyResumeHeader(var isLandscape) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text('My resume',
            style: GoogleFonts.orbitron(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: isLandscape ? 5.sp : 12.sp,
            )
          ),
          const Spacer(),
          const Icon(Icons.cloud, size: 20, color: Colors.white70),
          SizedBox(width: SizeConfig.scaleW(4)),
          Text('Cloud storage',
            style: GoogleFonts.orbitron(
              color: Colors.white70,
              fontSize: isLandscape ? 5.sp : 12.sp,
            )
          ),
        ],
      ),
    );
  }

  //------------------------------ Widget Resume Header ----------------------------------------//
  Widget buildResumeList(List<Map<String, dynamic>> resumes) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          shrinkWrap: true,
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
                          Color(0xFF4E71FF).withOpacity(0.2),
                          Color(0xFF8DD8FF).withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24, width: 1),
                      /*boxShadow: [
                      BoxShadow(
                        color: Colors.white24.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],*/
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
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
                        item['title'] ?? 'Untitled',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${item['date']} | ${item['size']} | ${item['pages']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      trailing:
                          const Icon(Icons.more_vert, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
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