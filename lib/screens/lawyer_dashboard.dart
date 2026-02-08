import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/models/feed_post.dart';
import 'package:flutter_application_1/providers/feed_controller.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LawyerDashboard extends ConsumerWidget {
  const LawyerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.lawyer),
          bottom: TabBar.secondary(
            tabs: [
              Tab(icon: const Icon(Icons.feed_outlined), text: l10n.feed),
              Tab(icon: const Icon(Icons.inbox_outlined), text: l10n.inbox),
              const Tab(
                icon: Icon(Icons.auto_awesome_outlined),
                text: 'AI Tools',
              ),
            ],
          ),
        ),

        body: const TabBarView(
          children: [SocialFeed(), InboxView(), AIToolsView()],
        ),

        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('New Post'),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final created = await showDialog<bool>(
              context: context,
              builder: (_) => const NewPostDialog(),
            );
            if (created == true) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Post created')),
              );
            }
          },
        ),
      ),
    );
  }
}

class SocialFeed extends ConsumerWidget {
  const SocialFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedProvider);

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (_, i) => FeedCard(post: posts[i]),
    );
  }
}

class FeedCard extends ConsumerWidget {
  final FeedPost post;
  const FeedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(feedProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundLight,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      post.title, // Treating title as role/subtitle for now
                      style: GoogleFonts.sora(
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.toggleFollow(post.id);
                },
                style: TextButton.styleFrom(
                  foregroundColor: post.following
                      ? AppColors.textSecondaryLight
                      : AppColors.primary,
                  textStyle: GoogleFonts.sora(fontWeight: FontWeight.w600),
                ),
                child: Text(post.following ? 'Following' : 'Follow'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            post.content,
            style: GoogleFonts.sora(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionButton(
                icon: post.liked
                    ? Icons.thumb_up_rounded
                    : Icons.thumb_up_outlined,
                label: '${post.likes}',
                isActive: post.liked,
                onTap: () => controller.toggleLike(post.id),
              ),
              _ActionButton(
                icon: Icons.comment_outlined,
                label: 'Comment',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CommentDialog(),
                  );
                },
              ),
              _ActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Link copied')));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? AppColors.primary
                  : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.sora(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _InboxItem(index: i),
    );
  }
}

class _InboxItem extends StatelessWidget {
  final int index;

  const _InboxItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final hasUnread = index == 0; // Demo logic

    return InkWell(
      onTap: () => context.push('/lawyer-to-client-chat'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasUnread
                ? AppColors.primary.withOpacity(0.3)
                : const Color(0xFFE2E8F0),
            width: hasUnread ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.textSecondaryLight,
                    size: 28,
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Client Name ${index + 1}',
                        style: GoogleFonts.sora(
                          fontSize: 15,
                          fontWeight: hasUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        '10:30 AM',
                        style: GoogleFonts.sora(
                          fontSize: 12,
                          color: hasUnread
                              ? AppColors.primary
                              : AppColors.textSecondaryLight,
                          fontWeight: hasUnread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thank you for the advice regarding the property dispute. I have a few more questions.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.sora(
                      fontSize: 13,
                      color: hasUnread
                          ? AppColors.textPrimaryLight
                          : AppColors.textSecondaryLight,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AIToolsView extends StatelessWidget {
  const AIToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 80, color: scheme.primary),
          const SizedBox(height: 16),
          Text(
            'Lawyer AI Assistant',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 8),
          const Text('Summarize docs, research case laws, and more.'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/ai-chat'),
            icon: const Icon(Icons.analytics),
            label: const Text('Analyze Case File'),
          ),
        ],
      ),
    );
  }
}

class NewPostDialog extends StatelessWidget {
  const NewPostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Post'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: InputDecoration(labelText: 'Title')),
          SizedBox(height: 8),
          TextField(decoration: InputDecoration(labelText: 'Post')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Post'),
        ),
      ],
    );
  }
}

class CommentDialog extends StatelessWidget {
  const CommentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Comment'),
      content: const TextField(
        decoration: InputDecoration(hintText: 'Write...'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Comment posted')));
          },
          child: const Text('Post'),
        ),
      ],
    );
  }
}
