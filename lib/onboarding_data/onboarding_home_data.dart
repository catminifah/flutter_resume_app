class OnboardingItem {
  final String imagePath;
  final String title;

  OnboardingItem({required this.imagePath, required this.title});
}

final List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    imagePath: 'assets/onboarding-style-images/onboarding-style-1.png',
    title: 'Create a resume in just a few steps',
  ),
  OnboardingItem(
    imagePath: 'assets/onboarding-style-images/onboarding-style-2.png',
    title: 'Choose from multiple resume templates',
  ),
  OnboardingItem(
    imagePath: 'assets/onboarding-style-images/onboarding-style-3.png',
    title: 'Export to PDF and share instantly',
  ),
];