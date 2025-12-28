import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_1/models/feed_post.dart';
import 'package:flutter_application_1/providers/feed_controller.dart';

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

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(post.author),
            subtitle: Text(post.title),
            trailing: TextButton(
              onPressed: () {
                controller.toggleFollow(post.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(post.following ? 'Unfollowed' : 'Following'),
                  ),
                );
              },
              child: Text(post.following ? 'Following' : 'Follow'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(post.content),
          ),
          const SizedBox(height: 8),
          OverflowBar(
            spacing: 8,
            overflowSpacing: 8,
            children: [
              IconButton(
                icon: Icon(
                  post.liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                ),
                onPressed: () => controller.toggleLike(post.id),
              ),
              Text('${post.likes}'),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CommentDialog(),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
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

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, i) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.account_circle)),
        title: Text('Client Name ${i + 1}'),
        subtitle: const Text('Thank you for the advice.'),
        trailing: const Text('10:30 AM'),
        onTap: () => context.push('/ai-chat'),
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
