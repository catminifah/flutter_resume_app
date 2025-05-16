import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../twinkling_stars_background.dart';
//import 'resume_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // จำลองรายการเรซูเม่เก็บใน List
  List<Map<String, dynamic>> resumes = [
    {
      'id': 1,
      'title': 'Resume for Google',
      'lastEdited': DateTime(2025, 5, 10),
    },
    {
      'id': 2,
      'title': 'Flutter Developer Resume',
      'lastEdited': DateTime(2025, 4, 22),
    },
  ];

  void _deleteResume(int id) {
    setState(() {
      resumes.removeWhere((element) => element['id'] == id);
    });
  }

  /*void _editResume(Map<String, dynamic> resume) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResumeEditScreen(resume: resume),
      ),
    );
  }

  void _createNewResume() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResumeEditScreen(),
      ),
    );
  }*/

  final List<Color> _gradientColors = const [
    Color(0xFF010A1A),
    Color(0xFF092E6E),
    Color(0xFF254E99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Twinkling stars layer
          const TwinklingStarsBackground(child: SizedBox.expand()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Resumes',
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: resumes.isEmpty
                        ? Center(
                            child: Text(
                              'No resumes found.\nTap + to create a new one!',
                              style: GoogleFonts.mulish(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: resumes.length,
                            itemBuilder: (context, index) {
                              final resume = resumes[index];
                              final lastEdited =
                                  resume['lastEdited'] as DateTime;
                              return Card(
                                color: Colors.black.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  title: Text(
                                    resume['title'],
                                    style: GoogleFonts.orbitron(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Last edited: ${lastEdited.day}/${lastEdited.month}/${lastEdited.year}',
                                    style: GoogleFonts.mulish(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Edit',
                                        icon: const Icon(Icons.edit,
                                            color: Colors.yellowAccent),
                                        onPressed: () {}/*=> _editResume(resume)*/,
                                      ),
                                      IconButton(
                                        tooltip: 'Delete',
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () => _deleteResume(resume['id']),
                                      ),
                                    ],
                                  ),
                                  onTap: () {}/*=> _editResume(resume)*/,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){}/*_createNewResume*/,
        backgroundColor: Colors.yellowAccent,
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          'Create New',
          style: GoogleFonts.orbitron(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
