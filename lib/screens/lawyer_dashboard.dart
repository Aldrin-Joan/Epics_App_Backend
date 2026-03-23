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
      length: 4,
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
              const Tab(
                icon: Icon(Icons.person_outline),
                text: 'Profile',
              ),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            SocialFeed(),
            InboxView(),
            AIToolsView(),
            LawyerProfileView(),
          ],
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
      padding: const EdgeInsets.only(top: 12, bottom: 80),
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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: scheme.surfaceContainerHighest,
                child: Icon(Icons.person, color: scheme.onSurface),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: GoogleFonts.sora(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      post.title,
                      style: GoogleFonts.sora(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => controller.toggleFollow(post.id),
                child: Text(post.following ? 'Following' : 'Follow'),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: GoogleFonts.sora(color: scheme.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: post.liked
                    ? Icons.thumb_up
                    : Icons.thumb_up_outlined,
                label: '${post.likes}',
                isActive: post.liked,
                onTap: () => controller.toggleLike(post.id),
              ),
              _ActionButton(
                icon: Icons.comment_outlined,
                label: 'Comment',
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const CommentDialog(),
                ),
              ),
              _ActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {},
              ),
            ],
          )
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
    final color = isActive
        ? AppColors.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.sora(color: color)),
        ],
      ),
    );
  }
}

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            onTap: () => context.push('/lawyer-to-client-chat'),
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text("Client ${i + 1}"),
            subtitle: const Text("New legal query..."),
          ),
        );
      },
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
          Icon(Icons.auto_awesome, size: 60, color: scheme.primary),
          const SizedBox(height: 12),
          Text(
            "AI Assistant",
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () => context.push('/ai-chat'),
            child: const Text("Open AI Chat"),
          )
        ],
      ),
    );
  }
}

class LawyerProfileView extends StatelessWidget {
  const LawyerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: scheme.primaryContainer,
            child: Icon(Icons.person, size: 40, color: scheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            "Adv. Lawyer",
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          _tile(context, "Edit Profile"),
          _tile(context, "My Clients"),
          _tile(context, "Settings"),

          const Spacer(),

         TextButton(
  onPressed: () => context.go('/auth'), 
  child: const Text("Logout"),
)
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
          },
          child: const Text('Post'),
        ),
      ],
    );
  }
}