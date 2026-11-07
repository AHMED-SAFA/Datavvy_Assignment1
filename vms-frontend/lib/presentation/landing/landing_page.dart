import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../presentation/auth/login_page.dart';
class LandingPage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const LandingPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 850;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary, Color(0xFF3949AB)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -90,
                right: -60,
                child: _glowCircle(240, AppColors.accent.withValues(alpha: .18)),
              ),
              Positioned(
                bottom: -120,
                left: -70,
                child: _glowCircle(300, Colors.white.withValues(alpha: .08)),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
                  onPressed: onToggleTheme,
                  color: Colors.white,
                  icon: Icon(isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: isWide
                          ? [
                              Expanded(flex: 5, child: _heroContent(context)),
                              const SizedBox(width: 48),
                              Expanded(flex: 4, child: _loginCard(context)),
                            ]
                          : [
                              _heroContent(context),
                              const SizedBox(height: 32),
                              _loginCard(context),
                            ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.directions_car,
                  color: AppColors.primaryDark, size: 34),
            ),
            const SizedBox(width: 14),
            const Text(AppStrings.appTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 44),
        Text('Manage every journey.\nMove your fleet forward.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                )),
        const SizedBox(height: 20),
        Text(
          'A smarter command center for your vehicles, people and daily operations.',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withValues(alpha: .82),
                height: 1.45,
              ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _FeaturePill(icon: Icons.speed, label: 'Live fleet overview'),
            _FeaturePill(icon: Icons.verified_user_outlined, label: 'Secure access'),
            _FeaturePill(icon: Icons.insights_outlined, label: 'Actionable insights'),
          ],
        ),
      ],
    );
  }

  Widget _loginCard(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: .96),
      elevation: 18,
      shadowColor: Colors.black.withValues(alpha: .28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_open_rounded,
                color: AppColors.primary, size: 32),
            const SizedBox(height: 20),
            Text('Welcome back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            const Text('Sign in to open your fleet dashboard.'),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(AppStrings.signIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: .18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
