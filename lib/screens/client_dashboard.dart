import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:flutter_application_1/providers/client_nav_provider.dart';
import 'package:flutter_application_1/widgets/dashboard_widgets.dart';

class ClientDashboard extends ConsumerWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final navIndex = ref.watch(clientNavIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good Morning,", // TODO: l10n
                      style: GoogleFonts.sora(
                        fontSize: 18,
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Alex Johnson", // TODO: data from user provider
                      style: GoogleFonts.sora(
                        fontSize: 28,
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Cards Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    ActionCard(
                      title: l10n.aiChat,
                      subtitle: "Ask legal questions",
                      icon: Icons.chat_bubble_outline_rounded,
                      color: ActionCardColor.purple,
                      onTap: () => context.push('/ai-chat'),
                    ),
                    ActionCard(
                      title: l10n.uploadDocs,
                      subtitle: "Review contracts",
                      icon: Icons.upload_file_rounded,
                      color: ActionCardColor.green,
                      onTap: () => context.push('/upload'),
                    ),
                    ActionCard(
                      title: l10n.findLawyers,
                      subtitle: "Expert consultation",
                      icon: Icons.gavel_rounded,
                      color: ActionCardColor.amber,
                      onTap: () => context.push('/find-lawyers'),
                    ),
                    ActionCard(
                      title: "My Cases", // TODO: l10n
                      subtitle: "Track progress",
                      icon: Icons.folder_open_rounded,
                      color: ActionCardColor.purple, // Reusing purple
                      onTap: () {}, // TODO: Implement My Cases
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Recent Consultations Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.recentConsultations,
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Consultations List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    // specific data for demo
                    final titles = [
                      "Property Dispute",
                      "Contract Review",
                      "Family Law Inquiry",
                    ];
                    final dates = ["2 hours ago", "Yesterday", "Oct 24"];
                    final statuses = ["In Progress", "Completed", "Pending"];

                    return ConsultationItem(
                      title: titles[index],
                      date: dates[index],
                      status: statuses[index],
                      onTap: () {},
                    );
                  },
                ),
              ),

              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),

      // Custom Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          border: Border(
            top: BorderSide(color: AppColors.backgroundLight, width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 20, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.dashboard_rounded,
              label: "Home",
              isActive: navIndex == 0,
              onTap: () {
                ref.read(clientNavIndexProvider.notifier).setIndex(0);
                // Stay here
              },
            ),
            _NavItem(
              icon: Icons.chat_bubble_rounded,
              label: "Chat",
              isActive: navIndex == 1,
              onTap: () {
                ref.read(clientNavIndexProvider.notifier).setIndex(1);
                context.push('/ai-chat');
              },
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: "Profile",
              isActive: navIndex == 2,
              onTap: () {
                ref.read(clientNavIndexProvider.notifier).setIndex(2);
                context.push('/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textSecondaryLight,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? AppColors.primary
                  : AppColors.textSecondaryLight,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 20,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
