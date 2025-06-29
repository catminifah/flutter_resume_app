import 'package:flutter/material.dart';

class ResumeTipItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String image;

  ResumeTipItem({
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = Colors.white,
    required this.image,
  });
}

List<ResumeTipItem> resumeTips = [
  ResumeTipItem(
    title: 'Personal Information',
    description: 'Start with clear and up-to-date contact information:\n'
        '• Full name — must match official documents.\n'
        '• Phone number — active and frequently checked.\n'
        '• Professional email — avoid nicknames or unprofessional addresses (e.g., john.doe@gmail.com).\n'
        '• LinkedIn URL or portfolio (if relevant).\n\n'
        '(warning_amber) Avoid including personal or sensitive details unless required:\n'
        '• Age, religion, marital status, ID number.\n'
        '• Photos — unless explicitly asked by employer or standard in the country.\n\n'
        '(check_circle) Keep it simple, clean, and aligned to the job market standards.',
    icon: Icons.person,
    iconColor: Colors.tealAccent,
    image: "assets/ResumeTipItem/personal_information.png",
  ),
  ResumeTipItem(
    title: 'Career Objective',
    description: 'This section should be 1–2 powerful sentences that summarize your career direction:\n'
        '• Tailor it to the job or company — not a generic statement.\n'
        '• Focus on what value you bring and your growth mindset.\n'
        '• Mention specific strengths or aspirations.\n\n'
        '(check_circle) Example:\n'
        '“Aspiring UX Designer with a passion for intuitive interfaces, seeking to contribute design-thinking skills in a collaborative tech environment.”',
    icon: Icons.track_changes,
    iconColor: Colors.cyanAccent,
    image: "assets/ResumeTipItem/career_objective.png",
  ),
  ResumeTipItem(
    title: 'Work Experience',
    description: 'Highlight your work history in reverse chronological order:\n'
        '• Include job title, company name, location, and dates.\n'
        '• Use bullet points to focus on impact and results:\n'
        '   • “Led a 3-person team to deliver project ahead of deadline.”\n'
        '   • “Increased engagement by 35% through content optimization.”\n\n'
        '(vpn_key) Use action verbs: Led, Designed, Analyzed, Implemented.\n'
        '(track_changes) Focus on what’s relevant to the role you are applying for.',
    icon: Icons.work,
    iconColor: Colors.orangeAccent,
    image: "assets/ResumeTipItem/work_experience.png",
  ),
  ResumeTipItem(
    title: 'Education',
    description: 'List your academic background in reverse chronological order:\n'
        '• Degree (e.g., B.A. in Communication Arts)\n'
        '• University name, location\n'
        '• Graduation date or expected date\n'
        '• Relevant coursework, honors, GPA (if strong)\n\n'
        '(school) Tip: You can include certifications or short courses here if no separate section.',
    icon: Icons.school,
    iconColor: Colors.lightBlueAccent,
    image: "assets/ResumeTipItem/education.png",
  ),
  ResumeTipItem(
    title: 'Skills',
    description: 'Break your skills into clear categories for easy readability:\n'
        '• Hard Skills: Programming languages, tools, frameworks, design software.\n'
        '• Soft Skills: Leadership, communication, problem-solving.\n\n'
        '(psychology) Bonus: Use job descriptions as a guide to prioritize what to list.\n'
        '(push_pin) Show level of proficiency (e.g., “Intermediate in Adobe XD”).',
    icon: Icons.build,
    iconColor: Colors.greenAccent,
    image: "assets/ResumeTipItem/skills.png",
  ),
  ResumeTipItem(
    title: 'Projects or Portfolio',
    description: 'Projects show how you apply your skills in real-world scenarios:\n'
        '• Project name and duration\n'
        '• Role and responsibilities\n'
        '• Tools/technologies used\n'
        '• Result or impact (measurable if possible)\n\n'
        '(link) Add links to GitHub, Behance, or portfolio websites.\n'
        '(star) Optional: Screenshots or key features to highlight visual work.',
    icon: Icons.folder_special,
    iconColor: Colors.deepPurpleAccent,
    image: "assets/ResumeTipItem/projects_or_portfolio.png",
  ),
  ResumeTipItem(
    title: 'Certifications',
    description: 'Use certifications to demonstrate verified skills:\n'
        '• Include certification title, issuing organization, and date.\n'
        '• Only list certifications relevant to the job or industry.\n'
        '• Add license number or link to verification if applicable.\n\n'
        '(emoji_events) Examples: “Google UX Design Certificate”, “AWS Certified Developer”.\n'
        '(error_outline) Avoid outdated or irrelevant certificates.',
    icon: Icons.workspace_premium,
    iconColor: Colors.yellowAccent,
    image: "assets/ResumeTipItem/certifications.png",
  ),
  ResumeTipItem(
    title: 'What to Avoid',
    description: 'Common mistakes that reduce your chances:\n'
        '• Spelling and grammar errors — always proofread.\n'
        '• Using one resume for all jobs — tailor it every time.\n'
        '• Overusing generic terms — back up claims with evidence.\n'
        '• Long, cluttered layouts — keep it 1–2 pages and scannable.\n'
        '• Including irrelevant or outdated experiences just to fill space.\n\n'
        '(block) Example to avoid: “Hardworking team player” — without context.',
    icon: Icons.cancel,
    iconColor: Colors.redAccent,
    image: "assets/ResumeTipItem/what_to_avoid.jpg",
  ),
];