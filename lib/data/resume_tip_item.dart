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
    description: 'Start with clear and concise contact details:\n'
        '• Full name (match official documents)\n'
        '• Phone number (reachable and active)\n'
        '• Professional email (avoid nicknames)\n\n'
        'Avoid including personal details like:\n'
        '• Age\n'
        '• Religion\n'
        '• Marital status\n'
        '• Photo (unless required)',
    icon: Icons.person,
    iconColor: Colors.tealAccent,
    image: "assets/ResumeTipItem/personal_information.png",
  ),
  ResumeTipItem(
    title: 'Career Objective',
    description:
        'Write 1–2 sentences that describe your career goal and how you can add value:\n'
        '• Be specific to the role or company\n'
        '• Mention strengths or experiences\n'
        '• Keep it short and focused',
    icon: Icons.track_changes,
    iconColor: Colors.cyanAccent,
    image: "assets/ResumeTipItem/personal_information.png",
  ),
  ResumeTipItem(
    title: 'Work Experience',
    description:
        'List experiences in reverse-chronological order (most recent first):\n'
        '• Include job title, company name, and dates\n'
        '• Use bullet points to highlight:\n'
        '    • Achievements\n'
        '    • Quantifiable results (e.g., “Increased sales by 20%”)\n'
        '    • Action verbs (e.g., Led, Designed, Improved)\n'
        '• Keep it relevant to the job you are applying for',
    icon: Icons.work,
    iconColor: Colors.orangeAccent,
    image: "assets/ResumeTipItem/work_experience.png",
  ),
  ResumeTipItem(
    title: 'Education',
    description: 'Show your education starting with the highest degree:\n'
        '• Degree name and major\n'
        '• Institution name\n'
        '• Dates attended\n'
        '• Optional: GPA (if above average), awards, relevant coursework',
    icon: Icons.school,
    iconColor: Colors.lightBlueAccent,
    image: "assets/ResumeTipItem/education.png",
  ),
  ResumeTipItem(
    title: 'Skills',
    description: 'Divide your skills into 2 main categories:\n'
        '• Hard Skills: Tools, technologies, languages (e.g., Python, Excel, Photoshop)\n'
        '• Soft Skills: Communication, teamwork, time management\n\n'
        'Tip: Align your skills with the job description to increase relevance.',
    icon: Icons.build,
    iconColor: Colors.greenAccent,
    image: "assets/ResumeTipItem/skills.png",
  ),
  ResumeTipItem(
    title: 'Projects or Portfolio',
    description: 'Showcase your work through relevant projects:\n'
        '• Include project name, description, role, and tools used\n'
        '• Add links to GitHub, portfolio site, or demo\n'
        '• Emphasize the impact or outcome (what problem did you solve?)',
    icon: Icons.folder_special,
    iconColor: Colors.deepPurpleAccent,
    image: "assets/ResumeTipItem/projects_or_portfolio.png",
  ),
  ResumeTipItem(
    title: 'Certifications',
    description: 'Certifications can boost your credibility:\n'
        '• Only include certifications relevant to the position\n'
        '• List title, issuer, and date\n'
        '• Add a link if it’s verifiable online',
    icon: Icons.workspace_premium,
    iconColor: Colors.yellowAccent,
    image: "assets/ResumeTipItem/personal_information.png",
  ),
  ResumeTipItem(
    title: 'What to Avoid',
    description: 'Avoid common resume mistakes:\n'
        '• Spelling and grammar errors\n'
        '• Using one generic resume for all jobs\n'
        '• Overly long resumes (keep it 1–2 pages)\n'
        '• Using clichés (e.g., “hardworking”, “go-getter” without proof)\n'
        '• Adding unrelated experiences just to fill space',
    icon: Icons.cancel,
    iconColor: Colors.redAccent,
    image: "assets/ResumeTipItem/what_to_avoid.jpg",
  ),
];

