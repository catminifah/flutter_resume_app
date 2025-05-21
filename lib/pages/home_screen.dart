import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final List<IconData> icons = [
    Icons.edit,
    Icons.view_module,
    Icons.folder,
    Icons.person,
  ];

  final List<String> labels = ['แก้ไข', 'แม่แบบ', 'ไลบรารี', 'ฉัน'];

  int _currentIndex = 0;
  final List<Widget> _effects = [];
  final List<GlobalKey> _iconKeys = List.generate(4, (_) => GlobalKey());

  Offset? _tapPosition;

  final List<Color> selectedColors = const [
    Color(0xFFF7CFD8),
    Color(0xFFF4F8D3),
    Color(0xFFA6D6D6),
    Color(0xFF8E7DBE),
  ];

  void _onTapTab(int index, GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context == null) return;

      final RenderBox box = context.findRenderObject() as RenderBox;
      final Offset localPos = box.localToGlobal(Offset.zero);
      final Offset center =
          localPos + Offset(box.size.width / 2, box.size.height / 2);

      print('Tapped at $center');

      setState(() {
        _tapPosition = center;
        _effects.add(
          Positioned(
            left: center.dx - 25,
            top: center.dy - 25,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF8E7DBE).withOpacity(0.4),
              ),
            ),
          ),
        );
        _currentIndex = index;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          _effects.removeAt(0);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
    ];

    return Scaffold(
      //backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
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
          ..._effects,
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    children: [
                      SizedBox(
                        width: 95,
                        height: 40,
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
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
                                    const Text(
                                      'Resume',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
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
                          const Text(
                            'Creat',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 25,
                              fontFamily: 'SweetLollipop',
                              letterSpacing: 1,
                              wordSpacing: 4,
                            ),
                          ),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              SizedBox(
                                width: 24,
                              ),
                              const Text(
                                'e',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 25,
                                  fontFamily: 'SweetLollipop',
                                  letterSpacing: 1,
                                  wordSpacing: 4,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 8,
                                child: Icon(
                                  Icons.star,
                                  size: 9,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                              Positioned(
                                top: -1,
                                right: 5,
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
                      const SizedBox(width: 10),
                      const Icon(Icons.settings, color: Colors.white70),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      _IconMenu(icon: Icons.image, label: 'เครื่องมือแก้ไข'),
                      _IconMenu(icon: Icons.camera_alt, label: 'กล้อง'),
                      _IconMenu(icon: Icons.flash_on, label: 'AutoCut'),
                      _IconMenu(icon: Icons.photo, label: 'ภาพถ่ายสินค้า'),
                      _IconMenu(icon: Icons.expand_more, label: 'ขยาย'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 40,
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
                                    color: Color(0xFF010A1A).withOpacity(0.9),
                                    size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'New Resume',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 16,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text('My resume',
                          style: GoogleFonts.orbitron(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                      const Spacer(),
                      const Icon(Icons.cloud, size: 20, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('Cloud storage',
                          style: GoogleFonts.orbitron(
                            color: Colors.white70,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: resumes.length,
                    itemBuilder: (context, index) {
                      final item = resumes[index];
                      return Card(
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.description,
                                color: Colors.white),
                          ),
                          title: Text(item['title'] ?? '',
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            '${item['date']} | ${item['size']} | ${item['pages']}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: const Icon(
                            Icons.more_vert,
                            color: Colors.white70),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Container(
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  child: Container(
                    color: const Color(0xFF010A1A).withOpacity(0.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(icons.length, (index) {
                        final isSelected = _currentIndex == index;
                        final selectedColor =
                            selectedColors[index % selectedColors.length];
                        return GestureDetector(
                          onTap: () {
                            _onTapTab(index, _iconKeys[index]);
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            key: _iconKeys[index],
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected ? selectedColor.withOpacity(0.2) : Colors.transparent,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedScale(
                                  scale: isSelected ? 1.3 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    icons[index],
                                    color: isSelected ? selectedColor : Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  labels[index],
                                  style: TextStyle(
                                    color: isSelected ? selectedColor : Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
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
    );
  }
}

class _IconMenu extends StatelessWidget {
  const _IconMenu({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }
}
