import 'package:fishtrack/features/onboarding/presentation/widget/onboarding_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      icon: Icons.location_on_rounded,
      title: 'Track Your Boat',
      description:
      'Stay connected with your boat and monitor your fishing trip while you are at sea.',
    ),
    OnboardingData(
      icon: Icons.phishing_rounded,
      title: 'Sell & Auction Your Catch',
      description:
      'Sell your fresh catch directly to vendors or participate in live fish auctions.',
    ),
    OnboardingData(
      icon: Icons.sos_rounded,
      title: 'Stay Safe at Sea',
      description:
      'Send an emergency SOS and quickly notify nearby boats and administrators when help is needed.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _goToLogin();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(
      context,
      '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------
            // Skip Button
            // ------------------------------------------------
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 8,
                ),
                child: TextButton(
                  onPressed: _goToLogin,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ------------------------------------------------
            // Onboarding Pages
            // ------------------------------------------------
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _pages[index],
                  );
                },
              ),
            ),

            // ------------------------------------------------
            // Page Indicator
            // ------------------------------------------------
            _buildPageIndicator(),

            const SizedBox(height: 30),

            // ------------------------------------------------
            // Next / Get Started
            // ------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
            (index) {
          final bool isSelected = _currentPage == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: isSelected ? 28 : 8,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue
                  : AppColors.cardBorder,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}