// const List<ResumeTipItem> resumeTipsThai = [
//   ResumeTipItem(
//     title: 'ข้อมูลส่วนตัว',
//     description:
//         'เริ่มต้นด้วยข้อมูลติดต่อที่ชัดเจนและกระชับ:\n'
//         '• ชื่อ-นามสกุล (ตรงตามเอกสารทางการ)\n'
//         '• เบอร์โทรศัพท์ที่สามารถติดต่อได้\n'
//         '• อีเมลที่ดูเป็นทางการ (หลีกเลี่ยงชื่อเล่นหรือคำไม่สุภาพ)\n\n'
//         'หลีกเลี่ยงการใส่รายละเอียดส่วนตัวที่ไม่จำเป็น เช่น:\n'
//         '• อายุ\n'
//         '• ศาสนา\n'
//         '• สถานภาพสมรส\n'
//         '• รูปถ่าย (ยกเว้นตำแหน่งที่จำเป็นต้องใช้)',
//   ),
//   ResumeTipItem(
//     title: 'เป้าหมายในสายอาชีพ',
//     description:
//         'เขียนสั้น ๆ ประมาณ 1–2 ประโยค เพื่อแสดงเป้าหมายอาชีพและสิ่งที่คุณสามารถมอบให้กับบริษัท:\n'
//         '• ระบุเป้าหมายที่ชัดเจนและสอดคล้องกับงาน\n'
//         '• เน้นจุดแข็งหรือประสบการณ์ของคุณ\n'
//         '• ไม่ยืดยาวหรือคลุมเครือ',
//   ),
//   ResumeTipItem(
//     title: 'ประสบการณ์การทำงาน',
//     description:
//         'เรียงลำดับจากงานล่าสุดไปเก่าที่สุด:\n'
//         '• ระบุตำแหน่ง, ชื่อบริษัท, และช่วงเวลาที่ทำงาน\n'
//         '• ใช้ bullet แสดง:\n'
//         '    • ผลงานที่สำเร็จ\n'
//         '    • ตัวเลขหรือผลลัพธ์ที่วัดได้ (เช่น “เพิ่มยอดขาย 20%”)\n'
//         '    • ใช้คำกริยาแอ็กชัน (เช่น ดำเนินการ, ออกแบบ, พัฒนา)',
//   ),
//   ResumeTipItem(
//     title: 'การศึกษา',
//     description:
//         'เริ่มจากวุฒิการศึกษาสูงสุดก่อน:\n'
//         '• ชื่อวุฒิการศึกษาและสาขาวิชา\n'
//         '• ชื่อสถานศึกษา\n'
//         '• ปีที่เริ่มและจบการศึกษา\n'
//         '• (ถ้ามี) เกียรตินิยม, เกรดเฉลี่ย, หรือรางวัล',
//   ),
//   ResumeTipItem(
//     title: 'ทักษะ',
//     description:
//         'แบ่งทักษะเป็น 2 ประเภทหลัก:\n'
//         '• ทักษะด้านเทคนิค (Hard Skills): เช่น Python, Excel, AutoCAD\n'
//         '• ทักษะด้านบุคคล (Soft Skills): เช่น การสื่อสาร, การทำงานเป็นทีม\n\n'
//         'แนะนำ: เลือกเฉพาะทักษะที่ตรงกับงานที่สมัคร',
//   ),
//   ResumeTipItem(
//     title: 'โปรเจกต์หรือผลงาน',
//     description:
//         'แสดงตัวอย่างงานที่เคยทำจริง:\n'
//         '• ชื่อโปรเจกต์, บทบาทของคุณ, เทคโนโลยีที่ใช้\n'
//         '• เพิ่มลิงก์ (ถ้ามี) เช่น GitHub, เว็บไซต์ผลงาน, หรือเดโม\n'
//         '• อธิบายผลลัพธ์ที่เกิดขึ้น เช่น ปัญหาที่แก้ได้ หรือคุณค่าเพิ่ม',
//   ),
//   ResumeTipItem(
//     title: 'ใบรับรอง',
//     description:
//         'ใบรับรองสามารถเพิ่มความน่าเชื่อถือให้คุณได้:\n'
//         '• ใส่เฉพาะใบรับรองที่เกี่ยวข้องกับงาน\n'
//         '• ระบุชื่อใบรับรอง, ผู้ออกให้, และวันที่ได้รับ\n'
//         '• หากตรวจสอบออนไลน์ได้ ควรใส่ลิงก์ไว้ด้วย',
//   ),
//   ResumeTipItem(
//     title: 'สิ่งที่ควรหลีกเลี่ยง',
//     description:
//         'ข้อผิดพลาดที่พบบ่อยในเรซูเม่:\n'
//         '• สะกดคำผิด หรือมีข้อผิดพลาดด้านไวยากรณ์\n'
//         '• ใช้เรซูเม่เดียวกันทุกงานโดยไม่ปรับให้ตรงกับตำแหน่ง\n'
//         '• ยาวเกินไป (ควรอยู่ใน 1–2 หน้า)\n'
//         '• ใช้คำคลุมเครือ เช่น “ขยัน”, “มุ่งมั่น” โดยไม่มีตัวอย่างรองรับ\n'
//         '• เพิ่มประสบการณ์ที่ไม่เกี่ยวข้องเพียงเพื่อให้ดูเยอะ',
//   ),
// ];