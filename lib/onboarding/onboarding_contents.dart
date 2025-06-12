class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Create your resume in just minutes.",
    image: "assets/images/image1.png",
    desc: "Fill out simple forms and watch your resume build itself automatically.",
  ),
  OnboardingContents(
    title: "Export and share your resume as a polished PDF.",
    image: "assets/images/image2.png",
    desc: "Download or send your resume with one tap — fast and professional.",
  ),
  OnboardingContents(
    title: "Completely free and effortless to use.",
    image: "assets/images/image3.png",
    desc: "No sign-up required. Just open the app and start building.",
  ),
];